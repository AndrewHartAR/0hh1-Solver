//
//  Board.swift
//  ohhi
//
//  Created by Andrew Hart on 22/11/2014.
//  Copyright (c) 2014 Project Dent. All rights reserved.
//

import Foundation

enum TileType: Int {
    case Red
    case Blue
}

enum LineType {
    case Row
    case Column
}

extension NSIndexPath {
    
    
    convenience init(row: Int, column: Int) {
        self.init(forRow: row, inSection: column)
    }
    
    func column() -> Int {
        return self.section
    }
}

class Board {
    ///Specifies how many tiles of each color a board will have.
    private var tiles: Array<Array<TileType?>>
    private var tilesPerColor: Int
    
    init(tilesPerColor: Int) {
        
        self.tilesPerColor = tilesPerColor
        
        //Setup tiles for blank board based on given tiles per color
        self.tiles = []
        
        var i = 0
        while i < tilesPerColor * 2 {
            var row: Array<TileType?> = []
            
            var i2 = 0
            while i2 < tilesPerColor * 2 {
                row.append(nil)
                
                i2++
            }
            
            self.tiles.append(row)
            
            i++
        }
    }
    
    ///Gives the board tiles with an array for each row, containing an array of each TileType? in that row.
    convenience init(tiles: Array<Array<TileType?>>) {
        var tilesPerColor = Int(ceil(Double(tiles.count / 2)))
        
        self.init(tilesPerColor: tilesPerColor)
        
        self.tiles = tiles
    }
    
    //MARK: - Board information
    
    func tileAtIndexPath(indexPath: NSIndexPath) -> TileType? {
        if indexPath.row < 0 || indexPath.row >= self.tiles.count ||
        indexPath.column() < 0 || indexPath.column() >= self.tiles.count {
            return nil
        }
        
        return self.tiles[indexPath.row][indexPath.column()]
    }
    
    func setTileAtIndexPath(tileType: TileType?, indexPath: NSIndexPath) {
        self.tiles[indexPath.row][indexPath.column()] = tileType
    }
    
    private func tilesInLine(line: Int, lineType: LineType) -> Array<TileType?> {
        if lineType == LineType.Row {
            return self.tiles[line]
        } else {
            var tiles: Array<TileType?> = []
            
            for row: Array<TileType?> in self.tiles {
                tiles.append(row[line])
            }
            
            return tiles
        }
    }
    
    private func tileTypeCountInLine(line: Int, lineType: LineType, tileType: TileType) -> Int {
        var count = 0
        
        for lineTileType: TileType? in tilesInLine(line, lineType: lineType) {
            if tileType == lineTileType {
                count++
            }
        }
        
        return count
    }
    
    //Returns the NSIndexPaths of every tile
    private func tileIndexPaths() -> Array<NSIndexPath> {
        var indexPaths: Array<NSIndexPath> = []
        
        var indexPath = NSIndexPath(row: 0, column: 0)
        
        for row: Array<TileType?> in self.tiles {
            for tile: TileType? in row {
                indexPaths.append(indexPath)
                
                indexPath = NSIndexPath(row: indexPath.row, column: indexPath.column() + 1)
            }
            
            indexPath = NSIndexPath(row: indexPath.row + 1, column: 0)
        }
        
        return indexPaths
    }
    
    //MARK: Completion
    
    private func countOfMissingTileTypesForLine(line: Int, lineType: LineType) -> Int {
        var count = 0
        
        for tile: TileType? in self.tilesInLine(line, lineType: lineType) {
            if tile == nil {
                count++
            }
        }
        
        return count
    }
    
    private func countOfMissingTileTypes() -> Int {
        var count = 0
        
        var i = 0
        while i < self.tiles.count {
            count += countOfMissingTileTypesForLine(i, lineType: LineType.Row)
            
            i++
        }
        
        return count
    }
    
    private func lineIsComplete(line: Int, lineType: LineType) -> Bool {
        return countOfMissingTileTypesForLine(line, lineType: lineType) == 0
    }
    
