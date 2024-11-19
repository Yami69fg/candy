import UIKit
import SnapKit

class CandyDifficult: UIViewController {
    
    private var candyBackdropImageView = UIImageView()
    private var candyEasyButton = UIButton()
    private var candyMediumButton = UIButton()
    private var candyHardButton = UIButton()
    private var candyCloseButton = UIButton()
    private var candyScoreBackgroundImageView = UIImageView()
    private var candyScoreLabel = UILabel()
    private var candyGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "candyScore") }
        set { UserDefaults.standard.set(newValue, forKey: "candyScore") }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        candyConfigureUI()
        candySetupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        candyScoreLabel.text = "\(candyGlobalScore)"
    }
    
    private func candyConfigureUI() {
        candyScoreLabel.font = UIFont(name: "ChangaOne", size: 20)
        candyScoreLabel.textColor = .white
        candyScoreLabel.textAlignment = .center
        candyScoreLabel.text = "\(candyGlobalScore)"
        
        view.addSubview(candyBackdropImageView)
        view.addSubview(candyMediumButton)
        view.addSubview(candyEasyButton)
        view.addSubview(candyHardButton)
        view.addSubview(candyScoreBackgroundImageView)
        candyScoreBackgroundImageView.addSubview(candyScoreLabel)
        view.addSubview(candyCloseButton)
        
        candyBackdropImageView.image = UIImage(named: "BG")
        candyBackdropImageView.contentMode = .scaleAspectFill
        
        candyScoreBackgroundImageView.image = UIImage(named: "Score")
        candyScoreBackgroundImageView.contentMode = .scaleAspectFit
        
        candyEasyButton.setImage(UIImage(named: "Easy"), for: .normal)
        candyEasyButton.contentMode = .scaleAspectFit
        candyEasyButton.layer.cornerRadius = 10
        candyEasyButton.clipsToBounds = true
        
        candyMediumButton.setImage(UIImage(named: "Normal"), for: .normal)
        candyMediumButton.contentMode = .scaleAspectFit
        candyMediumButton.layer.cornerRadius = 10
        candyMediumButton.clipsToBounds = true
        
        candyHardButton.setImage(UIImage(named: "Hard"), for: .normal)
        candyHardButton.contentMode = .scaleAspectFit
        candyHardButton.layer.cornerRadius = 10
        candyHardButton.clipsToBounds = true
        
        candyCloseButton.setImage(UIImage(named: "Close"), for: .normal)
        candyCloseButton.contentMode = .scaleAspectFit
        candyCloseButton.layer.cornerRadius = 14
        candyCloseButton.clipsToBounds = true
        
        candyBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        candyMediumButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        candyHardButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(candyMediumButton.snp.bottom).offset(50)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        candyEasyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(candyMediumButton.snp.top).offset(-50)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        candyScoreBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        candyScoreLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        candyCloseButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(10)
            make.width.height.equalTo(50)
        }
        
    }
    
    private func candySetupActions() {
        candyEasyButton.addTarget(self, action: #selector(candyTapEasyButton), for: .touchUpInside)
        addCandySound(button: candyEasyButton)
        candyMediumButton.addTarget(self, action: #selector(candyTapMediumButton), for: .touchUpInside)
        addCandySound(button: candyMediumButton)
        candyHardButton.addTarget(self, action: #selector(candyTapHardButton), for: .touchUpInside)
        addCandySound(button: candyHardButton)
        candyCloseButton.addTarget(self, action: #selector(candyCloseButtonTapped), for: .touchUpInside)
        addCandySound(button: candyCloseButton)

    }
    
    @objc private func candyTapEasyButton() {
        let controller = CandyGameController()
        controller.candySpeed = 5
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    @objc private func candyTapMediumButton() {
        let controller = CandyGameController()
        controller.candySpeed = 4
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    @objc private func candyTapHardButton() {
        let controller = CandyGameController()
        controller.candySpeed = 3
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    @objc private func candyCloseButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
