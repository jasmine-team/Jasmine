import UIKit
import CoreMotion

/// A background of falling flowers.
class FallingFlowersViewController: UIViewController {

    // MARK: Constants
    private static let spawnCount = 180

    private static let flowerSizeMin = 20.0
    private static let flowerSizeMax = 60.0

    private static let parallaxMin = 50.0
    private static let parallaxMax = 50.0

    private static let rotateRange = Double.pi / 6
    private static let animationDelay = 2.0

    // MARK: Animation Properties
    private var animator: UIDynamicAnimator!
    private var collisionBehaviour: UICollisionBehavior!

    // MARK: Generator Properties
    private var flowers: [UIImageView] = []
    private var generator: RandomGenerator<[UIImageView]>!

    private var flowerSize: CGSize {
        let width = Random.double(from: FallingFlowersViewController.flowerSizeMin,
                                  toInclusive: FallingFlowersViewController.flowerSizeMax)
        return CGSize(width: width, height: width)
    }

    private var flowerSource: CGPoint {
        let randomX = Random.double(from: Double(view.bounds.minX),
                                    toInclusive: Double(view.bounds.maxX))
        let randomY = Random.double(from: Double(view.bounds.minY),
                                    toInclusive: Double(view.bounds.maxY))
        return CGPoint(x: randomX, y: randomY)
    }

    // MARK: View Controller Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if flowers.isEmpty {
            startAnimation()

            for _ in 0..<FallingFlowersViewController.spawnCount {
                generateFlower()
            }
            generator = flowers.randomGenerator
            runAnimator()
        }
    }

    /// Generates a flower and paste it in the current view.
    private func generateFlower() {
        let flower = UIImageView(image: #imageLiteral(resourceName: "flower-coloured"))
        flower.frame = CGRect(center: flowerSource, size: flowerSize)
        let randomFloat = Random.double(from: FallingFlowersViewController.parallaxMin,
                                        toInclusive: FallingFlowersViewController.parallaxMax)
        flower.addParallexEffect(offset: CGFloat(randomFloat))

        view.addSubview(flower)
        collisionBehaviour.addItem(flower)
        flowers.append(flower)
    }

    private func runAnimator() {
        let range = FallingFlowersViewController.rotateRange
        let delay = FallingFlowersViewController.animationDelay
        generator.next(count: 30).forEach { item in
            UIView.animate(withDuration: 3,
                           delay: Random.double(from: .leastNonzeroMagnitude, toInclusive: delay),
                           animations: {
                            let randomAngle = CGFloat(Random.double(from: -range, toInclusive: range))
                            item.transform = CGAffineTransform(rotationAngle: randomAngle)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: runAnimator)
    }

    // MARK: Animation Methods
    private func startAnimation() {
        specifyCollisionBehaviour()

        animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(collisionBehaviour)
    }

    private func specifyCollisionBehaviour() {
        collisionBehaviour = UICollisionBehavior()
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = true
    }

}
