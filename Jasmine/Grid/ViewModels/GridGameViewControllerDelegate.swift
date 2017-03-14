//
//  GridGameViewControllerDelegate.swift
//  Jasmine
//
//  Created by Xien Dong on 14/3/17.
//  Copyright © 2017 nus.cs3217. All rights reserved.
//

import Foundation

protocol GridGameViewControllerDelegate: BaseGameViewControllerDelegate {

    /// Update the database stored in the Grid Game View Controller with a new dataset.
    ///
    /// Note that this does *not* reload all the tiles displayed on the View Controller.
    /// To do so, call a variant of `redisplayTiles`.
    ///
    /// - Parameter database: the mapping of all the coordinates to all the displayed values on
    ///   the grid tiles.
    func updateTiles(with database: [Coordinate: String])

    /// Refreshes the tiles based on the tiles information stored in the View Controller's database.
    ///
    /// Note to call `updateTiles(with database)` if any information in the database should be 
    /// updated.
    func redisplayAllTiles()

    /// Refreshes a selected set of tiles based on the tiles information stored in the VC's database.
    ///
    /// Note to call `updateTiles(with database)` if any information in the database should be
    /// updated.
    ///
    /// - Parameter coordinates: The set of coordinates to be redisplayed.
    func redisplayTiles(at coordinates: Set<Coordinate>)

    /// Refreshes one particular tile based on the tiles information stored in the VC's database.
    ///
    /// Note to call `updateTiles(with database)` if any information in the database should be
    /// updated.
    ///
    /// - Parameter coordinate: The single coordinate to be redisplayed.
    func redisplayTile(at coordinate: Coordinate)
}
