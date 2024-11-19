import UIKit
import SnapKit

class CandyShop: UIViewController {

    private let candyBackdropImageView = UIImageView()
    private let candyCenterImageView = UIImageView()
    private let candyLeftButton = UIButton()
    private let candyRightButton = UIButton()
    private let candyCloseButton = UIButton()
    private let candyBuyButton = UIButton()
    private let candyScoreBackgroundImageView = UIImageView()
    private let candyScoreLabel = UILabel()

    private let candyPreviewImageNames = ["BGB1", "BGB2", "BGB3"]
    private let candyBackgroundImageNames = ["BG1", "BG2", "BG3"]
    private var candyCurrentImageIndex = 0

    private var candySelectedImageName: String {
        get { UserDefaults.standard.string(forKey: "candySelectedImageName") ?? "BG" }
        set { UserDefaults.standard.set(newValue, forKey: "candySelectedImageName") }
    }

    private var candyGlobalScore: Int {
        get { UserDefaults.standard.integer(forKey: "candyScore") }
        set { UserDefaults.standard.set(newValue, forKey: "candyScore") }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        candyScoreLabel.text = "\(candyGlobalScore)"
        configureUI()
        updateCenterImage()
        setupActions()
    }

    private func configureUI() {
        candyBackdropImageView.image = UIImage(named: "BG")
        candyBackdropImageView.contentMode = .scaleAspectFill
        view.addSubview(candyBackdropImageView)

        candyCenterImageView.contentMode = .scaleAspectFit
        view.addSubview(candyCenterImageView)

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

        candyCloseButton.setImage(UIImage(named: "Close"), for: .normal)
        candyCloseButton.contentMode = .scaleAspectFit
        candyCloseButton.layer.cornerRadius = 14
        candyCloseButton.clipsToBounds = true
        view.addSubview(candyCloseButton)

        candyBuyButton.setImage(UIImage(named: "Buy"), for: .normal)
        candyBuyButton.contentMode = .scaleAspectFit
        candyBuyButton.layer.cornerRadius = 10
        candyBuyButton.clipsToBounds = true
        view.addSubview(candyBuyButton)

        candyScoreBackgroundImageView.image = UIImage(named: "Score")
        candyScoreBackgroundImageView.contentMode = .scaleAspectFit
        view.addSubview(candyScoreBackgroundImageView)

        candyScoreLabel.font = UIFont(name: "ChangaOne", size: 20)
        candyScoreLabel.textColor = .white
        candyScoreLabel.textAlignment = .center
        candyScoreBackgroundImageView.addSubview(candyScoreLabel)

        candyBackdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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

        candyScoreLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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

        candyBuyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(candyCenterImageView.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    private func updateCenterImage() {
        candyCenterImageView.image = UIImage(named: candyPreviewImageNames[candyCurrentImageIndex])?.withRenderingMode(.alwaysOriginal)
    }

    private func setupActions() {
        candyLeftButton.addTarget(self, action: #selector(candyLeftButtonTapped), for: .touchUpInside)
        addCandySound(button: candyLeftButton)
        candyRightButton.addTarget(self, action: #selector(candyRightButtonTapped), for: .touchUpInside)
        addCandySound(button: candyRightButton)
        candyCloseButton.addTarget(self, action: #selector(candyCloseButtonTapped), for: .touchUpInside)
        addCandySound(button: candyCloseButton)
        candyBuyButton.addTarget(self, action: #selector(candyBuyButtonTapped), for: .touchUpInside)
        addCandySound(button: candyBuyButton)
    }

    @objc private func candyLeftButtonTapped() {
        if candyCurrentImageIndex > 0 {
            candyCurrentImageIndex -= 1
            updateCenterImage()
        }
    }

    @objc private func candyRightButtonTapped() {
        if candyCurrentImageIndex < candyPreviewImageNames.count - 1 {
            candyCurrentImageIndex += 1
            updateCenterImage()
        }
    }

    @objc private func candyCloseButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func candyBuyButtonTapped() {
        let candyCost = getCandyCostForCurrentImage()
        let candyPurchasedImageName = candyBackgroundImageNames[candyCurrentImageIndex]
        if UserDefaults.standard.bool(forKey: "\(candyPurchasedImageName)p") {
            candyShowAlert(message: "This image is already purchased and set as the background!")
            return
        }

        if candyGlobalScore < candyCost {
            let candyMissingPoints = candyCost - candyGlobalScore
            candyShowAlert(message: "You need \(candyMissingPoints) more candy to buy this image.")
            return
        }

        let candyMessage = "Do you want to buy this image for \(candyCost) candy?"
        let candyAlertController = UIAlertController(title: "Confirm Purchase", message: candyMessage, preferredStyle: .alert)
        
        candyAlertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.candyGlobalScore -= candyCost
            UserDefaults.standard.set(true, forKey: "\(candyPurchasedImageName)p")
            self.setSelectedCandyBackgroundImage(candyPurchasedImageName)
            self.candyShowAlert(message: "Image purchased and set as the background!")
        }))
        
        candyAlertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(candyAlertController, animated: true, completion: nil)
    }

    private func setSelectedCandyBackgroundImage(_ purchasedImageName: String) {
        candySelectedImageName = purchasedImageName
        candyScoreLabel.text = "\(candyGlobalScore)"
    }

    private func getCandyCostForCurrentImage() -> Int {
        switch candyCurrentImageIndex {
        case 0: return 150
        case 1: return 550
        case 2: return 1050
        default: return 0
        }
    }

    private func candyShowAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
