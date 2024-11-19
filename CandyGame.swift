import SpriteKit
import UIKit

class CandyGame: SKScene {
    
    weak var candyGameController: CandyGameController?
    var candySpeed : TimeInterval = 5
    private var blockCandyDestroyedCount = 0
    private var scoreTimer: Timer?

    private var mainCandy: SKSpriteNode!
    private let candyWidthRatio: CGFloat = 1/3
    private var moveDistance: CGFloat {
        return self.size.width * candyWidthRatio
    }
    private var isGamePaused = false
    private var isMoving = false
    
    private var collisionCountm = 0

    override func didMove(to view: SKView) {
        backgroundColor = .black
        setupBackground()
        setupMainCandy()
        spawnEnemiesPeriodically()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        startScoreTimer()
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "candySelectedImageName") ?? "BG")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }
    
    private func setupMainCandy() {
        let shipSize = CGSize(width: size.width * candyWidthRatio, height: size.width * candyWidthRatio)
        mainCandy = SKSpriteNode(imageNamed: "MainCandy")
        mainCandy.size = shipSize
        mainCandy.position = CGPoint(x: size.width / 2, y: mainCandy.size.height / 2 + 50)
        mainCandy.name = "MainCandy"
        
        let physicsScale: CGFloat = 0.5
        mainCandy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: mainCandy.size.width * physicsScale, height: mainCandy.size.height * physicsScale))
        mainCandy.physicsBody?.isDynamic = true
        mainCandy.physicsBody?.categoryBitMask = PhysicsCategory.mainCandy
        mainCandy.physicsBody?.contactTestBitMask = PhysicsCategory.blockCandy | PhysicsCategory.scoreCandy
        mainCandy.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        addChild(mainCandy)

        let rotateAction = SKAction.rotate(byAngle: .pi, duration: 1)
        let repeatAction = SKAction.repeatForever(rotateAction)
        mainCandy.run(repeatAction)
    }

    
    private enum MoveDirection {
        case left, right
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if !isGamePaused {
            if location.x < size.width / 2 {
                moveMainCandy(direction: .left)
            } else {
                moveMainCandy(direction: .right)
            }
        }
    }
    
    private func moveMainCandy(direction: MoveDirection) {
        if isMoving { return }

        var newPosition = mainCandy.position.x
        switch direction {
        case .left:
            newPosition -= moveDistance
        case .right:
            newPosition += moveDistance
        }

        newPosition = max(mainCandy.size.width / 2, min(size.width - mainCandy.size.width / 2, newPosition))

        isMoving = true

        let moveAction = SKAction.moveTo(x: newPosition, duration: 0.1)
        let completionAction = SKAction.run {
            self.isMoving = false
        }

        let sequence = SKAction.sequence([moveAction, completionAction])
        mainCandy.run(sequence)
    }

    func candyPauseGame() {
        if !isGamePaused {
            isGamePaused = true
            isPaused = true
            scoreTimer?.invalidate()
        }
    }
    
    func candyResumeGame() {
        if isGamePaused {
            isGamePaused = false
            isPaused = false
            startScoreTimer()
        }
    }
    
    func candyRestartGame() {
        removeAllChildren()
        setupBackground()
        setupMainCandy()
        blockCandyDestroyedCount = 0
        collisionCountm = 0
        candyGameController?.HP3()
        isGamePaused = false
        isPaused = false
        
        startScoreTimer()
    }
    
    private func spawnEnemiesPeriodically() {
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnEnemies()
        }
        let waitAction = SKAction.wait(forDuration: candySpeed-2)
        let sequence = SKAction.sequence([spawnAction, waitAction])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction)
    }
    
    private func spawnEnemies() {
        updateBlockCandyDestroyedCount()
        let enemyCount = 6
        let enemySpacing: CGFloat = size.width / CGFloat(enemyCount)
        let missingEnemyIndex = [0, 2, 4].randomElement()!
        
        for i in 0..<enemyCount {
            if i == missingEnemyIndex || i == missingEnemyIndex + 1 { continue }
            
            let enemy = SKSpriteNode(imageNamed: "BlockCandy")
            let sizeRatio: CGFloat = 1/6
            let enemySize = CGSize(width: size.width * sizeRatio, height: size.width * sizeRatio)
            enemy.size = enemySize
            
            let xPosition = CGFloat(i) * enemySpacing + enemySize.width / 2
            enemy.position = CGPoint(x: xPosition, y: size.height + enemySize.height / 2)
            enemy.name = "BlockCandy"
            
            let physicsScale: CGFloat = 0.5
            enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemy.size.width * physicsScale, height: enemy.size.height * physicsScale))
            enemy.physicsBody?.isDynamic = true
            enemy.physicsBody?.categoryBitMask = PhysicsCategory.blockCandy
            enemy.physicsBody?.contactTestBitMask = PhysicsCategory.mainCandy | PhysicsCategory.scoreCandy
            enemy.physicsBody?.collisionBitMask = PhysicsCategory.none
            
            enemy.userData = ["collisionCount": 0]
            
            addChild(enemy)
            
            let moveAction = SKAction.moveTo(y: -enemySize.height / 2, duration: candySpeed)
            let removeAction = SKAction.removeFromParent()
            let sequence = SKAction.sequence([moveAction, removeAction])
            enemy.run(sequence)

            if Int.random(in: 0..<100) < 10 {
                let scoreCandyPosition = CGPoint(x: xPosition, y: size.height - enemySize.height / 2 - 20)
                spawnScoreCandy(at: scoreCandyPosition)
            }
        }
    }

    private func spawnScoreCandy(at position: CGPoint) {
        let scoreCandy = SKSpriteNode(imageNamed: "ScoreCandy")
        let sizeRatio: CGFloat = 1/6
        let scoreCandySize = CGSize(width: size.width * sizeRatio, height: size.width * sizeRatio)
        scoreCandy.size = scoreCandySize
        scoreCandy.position = position
        scoreCandy.name = "ScoreCandy"
        
        let physicsScale: CGFloat = 0.5
        scoreCandy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: scoreCandy.size.width * physicsScale, height: scoreCandy.size.height * physicsScale))
        scoreCandy.physicsBody?.isDynamic = true
        scoreCandy.physicsBody?.categoryBitMask = PhysicsCategory.scoreCandy
        scoreCandy.physicsBody?.contactTestBitMask = PhysicsCategory.mainCandy
        scoreCandy.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        addChild(scoreCandy)
        
        let moveAction = SKAction.moveTo(y: -scoreCandySize.height / 2, duration: candySpeed-1)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        scoreCandy.run(sequence)
    }

    
    override func update(_ currentTime: TimeInterval) {
        if blockCandyDestroyedCount >= 1000 {
            candyGameController?.candyEndGame(candyScore: blockCandyDestroyedCount, candyIsWin: true)
        }
    }
    
    private func updateBlockCandyDestroyedCount() {
        blockCandyDestroyedCount += 1
        candyGameController?.candyUpdateScore()
    }

    private func startScoreTimer() {
        scoreTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(incrementScore), userInfo: nil, repeats: true)
    }
    
    @objc private func incrementScore() {
        updateBlockCandyDestroyedCount()
    }
}

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let mainCandy: UInt32 = 0b1
    static let blockCandy: UInt32 = 0b10
    static let scoreCandy: UInt32 = 0b100
}

