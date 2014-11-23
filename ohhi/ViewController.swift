//
//  ViewController.swift
//  ohhi
//
//  Created by Andrew Hart on 21/11/2014.
//  Copyright (c) 2014 Project Dent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        var board = Board(tilesPerColor: 2)
//        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 0, column: 0))
//        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 0, column: 1))
//        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 3, column: 1))
//        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 2, column: 3))
        
//        var board = Board(tilesPerColor: 3)
//        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 0, column: 3))
//        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 0, column: 4))
//        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 1, column: 0))
//        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 2, column: 2))
//        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 0, column: 1))
//        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 1, column: 1))
//        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 4, column: 2))
//        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 4, column: 3))
//        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 4, column: 5))
        
        var board = Board(tilesPerColor: 4)
        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 0, column: 0))
        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 0, column: 4))
        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 2, column: 6))
        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 4, column: 1))
        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 4, column: 3))
        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 5, column: 2))
        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 5, column: 7))
        board.setTileAtIndexPath(TileType.Blue, indexPath: NSIndexPath(row: 6, column: 1))
        
        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 0, column: 6))
        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 1, column: 5))
        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 2, column: 3))
        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 3, column: 4))
        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 4, column: 6))
        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 5, column: 4))
        board.setTileAtIndexPath(TileType.Red, indexPath: NSIndexPath(row: 5, column: 5))
        
        board.solve()
        
        println(board.multilineString())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

