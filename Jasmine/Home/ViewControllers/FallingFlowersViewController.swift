import UIKit
import CoreMotion

/// A background of falling flowers.
class FallingFlowersViewController: UIViewController {

    // MARK: Constants
    private static let spawnCount = 220

    private static let flowerSizeMin = 30.0
    private static let flowerSizeMax = 80.0

    private static let accelerometerUpdateInterval = 0.05

    // MARK: Animation Properties
    private var animator: UIDynamicAnimator!
    private var gravityBehaviour: UIGravityBehavior!
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

    // MARK: View Controller Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !hasSpawned {
            startAnimation()
            for _ in 0..<FallingFlowersViewController.spawnCount {
                generateFlower()
            }
            hasSpawned = true
        }
        startAccelerometerUpdate()
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
    }

    // MARK: Animation Methods
    private func startAnimation() {
        specifyGravityBehaviour()
        specifyCollisionBehaviour()

        animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(gravityBehaviour)
        animator.addBehavior(collisionBehaviour)
    }

    private func startAccelerometerUpdate() {
        accelerometer.accelerometerUpdateInterval
            = FallingFlowersViewController.accelerometerUpdateInterval

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

    private func specifyCollisionBehaviour() {
        collisionBehaviour = UICollisionBehavior()
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = true
    }

}
