import AVFoundation

class SoundService: NSObject {

    private typealias Volume = Constants.Sound.Volume
    typealias Background = Constants.Sound.Background
    typealias Effect = Constants.Sound.Effect

    static let sharedInstance = SoundService()

    var backgroundVolume: Float = Volume.max {
        didSet {
            for (_, player) in backgroundPlayers {
                player.volume = backgroundVolume
            }
        }
    }
    var effectVolume: Float = Volume.max {
        didSet {
            let allPlayers = effectPlayers.flatMap { $0.value }
            allPlayers.forEach { player in
                player.volume = effectVolume
            }
        }
    }

    fileprivate var backgroundPlayers: [Background: AVAudioPlayer] = [:]
    fileprivate var effectPlayers: [Effect: [AVAudioPlayer]] = [:]

    private override init() {
        super.init()
        for background in Background.allValues {
            do {
                let player = try AVAudioPlayer(filename: background.rawValue)
                backgroundPlayers[background] = player
            } catch {
                assertionFailure("Could not instantiate background sound")
            }
        }
        for effect in Effect.allValues {
            effectPlayers[effect] = (0..<Effect.concurrentLimit).flatMap { _ in
                return try? AVAudioPlayer(filename: effect.rawValue)
            }
        }
        setUpPlayers()
    }

    func play(_ sound: Background) {
        assert(self.isBackgroundPlaying == false, "No two background sound should be playing at the same time")
        let player = self.backgroundPlayers[sound]
        player?.volume = Volume.min
        DispatchQueue.global(qos: .userInteractive).async {
            player?.play()
        }
        player?.fadeTo(volume: self.backgroundVolume)
    }

    func play(_ sound: Effect) {
        DispatchQueue.global(qos: .userInteractive).async {
            let players = self.effectPlayers[sound]
            let player = players?.first(where: { player in
                return !player.isPlaying
            })
            player?.play()
        }
    }

    func stop(_ sound: Background) {
        backgroundPlayers[sound]?.fadeOut()
    }

    func stop(_ sound: Effect) {
        effectPlayers[sound]?.forEach {
            $0.stop()
        }
    }

    /// Sets delegate to self and buffers all player in background thread
    private func setUpPlayers() {
        var allPlayers = effectPlayers.flatMap { $0.value }
        allPlayers.append(contentsOf: Array(backgroundPlayers.values))
        for player in allPlayers {
            player.delegate = self
        }
        DispatchQueue.global(qos: .background).async {
            for player in allPlayers {
                player.prepareToPlay()
            }
        }
    }

    fileprivate var isBackgroundPlaying: Bool {
        let playing = backgroundPlayers.filter {
            $0.value.isPlaying
        }
        return !playing.isEmpty
    }
}

extension SoundService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.global(qos: .background).async {
            player.prepareToPlay()
        }

        // ignore if other background sound is playing
        if isBackgroundPlaying {
            return
        }
        let nextSound = Background.defaultPlaylist.shuffled().first(where: { sound in
            return backgroundPlayers[sound] != player
        })
        if let nextSound = nextSound {
            play(nextSound)
        }
    }
}
