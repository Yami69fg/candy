import UIKit
import SnapKit

class CandyRules: UIViewController {
    
    private let candyBackdropImageView: UIImageView = UIImageView()
    private let candyCloseButton: UIButton = UIButton()
    private let candyDopImageView: UIImageView = UIImageView()
    private let candyInstructionImageView: UIImageView = UIImageView()
    private let candyInstructionLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCandyInterface()
        setupCandyInstructionText()
    }
    
    private func configureCandyInterface() {
        candyBackdropImageView.image = UIImage(named: "BG")
        candyBackdropImageView.contentMode = .scaleAspectFill
        view.addSubview(candyBackdropImageView)
        
        candyDopImageView.image = UIImage(named: "BGExtra")
        candyDopImageView.contentMode = .scaleToFill
        view.addSubview(candyDopImageView)
        
        candyCloseButton.setImage(UIImage(named: "Close"), for: .normal)
        candyCloseButton.contentMode = .scaleAspectFit
        view.addSubview(candyCloseButton)
        
        candyInstructionImageView.image = UIImage(named: "Rules")
        candyInstructionImageView.contentMode = .scaleAspectFit
        view.addSubview(candyInstructionImageView)
        
        candyInstructionLabel.font = UIFont(name: "ChangaOne", size: 30)
        candyInstructionLabel.textColor = .white
        candyInstructionLabel.textAlignment = .center
        candyInstructionLabel.numberOfLines = 0
        candyInstructionLabel.adjustsFontSizeToFitWidth = true
        candyInstructionLabel.minimumScaleFactor = 0.49
        candyDopImageView.addSubview(candyInstructionLabel)
        
        candyBackdropImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        candyDopImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(candyDopImageView.snp.width).multipliedBy(1.3)
        }
        
        candyCloseButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalToSuperview().inset(10)
            $0.size.equalTo(45)
        }
        
        candyInstructionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.77)
            $0.height.equalTo(candyDopImageView.snp.width).multipliedBy(1.2)
        }
        
        candyInstructionImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(candyDopImageView.snp.top)
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }
        
        candyCloseButton.addTarget(self, action: #selector(candyCloseTapped), for: .touchUpInside)
        addCandySound(button: candyCloseButton)
    }
    
    private func setupCandyInstructionText() {
        candyInstructionLabel.text = "There are difficulties that affect how quickly you will earn points. To win, you need to score 1000 points. By collecting small bonuses, you will earn +10 points. Also, avoid touching the blocks, or you will lose. You have 3 lives to reach 1000 points."
    }
    
    @objc private func candyCloseTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
