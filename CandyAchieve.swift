import UIKit
import SnapKit

class CandyAchieve: UIViewController {
    
    private let candyBackdropImageView = UIImageView()
    private let candyCenterImageView = UIImageView()
    private let candyLeftButton = UIButton()
    private let candyRightButton = UIButton()
    private let candyCloseButton = UIButton()
    private let candyCheckButton = UIButton()
    private let candyScoreBackgroundImageView = UIImageView()
    private let candyScoreLabel = UILabel()
    
    private let candyImageNames = ["Achieve1", "Achieve2", "Achieve3"]
    private var candyCurrentImageIndex = 0
    
    private var candyGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "candyScore") }
        set { UserDefaults.standard.set(newValue, forKey: "candyScore") }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        candyScoreLabel.text = "\(candyGlobalScore)"
        configureCandyUI()
        updateCandyCenterImage()
        setupCandyActions()
        updateCandyAchievementStatus()
    }
    
    private func configureCandyUI() {
        candyBackdropImageView.image = UIImage(named: "BG")
        candyBackdropImageView.contentMode = .scaleAspectFill
        view.addSubview(candyBackdropImageView)
        
        candyCenterImageView.contentMode = .scaleAspectFit
        view.addSubview(candyCenterImageView)
        
        candyScoreBackgroundImageView.image = UIImage(named: "Score")
        candyScoreBackgroundImageView.contentMode = .scaleAspectFit
        view.addSubview(candyScoreBackgroundImageView)
        candyScoreBackgroundImageView.addSubview(candyScoreLabel)
        
        candyScoreLabel.font = UIFont(name: "ChangaOne", size: 20)
        candyScoreLabel.textColor = .white
        candyScoreLabel.textAlignment = .center
        
        candyCloseButton.setImage(UIImage(named: "Close"), for: .normal)
        candyCloseButton.contentMode = .scaleAspectFit
        candyCloseButton.layer.cornerRadius = 14
        candyCloseButton.clipsToBounds = true
        view.addSubview(candyCloseButton)
        
        candyLeftButton.setImage(UIImage(named: "Back"), for: .normal)
        candyLeftButton.contentMode = .scaleAspectFit
        candyLeftButton.layer.cornerRadius = 20
        candyLeftButton.clipsToBounds = true
        view.addSubview(candyLeftButton)
        
        candyRightButton.setImage(UIImage(named: "Next"), for: .normal)
        candyRightButton.contentMode = .scaleAspectFit
        candyRightButton.layer.cornerRadius = 20
        candyRightButton.clipsToBounds = true
        view.addSubview(candyRightButton)
        
        candyCheckButton.setImage(UIImage(named: "Select"), for: .normal)
        candyCheckButton.contentMode = .scaleAspectFit
        candyCheckButton.layer.cornerRadius = 10
        candyCheckButton.clipsToBounds = true
        view.addSubview(candyCheckButton)
        
        candyBackdropImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        candyCenterImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(candyCenterImageView.snp.width)
        }
        
        candyScoreBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        candyScoreLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        candyCloseButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(10)
            make.width.height.equalTo(50)
        }
        
        candyLeftButton.snp.makeConstraints { make in
            make.centerY.equalTo(candyCenterImageView)
            make.right.equalTo(candyCenterImageView.snp.left).offset(-20)
            make.width.height.equalTo(55)
        }
        
        candyRightButton.snp.makeConstraints { make in
            make.centerY.equalTo(candyCenterImageView)
            make.left.equalTo(candyCenterImageView.snp.right).offset(20)
            make.width.height.equalTo(55)
        }
        
        candyCheckButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(candyCenterImageView.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    private func updateCandyCenterImage() {
        candyCenterImageView.image = UIImage(named: candyImageNames[candyCurrentImageIndex])
        updateCandyAchievementStatus()
    }
    
    private func updateCandyAchievementStatus() {
        let isConditionMet = checkCandyConditionForCurrentImage()
        candyCenterImageView.alpha = isConditionMet ? 1.0 : 0.5
    }
    
    private func setupCandyActions() {
        candyLeftButton.addTarget(self, action: #selector(candyLeftButtonTapped), for: .touchUpInside)
        addCandySound(button: candyLeftButton)
        candyRightButton.addTarget(self, action: #selector(candyRightButtonTapped), for: .touchUpInside)
        addCandySound(button: candyRightButton)
        candyCloseButton.addTarget(self, action: #selector(candyCloseButtonTapped), for: .touchUpInside)
        addCandySound(button: candyCloseButton)
        candyCheckButton.addTarget(self, action: #selector(candyCheckButtonTapped), for: .touchUpInside)
        addCandySound(button: candyCheckButton)
    }
    
    @objc private func candyLeftButtonTapped() {
        if candyCurrentImageIndex > 0 {
            candyCurrentImageIndex -= 1
            updateCandyCenterImage()
        }
    }
    
    @objc private func candyRightButtonTapped() {
        if candyCurrentImageIndex < candyImageNames.count - 1 {
            candyCurrentImageIndex += 1
            updateCandyCenterImage()
        }
    }
    
    @objc private func candyCloseButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func candyCheckButtonTapped() {
        let message = candyAchievementMessageForCurrentImage()
        let alertController = UIAlertController(title: "Candy Achievement Status", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }
    
    private func checkCandyConditionForCurrentImage() -> Bool {
        switch candyCurrentImageIndex {
        case 0:
            return candyGlobalScore >= 100
        case 1:
            return candyGlobalScore >= 500
        case 2:
            return candyGlobalScore >= 1000
        default:
            return false
        }
    }
    
    private func candyAchievementMessageForCurrentImage() -> String {
        switch candyCurrentImageIndex {
        case 0:
            return candyGlobalScore >= 100 ? "Achievement completed! 100 candy points collected!" : "Achievement not completed. Collect 100 candy points!"
        case 1:
            return candyGlobalScore >= 500 ? "Achievement completed! 500 candy points collected!" : "Achievement not completed. Collect 500 candy points!"
        case 2:
            return candyGlobalScore >= 1000 ? "Achievement completed! 1000 candy points collected!" : "Achievement not completed. Collect 1000 candy points!"
        default:
            return ""
        }
    }
}
