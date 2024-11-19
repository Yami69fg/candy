import UIKit
import SnapKit

class CandySetting: UIViewController {
    
    private var candyControlPanelBackgroundDetails = UIImageView()
    private var candyControlPanelSettingsHeaderLabel = UIImageView()
    private var candySoundTitleLabel = UILabel()
    private var candyVibrationTitleLabel = UILabel()
    private var candySoundToggleSwitchButton = UIButton()
    private var candyVibrationToggleSwitchButton = UIButton()
    private var candyMainMenuButton = UIButton()
    private var candyReturnToGameplayButton = UIButton()
    
    var candyOnReturnToMenu: (() -> ())?
    var candyResume: (() -> ())?
    
    private let soundOnImage = UIImage(named: "On")
    private let soundOffImage = UIImage(named: "Off")
    private let vibrationOnImage = UIImage(named: "On")
    private let vibrationOffImage = UIImage(named: "Off")
    private let jungleMenuImage = UIImage(named: "Menu")
    private let jungleBackImage = UIImage(named: "BackB")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        candySetupSubviewsAndConstraints()
        candyConfigureButtonActions()
        candySetupDefaultSettings()
        candyLoadToggleButtonStates()
    }

    private func candySetupSubviewsAndConstraints() {
        view.addSubview(candyControlPanelBackgroundDetails)
        view.addSubview(candyControlPanelSettingsHeaderLabel)
        view.addSubview(candySoundTitleLabel)
        view.addSubview(candySoundToggleSwitchButton)
        view.addSubview(candyVibrationTitleLabel)
        view.addSubview(candyVibrationToggleSwitchButton)
        view.addSubview(candyMainMenuButton)
        view.addSubview(candyReturnToGameplayButton)
        
        candyControlPanelBackgroundDetails.image = UIImage(named: "BGExtra")
        candyControlPanelBackgroundDetails.contentMode = .scaleToFill
        
        candyControlPanelSettingsHeaderLabel.image = UIImage(named: "Settin")
        candyControlPanelSettingsHeaderLabel.contentMode = .scaleToFill
        
        candySoundTitleLabel.text = "Sound"
        candySoundTitleLabel.font = UIFont(name: "ChangaOne", size: 32)
        candySoundTitleLabel.textColor = .white
        candySoundTitleLabel.textAlignment = .center
        
        candyVibrationTitleLabel.text = "Vibration"
        candyVibrationTitleLabel.font = UIFont(name: "ChangaOne", size: 32)
        candyVibrationTitleLabel.textColor = .white
        candyVibrationTitleLabel.textAlignment = .center
        
        candyMainMenuButton.setImage(jungleMenuImage, for: .normal)
        candyReturnToGameplayButton.setImage(jungleBackImage, for: .normal)
        
        candyControlPanelBackgroundDetails.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        candyControlPanelSettingsHeaderLabel.snp.makeConstraints {
            $0.bottom.equalTo(candyControlPanelBackgroundDetails.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(100)
        }
        
        candySoundTitleLabel.snp.makeConstraints {
            $0.left.equalTo(candyControlPanelBackgroundDetails.snp.left).offset(20)
            $0.centerY.equalToSuperview().offset(-30)
        }
        
        candySoundToggleSwitchButton.snp.makeConstraints {
            $0.left.equalTo(candySoundTitleLabel.snp.right).offset(20)
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.equalTo(60)
            $0.height.equalTo(35)
        }
        
        candyVibrationTitleLabel.snp.makeConstraints {
            $0.left.equalTo(candyControlPanelBackgroundDetails.snp.left).offset(30)
            $0.centerY.equalToSuperview().offset(30)
        }
        
        candyVibrationToggleSwitchButton.snp.makeConstraints {
            $0.left.equalTo(candyVibrationTitleLabel.snp.right).offset(20)
            $0.centerY.equalToSuperview().offset(30)
            $0.width.equalTo(60)
            $0.height.equalTo(35)
        }
        
        candyMainMenuButton.snp.makeConstraints {
            $0.top.equalTo(candyControlPanelBackgroundDetails.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(50)
            $0.width.equalTo(135)
            $0.height.equalTo(60)
        }
        
        candyReturnToGameplayButton.snp.makeConstraints {
            $0.top.equalTo(candyControlPanelBackgroundDetails.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-50)
            $0.width.equalTo(135)
            $0.height.equalTo(60)
        }
    }

    private func candyConfigureButtonActions() {
        candyMainMenuButton.addTarget(self, action: #selector(candyMainMenuTapped), for: .touchUpInside)
        candyReturnToGameplayButton.addTarget(self, action: #selector(candyReturnToGameplayTapped), for: .touchUpInside)
        candySoundToggleSwitchButton.addTarget(self, action: #selector(candyToggleSound), for: .touchUpInside)
        candyVibrationToggleSwitchButton.addTarget(self, action: #selector(candyToggleVibration), for: .touchUpInside)
    }
    
    private func candySetupDefaultSettings() {
        if UserDefaults.standard.object(forKey: "soundOn") == nil {
            UserDefaults.standard.set(true, forKey: "soundOn")
        }
        if UserDefaults.standard.object(forKey: "vibrationOn") == nil {
            UserDefaults.standard.set(true, forKey: "vibrationOn")
        }
    }

    private func candyLoadToggleButtonStates() {
        let isAudioEnabled = UserDefaults.standard.bool(forKey: "soundOn")
        let isVibrationEnabled = UserDefaults.standard.bool(forKey: "vibrationOn")
        
        candySoundToggleSwitchButton.setImage(UIImage(named: isAudioEnabled ? "On" : "Off"), for: .normal)
        candyVibrationToggleSwitchButton.setImage(UIImage(named: isVibrationEnabled ? "On" : "Off"), for: .normal)
    }
    
    @objc private func candyToggleSound() {
        let isSoundActive = candySoundToggleSwitchButton.currentImage == UIImage(named: "On")
        let newSoundState = !isSoundActive
        candySoundToggleSwitchButton.setImage(UIImage(named: newSoundState ? "On" : "Off"), for: .normal)
        UserDefaults.standard.set(newSoundState, forKey: "soundOn")
    }
    
    @objc private func candyToggleVibration() {
        let isVibrationActive = candyVibrationToggleSwitchButton.currentImage == UIImage(named: "On")
        let newVibrationState = !isVibrationActive
        candyVibrationToggleSwitchButton.setImage(UIImage(named: newVibrationState ? "On" : "Off"), for: .normal)
        UserDefaults.standard.set(newVibrationState, forKey: "vibrationOn")
    }
    
    @objc private func candyMainMenuTapped() {
        dismiss(animated: false)
        candyOnReturnToMenu?()
    }
    
    @objc private func candyReturnToGameplayTapped() {
        candyResume?()
        dismiss(animated: true)
    }
}
