import UIKit
import SpriteKit
import AVFoundation

class CandySound {
    
    static let shared = CandySound()
    private var audio: AVAudioPlayer?

    private init() {}
    
    func playSoundPress() {
        let isSound = UserDefaults.standard.bool(forKey: "soundOn")
        if isSound {
            guard let sound = Bundle.main.url(forResource: "Button", withExtension: "mp3") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
        
        let isVibration = UserDefaults.standard.bool(forKey: "vibrationOn")
        if isVibration {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
        }
    }
    
    func playOverSound() {
        let isSound = UserDefaults.standard.bool(forKey: "soundOn")
        if isSound {
            guard let sound = Bundle.main.url(forResource: "Over", withExtension: "mp3") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
    }
    
    func playCandySound() {
        let isSound = UserDefaults.standard.bool(forKey: "soundOn")
        if isSound {
            guard let sound = Bundle.main.url(forResource: "Candy", withExtension: "mp3") else { return }
            audio = try? AVAudioPlayer(contentsOf: sound)
            audio?.play()
        }
    }
}



extension UIViewController {
    
    func addCandySound(button: UIButton) {
        button.addTarget(self, action: #selector(handleButtonTouchDown(sender:)), for: .touchDown)
    }
    
    func overSound() {
        CandySound.shared.playOverSound()
    }
    
    func candySound() {
        CandySound.shared.playCandySound()
    }
    
    @objc private func handleButtonTouchDown(sender: UIButton) {
        CandySound.shared.playSoundPress()
    }
}

extension SKScene {

    func candySound() {
        CandySound.shared.playCandySound()
    }

}
