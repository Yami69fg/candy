import UIKit
import SnapKit

class CandyOver: UIViewController {
    
    private var candyBackgroundDetailsImageView = UIImageView()
    private var candySettingsHeaderImageView = UIImageView()
    private var candyScoreTitleLabel = UILabel()
    private var candyTotalScoreTitleLabel = UILabel()
    private var candyMainMenuButton = UIButton()
    private var candyRetryButton = UIButton()
    
    var candyOnReturnToMenu: (() -> ())?
    var candyOnRestart: (() -> ())?
    
    var candyWin = false
    var candyScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overSound()
        configureCandyInterface()
        updateCandyContent()
    }
    
    private func configureCandyInterface() {
        setupCandyConstraints()
        setupCandyActions()
    }
    
    private func setupCandyConstraints() {
        
        candyScoreTitleLabel.font = UIFont(name: "ChangaOne", size: 40)
        candyScoreTitleLabel.textColor = .white
        candyScoreTitleLabel.textAlignment = .center
        candyScoreTitleLabel.text = "\(candyScore)"
        
        candyTotalScoreTitleLabel.font = UIFont(name: "ChangaOne", size: 36)
        candyTotalScoreTitleLabel.textColor = .white
        candyTotalScoreTitleLabel.textAlignment = .center
        candyTotalScoreTitleLabel.text = "\(UserDefaults.standard.integer(forKey: "candyScore"))"
        
        candyBackgroundDetailsImageView.image = UIImage(named: "BGExtra")
        candyBackgroundDetailsImageView.contentMode = .scaleToFill
        
        candySettingsHeaderImageView.contentMode = .scaleAspectFit
        
        candyMainMenuButton.setImage(UIImage(named: "Menu"), for: .normal)
        candyMainMenuButton.contentMode = .scaleAspectFit
        candyMainMenuButton.layer.cornerRadius = 10
        candyMainMenuButton.clipsToBounds = true
        
        candyRetryButton.setImage(UIImage(named: "Restart"), for: .normal)
        candyRetryButton.contentMode = .scaleAspectFit
        candyRetryButton.layer.cornerRadius = 10
        candyRetryButton.clipsToBounds = true
        
        view.addSubview(candyBackgroundDetailsImageView)
        view.addSubview(candySettingsHeaderImageView)
        view.addSubview(candyScoreTitleLabel)
        view.addSubview(candyTotalScoreTitleLabel)
        view.addSubview(candyMainMenuButton)
        view.addSubview(candyRetryButton)
        
        candyBackgroundDetailsImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.25)
        }

        candySettingsHeaderImageView.snp.makeConstraints { make in
            make.bottom.equalTo(candyBackgroundDetailsImageView.snp.top).offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(200)
        }

        candyScoreTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(candyBackgroundDetailsImageView.snp.left).offset(20)
            make.centerY.equalToSuperview().offset(-30)
        }

        candyTotalScoreTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(candyBackgroundDetailsImageView.snp.left).offset(20)
            make.centerY.equalToSuperview().offset(30)
        }

        candyMainMenuButton.snp.makeConstraints { make in
            make.top.equalTo(candyBackgroundDetailsImageView.snp.bottom).offset(10)
            make.left.equalTo(candyBackgroundDetailsImageView.snp.left)
            make.width.equalTo(135)
            make.height.equalTo(60)
        }

        candyRetryButton.snp.makeConstraints { make in
            make.top.equalTo(candyBackgroundDetailsImageView.snp.bottom).offset(10)
            make.right.equalTo(candyBackgroundDetailsImageView.snp.right)
            make.width.equalTo(135)
            make.height.equalTo(60)
        }
    }
    
    private func setupCandyActions() {
        candyMainMenuButton.addTarget(self, action: #selector(candyNavigateToMainMenu), for: .touchUpInside)
        addCandySound(button: candyMainMenuButton)
        candyRetryButton.addTarget(self, action: #selector(candyRestartGameSession), for: .touchUpInside)
        addCandySound(button: candyRetryButton)
    }
    
    private func updateCandyContent() {
        if candyWin {
            candySettingsHeaderImageView.image = UIImage(named: "Win")
        } else {
            candySettingsHeaderImageView.image = UIImage(named: "Lose")
        }
        
        candyScoreTitleLabel.text = "Score \(candyScore)"
        candyTotalScoreTitleLabel.text = "Total score \(UserDefaults.standard.integer(forKey: "candyScore"))"
    }

    @objc private func candyNavigateToMainMenu() {
        dismiss(animated: false)
        candyOnReturnToMenu?()
    }
    
    @objc private func candyRestartGameSession() {
        dismiss(animated: true)
        candyOnRestart?()
    }
}
