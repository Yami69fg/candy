import UIKit
import SnapKit

class CandyWelcome: UIViewController {

    private var candyBackdropImageView = UIImageView()
    private var candyGreetingImageView = UIImageView()
    private var candyBonusButton = UIButton()
    
    private var candyTapCount = 0
    private let candyMaxTaps = 5
    private let candyBonusPoints = 20
    
    private var candyGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "candyScore") }
        set { UserDefaults.standard.set(newValue, forKey: "candyScore") }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCandyUI()
        setupCandyActions()
    }
    
    private func setupCandyUI() {
        candyBackdropImageView.image = UIImage(named: "BG")
        candyBackdropImageView.contentMode = .scaleAspectFill
        
        candyGreetingImageView.image = UIImage(named: "Welcome")
        candyGreetingImageView.contentMode = .scaleAspectFit
        
        candyBonusButton.setImage(UIImage(named: "ScoreCandy"), for: .normal)
        candyBonusButton.contentMode = .scaleAspectFit
        candyBonusButton.clipsToBounds = true

        view.addSubview(candyBackdropImageView)
        view.addSubview(candyGreetingImageView)
        view.addSubview(candyBonusButton)
        
        candyBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        candyGreetingImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
        
        candyBonusButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(275)
        }
    }
    
    private func setupCandyActions() {
        candyBonusButton.addTarget(self, action: #selector(candyBonusButtonTapped), for: .touchUpInside)
        addCandySound(button: candyBonusButton)
    }
    
    @objc private func candyBonusButtonTapped() {
        candyTapCount += 1
        
        if candyTapCount == candyMaxTaps {
            candyGlobalScore += candyBonusPoints
            showCandyGiftAlert()
        }
    }
    
    private func showCandyGiftAlert() {
        let alert = UIAlertController(
            title: "Welcome!",
            message: "You have received \(candyBonusPoints) candy!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigateToCandyMenu()
        })
        
        present(alert, animated: true)
    }
    
    private func navigateToCandyMenu() {
        let menuController = CandyMenu()
        menuController.modalPresentationStyle = .fullScreen
        present(menuController, animated: true)
    }
}
