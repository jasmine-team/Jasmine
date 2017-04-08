import UIKit
import CoreMotion

/// A background of falling flowers.
class FallingFlowersViewController: UIViewController {

    // MARK: Constants
    private static let spawnCount = 200

    private static let flowerSizeMin = 30.0
    private static let flowerSizeMax = 70.0

    private static let flowerSpeedMin = 30.0
    private static let flowerSpeedMax = 50.0

    private static let flowerAngleMin = -30.0
    private static let flowerAngleMax = 30.0

    // MARK: Animation Properties
    private var animator: UIDynamicAnimator!
    private var gravityBehaviour: UIGravityBehavior!
    private var itemBehaviour: UIDynamicItemBehavior!
    private var collisionBehaviour: UICollisionBehavior!

    private let accelerometer = CMMotionManager()

    // MARK: Generator Properties
    private var hasSpawned = false

    private var flowerSize: CGSize {
        let width = Random.double(from: FallingFlowersViewController.flowerSizeMin,
                                  toInclusive: FallingFlowersViewController.flowerSizeMax)
        return CGSize(width: width, height: width)
    }

    private var flowerSource: CGPoint {
        let randomX = Random.double(from: Double(view.bounds.minX),
                                    toInclusive: Double(view.bounds.maxX))
        return CGPoint(x: randomX, y: -10)
    }

    private var flowerLinearSpeed: CGPoint {
        let speedY = Random.double(from: FallingFlowersViewController.flowerSpeedMin,
                                   toInclusive: FallingFlowersViewController.flowerSpeedMax)
        return CGPoint(x: 0, y: speedY)
    }

    private var flowerAngularSpeed: CGFloat {
        let angularSpeed = Random.double(from: FallingFlowersViewController.flowerAngleMin,
                                         toInclusive: FallingFlowersViewController.flowerAngleMax)
        return CGFloat(angularSpeed)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !hasSpawned else {
            return
        }
        hasSpawned = true

        startAnimation()
        startAccelerometerUpdate()
        for _ in 0..<FallingFlowersViewController.spawnCount {
            generateFlower()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        accelerometer.stopAccelerometerUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// Generates a flower and paste it in the current view.
    private func generateFlower() {
        let flower = UIImageView(image: #imageLiteral(resourceName: "flower-coloured"))
        flower.frame = CGRect(center: flowerSource, size: flowerSize)
        view.addSubview(flower)

        gravityBehaviour.addItem(flower)
        collisionBehaviour.addItem(flower)
        itemBehaviour.addItem(flower)
        itemBehaviour.addLinearVelocity(flowerLinearSpeed, for: flower)
        itemBehaviour.addAngularVelocity(flowerAngularSpeed, for: flower)
    }

    // MARK: Animation Methods
    private func startAnimation() {
        specifyItemBehaviour()
        specifyGravityBehaviour()
        specifyCollisionBehaviour()

        animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(itemBehaviour)
        animator.addBehavior(gravityBehaviour)
        animator.addBehavior(collisionBehaviour)
    }

    private func startAccelerometerUpdate() {
        accelerometer.accelerometerUpdateInterval = 0.1
        accelerometer.startAccelerometerUpdates(to: .main) { data, _ in
            guard let data = data else {
                return
            }
            let direction = CGVector(dx: data.acceleration.x, dy: -data.acceleration.y)
            self.gravityBehaviour.gravityDirection = direction
        }
    }

    private func specifyGravityBehaviour() {
        gravityBehaviour = UIGravityBehavior()
        gravityBehaviour.magnitude = 0.001
    }

    private func specifyItemBehaviour() {
        itemBehaviour = UIDynamicItemBehavior()
    }

    private func specifyCollisionBehaviour() {
        collisionBehaviour = UICollisionBehavior()
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = true
    }

}