    private func completedLines(lineType: LineType) -> Array<Array<TileType>> {
        var completedLines: Array<Array<TileType>> = []
        
        var i = 0
        while i < self.tiles.count {
            if lineIsComplete(i, lineType: lineType) {
                completedLines.append(map(tilesInLine(i, lineType: lineType)) { $0! })
            }
            
            i++
        }
        
        return completedLines
    }
    
    func boardIsComplete() -> Bool {
        var i = 0
        while i < self.tiles.count {
            if !lineIsComplete(i, lineType: LineType.Row) {
                return false
            }
            
            i++
        }
        
        return true
    }
    
    //MARK: Equality
    
    //Returns whether two tiles are equal. Nil tiles return false.
    private func tilesAreEqual(firstTile: TileType?, secondTile: TileType?) -> Bool {
        return firstTile == secondTile && firstTile != nil
    }
    
    private func tileCollectionsAreEqual(firstCollection: Array<TileType?>, secondCollection: Array<TileType?>) -> Bool {
        if firstCollection.count != secondCollection.count {
            return false
        }
        
        var i = 0
        
        while i < firstCollection.count {
            if !tilesAreEqual(firstCollection[i], secondTile: secondCollection[i]) {
                return false
            }
            
            i++
        }
        
        return true
    }
    
    //MARK: - Solutions
    
    //MARK: Missing Tile
    
    ///If there are enough of a TileType in a line that there can't be any more, yet our chosen tile is nil,
    ///that means our chosen tile is the opposite TileType.
    func solveTileUsingMissingTileMethod(tilePath: NSIndexPath) {
        if self.tiles[tilePath.row][tilePath.column()] != nil {
            return
        }
        
        if tileTypeCountInLine(tilePath.row, lineType: LineType.Row, tileType: TileType.Blue) == self.tilesPerColor {
            self.tiles[tilePath.row][tilePath.column()] = TileType.Red
        } else if tileTypeCountInLine(tilePath.row, lineType: LineType.Row, tileType: TileType.Red) == self.tilesPerColor {
            self.tiles[tilePath.row][tilePath.column()] = TileType.Blue
        } else if tileTypeCountInLine(tilePath.column(), lineType: LineType.Column, tileType: TileType.Blue) == self.tilesPerColor {
            self.tiles[tilePath.row][tilePath.column()] = TileType.Red
        } else if tileTypeCountInLine(tilePath.column(), lineType: LineType.Column, tileType: TileType.Red) == self.tilesPerColor {
            self.tiles[tilePath.row][tilePath.column()] = TileType.Blue
        }
    }
    
    ///Attempts a solve of the whole board using the missing tile method, passing once over each tile.
    func solveUsingMissingTileMethod() {
        for tileIndexPath: NSIndexPath in self.tileIndexPaths() {
            solveTileUsingMissingTileMethod(tileIndexPath)
        }
    }
    
    //MARK: Three in a row
    
    enum ThreeInARowStyle {
        case BothUp
        case BothDown
        case BothLeft
        case BothRight
        case UpDown
        case LeftRight
    }
    
