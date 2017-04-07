import XCTest
import AVFoundation
@testable import Jasmine

class AVAudioPlayerExtensionsTests: XCTestCase {

    private typealias Volume = Constants.Sound.Volume

    var player: AVAudioPlayer!

    private let testDuration: TimeInterval = 1
    private let midDurationAllowance: Float = 0.21   // timers are ridiculously inconsistent
    private let finalDurationAllowance: Float = 0.01    // correction for floating point errors

    override func setUp() {
        super.setUp()
        let testBundle = Bundle(for: type(of: self))
        guard let testSoundURL = testBundle.url(forResource: "test", withExtension: "mp3") else {
            XCTFail("Unable to find test mp3 url")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: testSoundURL)
        } catch {
            XCTFail("Unable to create test player")
        }
    }

    func testInit_noSuchFile() {
        XCTAssertThrowsError(try AVAudioPlayer(filename: ""),
                             "No errors were thrown with invalid filename", { (error) in
            XCTAssertEqual(error as? URLError, URLError(.fileDoesNotExist), "Incorrect url error was thrown")
        })
    }

    func testfadeTo() {
        let volume: Float = 0.8

        player.volume = Volume.max
        player.fadeTo(volume: volume, duration: testDuration)

        advanceTimeByHalf()
        XCTAssertEqualWithAccuracy(player.volume, 0.9, accuracy: midDurationAllowance,
                                   "Player volume is not half of difference after half of duration has passed")

        advanceTimeByHalf(withAdditional: 0.2)
        XCTAssertEqualWithAccuracy(player.volume, volume, accuracy: finalDurationAllowance,
                                   "Player volume has not reached destination volume")
    }

    func testfadeIn() {
        player.volume = Volume.min
        player.fadeIn(duration: testDuration)

        advanceTimeByHalf()
        XCTAssertEqualWithAccuracy(player.volume, Volume.max / 2, accuracy: midDurationAllowance,
                                   "Player volume is not half after half duration has passed")
        print(player.volume)
        advanceTimeByHalf(withAdditional: 0.2)
        XCTAssertEqualWithAccuracy(player.volume, Volume.max, accuracy: finalDurationAllowance,
                                   "Player volume is not max after duration has passed")
    }

    func testfadeOut() {
        player.play()
        XCTAssertEqual(player.volume, Volume.max, "Player volume is not max by default")
        player.fadeOut(duration: testDuration)

        advanceTimeByHalf()
        XCTAssertEqualWithAccuracy(player.volume, Volume.max / 2, accuracy: midDurationAllowance,
                                   "Player volume is not half after half duration has passed")

        advanceTimeByHalf(withAdditional: 0.2)
        XCTAssertEqualWithAccuracy(player.volume, Volume.min, accuracy: finalDurationAllowance,
                                   "Player volume is not min after duration has passed")

        XCTAssertFalse(player.isPlaying, "Player is still playing after fade out")
    }

    private func advanceTimeByHalf(withAdditional: TimeInterval = 0) {
        RunLoop.current.run(until: Date(timeIntervalSinceNow: (testDuration / 2) + withAdditional))
    }

}