extension CandyGame: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        candySound()
        
        if (firstBody.categoryBitMask == PhysicsCategory.mainCandy && secondBody.categoryBitMask == PhysicsCategory.blockCandy) ||
           (firstBody.categoryBitMask == PhysicsCategory.blockCandy && secondBody.categoryBitMask == PhysicsCategory.mainCandy) {
            
            if var collisionCount = firstBody.node?.userData?["collisionCount"] as? Int {
                collisionCountm += 1
                if collisionCountm >= 1 && collisionCountm < 3 {
                    candyGameController?.HP2()
                } else if collisionCountm >= 3 && collisionCountm < 5 {
                    candyGameController?.HP1()
                }
                firstBody.node?.userData?["collisionCount"] = collisionCount
            }
            
            if var collisionCount = secondBody.node?.userData?["collisionCount"] as? Int {
                collisionCountm += 1
                if collisionCountm >= 1 && collisionCountm < 3 {
                    candyGameController?.HP2()
                } else if collisionCountm >= 3 && collisionCountm < 5 {
                    candyGameController?.HP1()
                }
                secondBody.node?.userData?["collisionCount"] = collisionCount
            }
            
            if var collisionCount = firstBody.node?.userData?["collisionCount"] as? Int, collisionCountm < 5 {
                firstBody.node?.removeFromParent()
            }
            if var collisionCount = secondBody.node?.userData?["collisionCount"] as? Int, collisionCountm < 5 {
                secondBody.node?.removeFromParent()
            }
        }

        if (firstBody.categoryBitMask == PhysicsCategory.mainCandy && secondBody.categoryBitMask == PhysicsCategory.scoreCandy) ||
           (firstBody.categoryBitMask == PhysicsCategory.scoreCandy && secondBody.categoryBitMask == PhysicsCategory.mainCandy) {
            
            blockCandyDestroyedCount += 10
            candyGameController?.candyUpdateScoreMore()
            
            if firstBody.categoryBitMask == PhysicsCategory.scoreCandy {
                firstBody.node?.removeFromParent()
            } else if secondBody.categoryBitMask == PhysicsCategory.scoreCandy {
                secondBody.node?.removeFromParent()
            }
        }
        
        if (firstBody.categoryBitMask == PhysicsCategory.mainCandy && secondBody.categoryBitMask == PhysicsCategory.blockCandy) ||
           (firstBody.categoryBitMask == PhysicsCategory.blockCandy && secondBody.categoryBitMask == PhysicsCategory.mainCandy) {
            if collisionCountm >= 5 {
                candyGameController?.candyEndGame(candyScore: blockCandyDestroyedCount, candyIsWin: false)
            }
        }
    }

    
    func didEnd(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.blockCandy && secondBody.categoryBitMask == PhysicsCategory.none {
            updateBlockCandyDestroyedCount()
        }
    }
}
