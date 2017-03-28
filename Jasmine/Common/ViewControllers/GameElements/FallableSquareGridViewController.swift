//
//  FallableSquareGridViewController.swift
//  Jasmine
//
//  Created by Xien Dong on 26/3/17.
//  Copyright © 2017 nus.cs3217. All rights reserved.
//

import UIKit

class FallableSquareGridViewController: DraggableSquareGridViewController {

    // MARK: Constants
    private static let gravityDirection = CGVector(dx: 0, dy: -1)
    private static let gravityMagnitude: CGFloat = 5.0

    // MARK: Properties

    // MARK: UIDynamics Properties
    private var gravityProperty: UIGravityBehavior!
    private var collisionProperty: UICollisionBehavior!
    private var dynamicItemProperty: UIDynamicItemBehavior!

    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        enableDynamics()
    }

    func enableDynamics() {
        setGravityBehaviour()
        setCollisionBehaviour()
        setItemBehaviour()
    }

    private func setGravityBehaviour() {
        gravityProperty = UIGravityBehavior(items: Array(detachedTiles))
        gravityProperty.gravityDirection = FallableSquareGridViewController.gravityDirection
    }

    private func setCollisionBehaviour() {
        collisionProperty = UICollisionBehavior(items: Array(self.allTiles))
        collisionProperty.collisionDelegate = self
    }

    private func setItemBehaviour() {
        dynamicItemProperty = UIDynamicItemBehavior(items: Array(detachedTiles))
    }
}

extension FallableSquareGridViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem,
                           with item2: UIDynamicItem, at point: CGPoint) {

    }
}
