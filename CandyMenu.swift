import UIKit
import SnapKit

class CandyMenu: UIViewController {
    
    private var candyGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "candyScore") }
        set { UserDefaults.standard.set(newValue, forKey: "candyScore") }
    }
    
    private var candyBackgroundView = UIImageView()
    private var candyImageView = UIImageView()
    private var candyStartButton = UIButton()
    private var candyShopButton = UIButton()
    private var candyAchievementsButton = UIButton()
    private var candyTimerButton = UIButton()
    private var candyTimerLabel = UILabel()
    private var candyRulesButton = UIButton()
    private var candyRecipesButton = UIButton()
    
    private let candyKey: String = "candyTimer"
    private let candyTimerDuration: TimeInterval = 1800
    private var candyTimer: Timer?
    private var candyRemainingTime: TimeInterval = 1800
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCandyUI()
        setupCandyActions()
        loadSavedCandyTimerState()
        startCandyTimer()
        configureCandyTimerLabel()
        candyTimerButton.isEnabled = false
    }
    
    private func setupCandyUI() {
        candyBackgroundView.image = UIImage(named: "BG")
        candyBackgroundView.contentMode = .scaleAspectFill
        view.addSubview(candyBackgroundView)
        candyBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        candyImageView.image = UIImage(named: "MainCandy")
        candyImageView.contentMode = .scaleAspectFit
        view.addSubview(candyImageView)
        
        candyStartButton.setImage(UIImage(named: "Start"), for: .normal)
        candyShopButton.setImage(UIImage(named: "Shop"), for: .normal)
        candyAchievementsButton.setImage(UIImage(named: "Achieve"), for: .normal)
        candyTimerButton.setImage(UIImage(named: "Score"), for: .normal)
        candyRulesButton.setImage(UIImage(named: "Rule"), for: .normal)
        candyRecipesButton.setImage(UIImage(named: "Recipe"), for: .normal)
        
        candyTimerLabel.font = UIFont(name: "ChangaOne", size: 20)
        candyTimerLabel.textColor = .white
        candyTimerLabel.textAlignment = .center
        
        view.addSubview(candyTimerButton)
        view.addSubview(candyStartButton)
        view.addSubview(candyAchievementsButton)
        view.addSubview(candyShopButton)
        view.addSubview(candyRulesButton)
        view.addSubview(candyRecipesButton)
        
        candyTimerButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(75)
            make.centerX.equalToSuperview()
            make.width.equalTo(175)
            make.height.equalTo(50)
        }

        candyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(candyTimerButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        candyStartButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(candyImageView.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        candyRulesButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(candyStartButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        candyRecipesButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(candyRulesButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        candyAchievementsButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(75)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(60)
        }
        
        candyShopButton.snp.makeConstraints { make in
            make.top.equalTo(candyAchievementsButton.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(60)
        }
    }
    
    private func setupCandyActions() {
        candyStartButton.addTarget(self, action: #selector(tapCandyStartButton), for: .touchUpInside)
        addCandySound(button: candyStartButton)
        candyShopButton.addTarget(self, action: #selector(tapCandyShopButton), for: .touchUpInside)
        addCandySound(button: candyShopButton)
        candyAchievementsButton.addTarget(self, action: #selector(tapCandyAchieveButton), for: .touchUpInside)
        addCandySound(button: candyAchievementsButton)
        candyTimerButton.addTarget(self, action: #selector(candyRewardButtonTapped), for: .touchUpInside)
        addCandySound(button: candyTimerButton)
        candyRulesButton.addTarget(self, action: #selector(tapCandyRulesButton), for: .touchUpInside)
        addCandySound(button: candyRulesButton)
        candyRecipesButton.addTarget(self, action: #selector(tapCandyRecipesButton), for: .touchUpInside)
        addCandySound(button: candyRecipesButton)
    }
    
    @objc private func tapCandyStartButton() {
        let storeController = CandyDifficult()
        storeController.modalTransitionStyle = .crossDissolve
        storeController.modalPresentationStyle = .fullScreen
        present(storeController, animated: true)
    }
    
    @objc private func tapCandyShopButton() {
        let storeController = CandyShop()
        storeController.modalTransitionStyle = .crossDissolve
        storeController.modalPresentationStyle = .fullScreen
        present(storeController, animated: true)
    }
    
    @objc private func tapCandyAchieveButton() {
        let achieveController = CandyAchieve()
        achieveController.modalTransitionStyle = .crossDissolve
        achieveController.modalPresentationStyle = .fullScreen
        present(achieveController, animated: true)
    }
    
    @objc private func tapCandyRulesButton() {
        let rulesController = CandyRules()
        rulesController.modalTransitionStyle = .crossDissolve
        rulesController.modalPresentationStyle = .fullScreen
        present(rulesController, animated: true)
    }
    
    @objc private func tapCandyRecipesButton() {
        let recipesController = CandyRecipes()
        recipesController.modalTransitionStyle = .crossDissolve
        recipesController.modalPresentationStyle = .fullScreen
        present(recipesController, animated: true)
    }
    
    private func startCandyTimer() {
        candyTimer?.invalidate()
        candyTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCandyTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateCandyTimer() {
        if candyRemainingTime > 0 {
            candyRemainingTime -= 1
            candyTimerLabel.text = formatCandyTime(candyRemainingTime)
            saveCandyTimerState()
        } else {
            candyTimer?.invalidate()
            candyTimerLabel.text = "00:00:00"
            unlockCandyRewardButton()
        }
    }
    
    private func formatCandyTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func unlockCandyRewardButton() {
        candyTimerButton.isEnabled = true
    }
    
    private func loadSavedCandyTimerState() {
        let timerStartTime = UserDefaults.standard.double(forKey: candyKey)
        if timerStartTime == 0 {
            candyRemainingTime = candyTimerDuration
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: candyKey)
        } else {
            let elapsedTime = Date().timeIntervalSince1970 - timerStartTime
            candyRemainingTime = max(0, candyTimerDuration - elapsedTime)
        }
        candyTimerLabel.text = formatCandyTime(candyRemainingTime)
    }
    
    private func saveCandyTimerState() {
        UserDefaults.standard.set(candyRemainingTime, forKey: "remainingCandyTime")
    }
    
    @objc private func candyRewardButtonTapped() {
        candyRemainingTime = candyTimerDuration
        candyGlobalScore += 30
        candyTimerLabel.text = formatCandyTime(candyRemainingTime)
        candyTimerButton.isEnabled = false
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: candyKey)
        startCandyTimer()
    }
    
    private func configureCandyTimerLabel() {
        candyTimerLabel.text = formatCandyTime(candyRemainingTime)
        candyTimerButton.addSubview(candyTimerLabel)
        candyTimerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
