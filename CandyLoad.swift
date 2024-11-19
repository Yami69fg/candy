import UIKit
import SnapKit

class CandyLoad: UIViewController {

    private var candyBackgroundView = UIImageView()
    private var candyImageView = UIImageView()
    private var candyLoadingImageView = UIImageView()

    private var candyLoadingTimer: Timer?
    private var candyRotationTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCandyUI()
        startCandyRotation()
        startCandyLoadingAnimation()
        navigateToCandyNextController()
    }
    
    private func setupCandyUI() {
        candyBackgroundView.image = UIImage(named: "BG")
        candyBackgroundView.contentMode = .scaleAspectFill

        candyImageView.image = UIImage(named: "MainCandy")
        candyImageView.contentMode = .scaleAspectFit

        candyLoadingImageView.image = UIImage(named: "Load1")
        candyLoadingImageView.contentMode = .scaleAspectFill

        view.addSubview(candyBackgroundView)
        view.addSubview(candyImageView)
        view.addSubview(candyLoadingImageView)
        
        candyBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        candyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.height.equalTo(150)
        }
        
        candyLoadingImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(candyImageView.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    private func startCandyRotation() {
        candyRotationTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.candyImageView.transform = self.candyImageView.transform.rotated(by: .pi / 180)
        }
    }
    
    private func startCandyLoadingAnimation() {
        var candyImageIndex = 1
        candyLoadingTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            candyImageIndex = (candyImageIndex % 3) + 1
            self.candyLoadingImageView.image = UIImage(named: "Load\(candyImageIndex)")
        }
    }
    
    private func navigateToCandyNextController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            let candyLaunched = UserDefaults.standard.bool(forKey: "candy")
            if !candyLaunched {
                UserDefaults.standard.set(true, forKey: "candy")
                UserDefaults.standard.synchronize()
                let candyNextViewController = CandyWelcome()
                candyNextViewController.modalTransitionStyle = .crossDissolve
                candyNextViewController.modalPresentationStyle = .fullScreen
                self.present(candyNextViewController, animated: true, completion: nil)
            } else {
                let candyNextViewController = CandyMenu()
                candyNextViewController.modalTransitionStyle = .crossDissolve
                candyNextViewController.modalPresentationStyle = .fullScreen
                self.present(candyNextViewController, animated: true, completion: nil)
            }
        }
    }
    
    deinit {
        candyLoadingTimer?.invalidate()
        candyRotationTimer?.invalidate()
    }
}