    ///If the tile being a certain TileType would create a pattern of 3 of the same tile type in a row, then it's invalid.
    ///Thus, it's the other TileType.
    private func solveTileUsingThreeInARowMethod(tilePath: NSIndexPath, style: ThreeInARowStyle) {
        var firstNeighborTile: TileType?
        
        if style == .BothUp {
            firstNeighborTile = self.tileAtIndexPath(NSIndexPath(row: tilePath.row - 2, column: tilePath.column()))
        } else if style == .BothDown {
            firstNeighborTile = self.tileAtIndexPath(NSIndexPath(row: tilePath.row + 2, column: tilePath.column()))
        } else if style == .BothLeft {
            firstNeighborTile = self.tileAtIndexPath(NSIndexPath(row: tilePath.row, column: tilePath.column() - 2))
        } else if style == .BothRight {
            firstNeighborTile = self.tileAtIndexPath(NSIndexPath(row: tilePath.row, column: tilePath.column() + 2))
        } else if style == .UpDown {
            firstNeighborTile = self.tileAtIndexPath(NSIndexPath(row: tilePath.row - 1, column: tilePath.column()))
        } else if style == .LeftRight {
            firstNeighborTile = self.tileAtIndexPath(NSIndexPath(row: tilePath.row, column: tilePath.column() - 1))
        }
        
        //Removes the possibility of there being a match on nil
        if firstNeighborTile == nil {
            return
        }
        
        var secondNeighborTile: TileType?
        
        if style == .BothUp {
            secondNeighborTile = self.tileAtIndexPath(NSIndexPath(row: tilePath.row - 1, column: tilePath.column()))
        } else if style == .BothDown {
            secondNeighborTile = self.tileAtIndexPath(NSIndexPath(row: tilePath.row + 1, column: tilePath.column()))
        } else if style == .BothLeft {
            secondNeighborTile = self.tileAtIndexPath(NSIndexPath(row: tilePath.row, column: tilePath.column() - 1))
        } else if style == .BothRight {
            secondNeighborTile = self.tileAtIndexPath(NSIndexPath(row: tilePath.row, column: tilePath.column() + 1))
        } else if style == .UpDown {
            secondNeighborTile = self.tileAtIndexPath(NSIndexPath(row: tilePath.row + 1, column: tilePath.column()))
        } else if style == .LeftRight {
            secondNeighborTile = self.tileAtIndexPath(NSIndexPath(row: tilePath.row, column: tilePath.column() + 1))
        }
        
        //Returns if there isn't a match here
        if secondNeighborTile != firstNeighborTile {
            return
        }
        
        if firstNeighborTile == TileType.Blue {
            self.tiles[tilePath.row][tilePath.column()] = TileType.Red
        } else if firstNeighborTile == TileType.Red {
            self.tiles[tilePath.row][tilePath.column()] = TileType.Blue
        }
    }
    
    ///If the tile being a certain TileType would create a pattern of 3 of the same tile type in a row, then it's invalid.
    ///Thus, it's the other TileType.
    ///This explores every pattern surrounding a tile.
    private func solveTileUsingThreeInARowMethod(tilePath: NSIndexPath) {
        self.solveTileUsingThreeInARowMethod(tilePath, style: .BothUp)
        self.solveTileUsingThreeInARowMethod(tilePath, style: .BothDown)
        self.solveTileUsingThreeInARowMethod(tilePath, style: .BothLeft)
        self.solveTileUsingThreeInARowMethod(tilePath, style: .BothRight)
        self.solveTileUsingThreeInARowMethod(tilePath, style: .UpDown)
        self.solveTileUsingThreeInARowMethod(tilePath, style: .LeftRight)
    }
    
    ///If the tile being a certain TileType would create a pattern of 3 of the same tile type in a row, then it's invalid.
    ///Thus, it's the other TileType.
    ///This explores the whole board.
    func solveUsingThreeInARowMethod() {
        for tileIndexPath: NSIndexPath in self.tileIndexPaths() {
            solveTileUsingThreeInARowMethod(tileIndexPath)
        }
    }
    
    //MARK: Identical lines
    
