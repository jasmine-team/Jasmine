import AVFoundation

extension AVAudioPlayer {

    private typealias Volume = Constants.Sound.Volume

    private static let totalFadeDuration: TimeInterval = 1.0
    private static let tickInterval: TimeInterval = 0.1

    /// Initializes AVAudioPlayer from a filename
    ///
    /// - Parameter filename: filename as stated in bundle
    /// - Throws: URLError if file not found, or parsing error of sound file
    convenience init(filename: String) throws {
        var components = filename.components(separatedBy: ".")
        let name = components.removeFirst()
        let ext = components.popLast()
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            throw URLError(.fileDoesNotExist)
        }
        try self.init(contentsOf: url)
    }

    /// Fades sound from current volume to set volume
    ///
    /// - Parameters:
    ///   - volume: volume to reach eventually, between 0 and 1
    ///   - duration: time to fade to volume set
    func fadeTo(volume: Float, duration: TimeInterval = totalFadeDuration) {
        assert((Volume.range).contains(volume), "Volume must be between zero and one")

        let differenceInVolume = volume - self.volume
        let delta = differenceInVolume / Float(duration / AVAudioPlayer.tickInterval)

        let timer = CountDownTimer(totalTimeAllowed: duration)
        timer.timerListener = { status in
            switch status {
            case .tick:
                self.volume += delta
            case .finish:
                self.volume = volume    // fix value due to floating pt errors & inconsistent clock
                if self.volume == 0 {
                    self.stop()
                }
            default:
                return
            }
        }
        timer.startTimer(timerInterval: AVAudioPlayer.tickInterval)
    }

    /// Fade in sound from 0 to max volume, plays sound if not already playing
    ///
    /// - Parameter duration: stated during to fade to max volume
    func fadeIn(duration: TimeInterval = totalFadeDuration) {
        volume = Volume.min
        DispatchQueue.global(qos: .userInteractive).async {
            if !self.isPlaying {
                self.play()
            }
        }
        fadeTo(volume: Volume.max, duration: duration)
    }

    /// Fade out sound to silence, and stops the player
    ///
    /// - Parameter duration: stated during to fade to silence
    func fadeOut(duration: TimeInterval = totalFadeDuration) {
        fadeTo(volume: Volume.min, duration: duration)
    }

}
