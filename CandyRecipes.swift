import UIKit
import SnapKit

class CandyRecipes: UIViewController {
    
    private let candyBackdropImageView: UIImageView = UIImageView()
    private let candyCloseButton: UIButton = UIButton()
    private let candyDopImageView: UIImageView = UIImageView()
    private let candyInstructionImageView: UIImageView = UIImageView()
    private let candyInstructionLabel: UILabel = UILabel()
    
    private let candyLeftButton: UIButton = UIButton()
    private let candyRightButton: UIButton = UIButton()
    
    private var currentRecipeIndex = 0
    
    private let recipeTexts = [
        "Chocolate Cake: Mix flour, cocoa powder, sugar, eggs, and butter. Bake at 350°F for 25-30 minutes. Frost with chocolate frosting.",
        "Vanilla Cupcakes: Combine flour, sugar, butter, eggs, vanilla, and milk. Bake at 350°F for 15-20 minutes. Top with vanilla buttercream frosting.",
        "Lemon Meringue Pie: Prepare a pie crust and bake. Make a lemon filling with lemon juice, sugar, eggs, and cornstarch. Top with whipped meringue and bake until golden.",
        "Oreo Truffles: Crush Oreo cookies and mix with cream cheese. Form into balls and dip in melted chocolate. Chill until firm.",
        "Chewy Brownies: Combine butter, sugar, eggs, cocoa powder, and flour. Bake at 350°F for 20-25 minutes. Enjoy soft, chewy brownies.",
        "Cinnamon Rolls: Prepare a dough with yeast, sugar, flour, and butter. Roll it out with a cinnamon-sugar filling. Bake and top with cream cheese icing.",
        "Peanut Butter Cookies: Mix peanut butter, sugar, and an egg. Roll into balls, flatten with a fork, and bake at 350°F for 8-10 minutes.",
        "Caramel Flan: Combine milk, eggs, sugar, and vanilla. Cook the mixture into a custard and bake in a water bath. Top with homemade caramel.",
        "Strawberry Shortcake: Bake biscuit-like shortcakes, then layer with fresh strawberries and whipped cream.",
        "Macarons: Mix almond flour, powdered sugar, and egg whites. Pipe onto baking sheets and bake. Fill with buttercream or ganache."
    ]

    
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
        
        candyInstructionImageView.image = UIImage(named: "Recipes")
        candyInstructionImageView.contentMode = .scaleAspectFit
        view.addSubview(candyInstructionImageView)
        
        candyInstructionLabel.font = UIFont(name: "ChangaOne", size: 30)
        candyInstructionLabel.textColor = .white
        candyInstructionLabel.textAlignment = .center
        candyInstructionLabel.numberOfLines = 0
        candyInstructionLabel.adjustsFontSizeToFitWidth = true
        candyInstructionLabel.minimumScaleFactor = 0.49
        candyDopImageView.addSubview(candyInstructionLabel)
        
        candyLeftButton.setImage(UIImage(named: "Back"), for: .normal)
        candyLeftButton.contentMode = .scaleAspectFit
        candyLeftButton.layer.cornerRadius = 20
        candyLeftButton.clipsToBounds = true
        candyLeftButton.addTarget(self, action: #selector(candyLeftButtonTapped), for: .touchUpInside)
        addCandySound(button: candyLeftButton)
        view.addSubview(candyLeftButton)
        
        candyRightButton.setImage(UIImage(named: "Next"), for: .normal)
        candyRightButton.contentMode = .scaleAspectFit
        candyRightButton.layer.cornerRadius = 20
        candyRightButton.clipsToBounds = true
        candyRightButton.addTarget(self, action: #selector(candyRightButtonTapped), for: .touchUpInside)
        addCandySound(button: candyRightButton)
        view.addSubview(candyRightButton)
        
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
        
        candyLeftButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
            $0.size.equalTo(80)
        }
        
        candyRightButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
            $0.size.equalTo(80)
        }
        
        candyCloseButton.addTarget(self, action: #selector(candyCloseTapped), for: .touchUpInside)
        addCandySound(button: candyCloseButton)
    }
    
    private func setupCandyInstructionText() {
        candyInstructionLabel.text = recipeTexts[currentRecipeIndex]
    }
    
    @objc private func candyCloseTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func candyLeftButtonTapped() {
        if currentRecipeIndex > 0 {
            currentRecipeIndex -= 1
            setupCandyInstructionText()
        }
    }
    
    @objc private func candyRightButtonTapped() {
        if currentRecipeIndex < recipeTexts.count - 1 {
            currentRecipeIndex += 1
            setupCandyInstructionText()
        }
    }
    
}
