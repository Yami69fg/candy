import UIKit
import SpriteKit
import GameplayKit
import AVFAudio
import SnapKit

class CandyGameController: UIViewController {
    
    weak var candyScene: CandyGame?
    
    var candySpeed : TimeInterval = 5
    
    var candyOnReturnToMenu: (() -> Void)?
    
    private let candyScoreBackgroundImageView = UIImageView()
    private let candyHPBackgroundImageView = UIImageView()
    private let candyGlobalScoreLabel = UILabel()
    private let candyPauseButton = UIButton()
    
    private var candyGlobalScore: Int {
        get {
            return UserDefaults.standard.integer(forKey: "candyScore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "candyScore")
            candyGlobalScoreLabel.text = "\(newValue)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        candyGlobalScoreLabel.text = "\(candyGlobalScore)"
        setupCandyScene()
        configureCandyUI()
        configureCandyActions()
    }
    
    private func setupCandyScene() {
        self.view = SKView(frame: view.frame)
        
        if let skView = self.view as? SKView {
            let candyScene = CandyGame(size: skView.bounds.size)
            self.candyScene = candyScene
            candyScene.candySpeed = candySpeed
            candyScene.candyGameController = self
            candyScene.scaleMode = .aspectFill
            skView.presentScene(candyScene)
        }
    }
    
    private func configureCandyUI() {
        candyScoreBackgroundImageView.image = UIImage(named: "Score")
        candyScoreBackgroundImageView.contentMode = .scaleAspectFit
        view.addSubview(candyScoreBackgroundImageView)
        
        candyScoreBackgroundImageView.addSubview(candyGlobalScoreLabel)
        candyScoreBackgroundImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.size.equalTo(CGSize(width: 150, height: 55))
        }
        
        candyHPBackgroundImageView.image = UIImage(named: "HP3")
        candyHPBackgroundImageView.contentMode = .scaleAspectFit
        view.addSubview(candyHPBackgroundImageView)
        
        candyHPBackgroundImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(candyScoreBackgroundImageView.snp.bottom).offset(10)
            $0.size.equalTo(CGSize(width: 100, height: 55))
        }
        
        candyGlobalScoreLabel.font = UIFont(name: "ChangaOne", size: 22)
        candyGlobalScoreLabel.textColor = .white
        candyGlobalScoreLabel.textAlignment = .center
        candyGlobalScoreLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        
        view.addSubview(candyPauseButton)
        candyPauseButton.setImage(UIImage(named: "Setting"), for: .normal)
        candyPauseButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalToSuperview().inset(10)
            make.width.height.equalTo(55)
        }
    }
    
    private func configureCandyActions() {
        candyPauseButton.addTarget(self, action: #selector(candyHandlePauseButtonPress), for: .touchUpInside)
        addCandySound(button: candyPauseButton)
    }
    
    @objc private func candyHandlePauseButtonPress() {
        candyScene?.candyPauseGame()
        let candyController = CandySetting()
        candyController.candyOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.candyOnReturnToMenu?()
        }
        candyController.candyResume = { [weak self] in
            self?.candyScene?.candyResumeGame()
        }
        candyController.modalPresentationStyle = .overCurrentContext
        self.present(candyController, animated: false, completion: nil)
    }
    
    func candyEndGame(candyScore: Int, candyIsWin: Bool) {
        let endViewController = CandyOver()
        endViewController.candyWin = candyIsWin
        endViewController.candyScore = candyScore
        candyScene?.candyPauseGame()
        endViewController.candyOnReturnToMenu = { [weak self] in
            self?.dismiss(animated: false)
            self?.candyOnReturnToMenu?()
        }
        endViewController.candyOnRestart = { [weak self] in
            self?.candyScene?.candyRestartGame()
        }
        endViewController.modalPresentationStyle = .overCurrentContext
        self.present(endViewController, animated: false, completion: nil)
    }
    
    func candyUpdateScore() {
        candyGlobalScore += 1
    }
    func candyUpdateScoreMore() {
        candyGlobalScore += 10
    }
    
    func HP3(){
        candyHPBackgroundImageView.image = UIImage(named: "HP3")
    }
    func HP2(){
        candyHPBackgroundImageView.image = UIImage(named: "HP2")
    }
    func HP1(){
        candyHPBackgroundImageView.image = UIImage(named: "HP1")
    }
}
