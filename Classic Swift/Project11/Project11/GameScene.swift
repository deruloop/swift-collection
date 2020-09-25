//
//  GameScene.swift
//  Project11
//
//  Created by Cristiano Calicchia on 11/09/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var numberOfPins = 0
    var balls = ["ballRed","ballBlue","ballYellow","ballPurple","ballCyan","ballGrey","ballGreen"]
    
    var ballsLabel: SKLabelNode!

    var ballsCount = 5 {
        didSet {
            ballsLabel.text = "Balls: \(ballsCount)"
        }
    }
    
    var editLabel: SKLabelNode!

    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLabel.text = "Balls: 5"
        ballsLabel.horizontalAlignmentMode = .right
        ballsLabel.position = CGPoint(x: 980, y: 700)
        addChild(ballsLabel)
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)

            let objects = nodes(at: location)

            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                if editingMode {
                    //create a box
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location
                    box.name = "pin"

                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    numberOfPins += 1

                    addChild(box)
                } else {
                    if location.y > 540 {
                        //create a ball
                        let ball = SKSpriteNode(imageNamed: balls.randomElement()!)
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                        ball.physicsBody?.restitution = 0.4
                        ball.position = location
                        ball.name = "ball"
                        addChild(ball)
                    }
                }
                
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }

        slotBase.position = position
        slotGlow.position = position

        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        addChild(slotBase)
        addChild(slotGlow)
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        
        switch object.name {
        case "good":
            ballsCount += 1
            destroy(ball: ball)
        case "bad":
            ballsCount -= 1
            destroy(ball: ball)
        case "pin":
            numberOfPins -= 1
            destroy(object: object)
        default:
            break
        }
    }

    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }

        ball.removeFromParent()
        
        if ballsCount == 0 {
            //game failed, alert and restart the balls
            gameFailed()
        }
    }
    
    func destroy(object: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = object.position
            addChild(fireParticles)
        }

        object.removeFromParent()
        
        print(numberOfPins)
        
        if numberOfPins == 0 {
            gameWon()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    func gameFailed(){
        print("You failed")
        ballsCount = 5
    }
    
    func gameWon(){
        print("You won")
        ballsCount = 5
    }
}