    //Lines can't be identical. This method temporarily fills out each line and compares it to other lines.
    //If there's a match, that means the solution is wrong, and the only other remaining solution is correct.
    private func solveLineUsingIdenticalLinesMethod(line: Int, lineType: LineType, blueFirst: Bool) {
        if countOfMissingTileTypesForLine(line, lineType: lineType) != 2 {
            return
        }
        
        var lineTiles = tilesInLine(line, lineType: lineType)
        
        //Fills out a temporary line.
        //This doesn't need to have TileType as optional, but we'll need to convert it later if we don't do it now.
        var temporaryLine: Array<TileType?> = []
        var filledInFirstTileType = false
        
        for tile: TileType? in lineTiles {
            if tile == nil {
                if !filledInFirstTileType {
                    if blueFirst == true {
                        temporaryLine.append(TileType.Blue)
                    } else {
                        temporaryLine.append(TileType.Red)
                    }
                    
                    filledInFirstTileType = true
                } else {
                    if blueFirst == true {
                        temporaryLine.append(TileType.Red)
                    } else {
                        temporaryLine.append(TileType.Blue)
                    }
                }
            } else {
                temporaryLine.append(tile!)
            }
        }
        
        for completedLine: Array<TileType> in completedLines(lineType) {
            
            var completedLineOptional = map(completedLine) { Optional($0) }
            
            if tileCollectionsAreEqual(temporaryLine, secondCollection: completedLineOptional) {
                //This means this combination is invalid, and thus the only other possible combination is valid.
                //We need to form the only other possible combination.
                
                var correctLine: Array<TileType> = []
                var filledInFirstTileType = false
                
                for tile: TileType? in lineTiles {
                    if tile == nil {
                        if !filledInFirstTileType {
                            if blueFirst {
                                correctLine.append(TileType.Red)
                            } else {
                                correctLine.append(TileType.Blue)
                            }
                            
                            filledInFirstTileType = true
                        } else {
                            if blueFirst {
                                correctLine.append(TileType.Blue)
                            } else {
                                correctLine.append(TileType.Red)
                            }
                        }
                    } else {
                        correctLine.append(tile!)
                    }
                }
                
                var correctLineOptional = map(correctLine) { Optional($0) }
                
                if lineType == LineType.Row {
                    self.tiles[line] = correctLineOptional
                } else {
                    var i = 0
                    while i < self.tiles.count {
                        self.tiles[i][line] = correctLineOptional[i]
                        
                        i++
                    }
                }
                
                return
            }
        }
    }
    
    //Lines can't be identical. This method temporarily fills out each line and compares it to other lines.
    //If there's a match, that means the solution is wrong, and the only other remaining solution is correct.
    //This explores both options for a line.
    private func solveLineUsingIdenticalLinesMethod(line: Int, lineType: LineType) {
        solveLineUsingIdenticalLinesMethod(line, lineType: lineType, blueFirst: true)
        solveLineUsingIdenticalLinesMethod(line, lineType: lineType, blueFirst: false)
    }
    
    //Lines can't be identical. This method temporarily fills out each line and compares it to other lines.
    //If there's a match, that means the solution is wrong, and the only other remaining solution is correct.
    //This explores the whole board.
    func solveUsingIdenticalLinesMethod() {
        var i = 0
        while i < self.tiles.count {
            solveLineUsingIdenticalLinesMethod(i, lineType: LineType.Row)
            
            i++
        }
        
        var i2 = 0
        while i2 < self.tiles.count {
            solveLineUsingIdenticalLinesMethod(i2, lineType: LineType.Column)
            
            i2++
        }
    }
    
    //MARK: - Solving puzzle
    
    ///Iterate through solving the whole board, using all techniques, until progress can no longer be made or the board is solved.
    func solve() {
        var progress = true
        
        while progress && countOfMissingTileTypes() > 0 {
            var previousCountOfMissingTileTypes = countOfMissingTileTypes()
            
            solveUsingThreeInARowMethod()
            solveUsingMissingTileMethod()
            solveUsingIdenticalLinesMethod()
            
            progress = previousCountOfMissingTileTypes != countOfMissingTileTypes()
        }
    }
    
    //MARK: - Printing puzzle
    
    func multilineString() -> String {
        var string = ""
        
        for row: Array<TileType?> in self.tiles {
            string = string + "|"
            
            for tileType: TileType? in row {
                if tileType == nil {
                    string = string + " "
                } else if tileType == TileType.Blue {
                    string = string + "B"
                } else if tileType == TileType.Red {
                    string = string + "R"
                }
                
                string = string + "|"
            }
            
            string = string + "\n"
        }
        
        return string
    }
}















