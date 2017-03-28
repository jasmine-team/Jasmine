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
    private static let gravityDirection = CGVector(dx: 0, dy: 1)
    private static let gravityMagnitude: CGFloat = 5.0

    // MARK: Properties

    // MARK: UIDynamics Properties
    private var gravityProperty: UIGravityBehavior!
    private var collisionProperty: UICollisionBehavior!
    private var dynamicItemProperty: UIDynamicItemBehavior!
    private var dynamicsAnimator: UIDynamicAnimator!

    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        enableDynamics()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addPhyicsPropertyToAllViews()
    }

    // MARK: - UI Dynamics (Physics)
    func enableDynamics() {
        dynamicsAnimator = UIDynamicAnimator(referenceView: view)
        setGravityBehaviour()
        setCollisionBehaviour()
        setItemBehaviour()
        setDynamicsBehaviour(asStart: true)
    }

    private func setDynamicsBehaviour(asStart shouldStart: Bool) {
        if shouldStart {
            dynamicsAnimator.addBehavior(gravityProperty)
            dynamicsAnimator.addBehavior(collisionProperty)
            dynamicsAnimator.addBehavior(dynamicItemProperty)
        } else {
            dynamicsAnimator.removeAllBehaviors()
        }
    }

    // MARK: Initialise UI Dynamics
    private func setGravityBehaviour() {
        gravityProperty = UIGravityBehavior(items: Array(detachedTiles))
        gravityProperty.gravityDirection = FallableSquareGridViewController.gravityDirection
        gravityProperty.magnitude = 0.1
    }

    private func setCollisionBehaviour() {
        collisionProperty = UICollisionBehavior(items: Array(self.allTiles))
        collisionProperty.translatesReferenceBoundsIntoBoundary = true
        collisionProperty.collisionDelegate = self
    }

    private func setItemBehaviour() {
        dynamicItemProperty = UIDynamicItemBehavior(items: Array(detachedTiles))
    }

    // MARK: Adding Physics Properties to Views
    private func addPhyicsPropertyToAllViews() {
        detachedTiles.forEach {
            gravityProperty.addItem($0)
            dynamicItemProperty.addItem($0)
        }
        allTiles.forEach {
            collisionProperty.addItem($0)
        }
    }

    private func addPhysicsProperty(to view: UIView) {
        gravityProperty.addItem(view)
        collisionProperty.addItem(view)
        dynamicItemProperty.addItem(view)
    }

    // MARK: - Grid Actions
    override func addDetachedTile(withData data: String,
                                  toCoord coordinate: Coordinate) -> SquareTextView? {
        guard let view = super.addDetachedTile(withData: data, toCoord: coordinate) else {
            return nil
        }
        addPhysicsProperty(to: view)
        dynamicItemProperty.addLinearVelocity(CGPoint(x: 0, y: 30), for: view)
        return view
    }

    override func moveDetachedTile(_ tile: SquareTextView, toAlongXAxis xCoord: CGFloat) {
        setDynamicsBehaviour(asStart: false)
        super.moveDetachedTile(tile, toAlongXAxis: xCoord)
        setDynamicsBehaviour(asStart: true)
    }

    override func snapDetachedTileToNearestCell(_ tile: SquareTextView) {
        setDynamicsBehaviour(asStart: false)
        super.snapDetachedTileToNearestCell(tile)
        setDynamicsBehaviour(asStart: true)
    }
}

extension FallableSquareGridViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem,
                           with item2: UIDynamicItem, at point: CGPoint) {
        print("Collided!")
    }
}
