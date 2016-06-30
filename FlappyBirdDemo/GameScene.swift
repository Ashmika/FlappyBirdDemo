//
//  GameScene.swift
//  FlappyBirdDemo
//
//  Created by xoyal on 30/06/16.
//  Copyright (c) 2016 xoyal. All rights reserved.
//

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate
{
    
    
    var myBackground=SKSpriteNode()
    
    var myFloor1 = SKSpriteNode()
     var myFloor2 = SKSpriteNode()
    
    let birdAtlas=SKTextureAtlas(named:"player.atlas")
    var birdSprites=Array<SKTexture>()
    var bird = SKSpriteNode()
    
    
    var bottomPipe1 = SKSpriteNode()
    var bottomPipe2 = SKSpriteNode()
    var topPipe1 = SKSpriteNode()
    var topPipe2 = SKSpriteNode()
    var start = Bool(false)
    var birdIsActive = Bool(false)
    var pipeHeight = CGFloat(200)
    
    
    let birdCategory:UInt32 = 0x1 << 0
    let pipeCategory:UInt32 = 0x1 << 1
    
    
    
    override func didMoveToView(view: SKView)
    {
        
        
        /* Setup your scene here */
        
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsWorld.contactDelegate = self
        
        
        
        myBackground=SKSpriteNode(imageNamed: "background")
        
        
        myBackground.anchorPoint=CGPointZero;
        
        myBackground.position=CGPointMake(100, 0);
        
    self.backgroundColor=SKColor(red: 80/255.0,green:192/255.0,blue:203/255.0,alpha:1.0)
        addChild(self.myBackground)
        myFloor1=SKSpriteNode(imageNamed: "floor")
          myFloor2=SKSpriteNode(imageNamed: "floor")
        myFloor1.anchorPoint=CGPointZero;
        
        myFloor1.position=CGPointMake(0, 0);
        myFloor2.anchorPoint=CGPointZero;
        
        myFloor2.position=CGPointMake(myFloor1.size.width-1, 0);
        
        addChild(self.myFloor1)
        addChild(self.myFloor2)
        
        
        birdSprites.append(birdAtlas.textureNamed("player1"))
        birdSprites.append(birdAtlas.textureNamed("player2"))
        birdSprites.append(birdAtlas.textureNamed("player3"))
        birdSprites.append(birdAtlas.textureNamed("player4"))
        
        
        bird=SKSpriteNode(texture: birdSprites[0])
        
        bird.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        bird.size.width = bird.size.width / 10
        bird.size.height = bird.size.height / 10
        
        
        let animateBird = SKAction.animateWithTextures(self.birdSprites, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatActionForever(animateBird)
        self.bird.runAction(repeatAction)
        
        
        addChild(self.bird)
        
        
        
        
        bottomPipe1 = SKSpriteNode(imageNamed: "bottomPipe")
        bottomPipe2 = SKSpriteNode(imageNamed: "bottomPipe")
        topPipe1 = SKSpriteNode(imageNamed: "topPipe")
        topPipe2 = SKSpriteNode(imageNamed: "topPipe")
        
        bottomPipe1.position = CGPointMake(800, 200);
        bottomPipe1.size.height = bottomPipe1.size.height / 2
        bottomPipe1.size.width = bottomPipe1.size.width / 2
        bottomPipe1.physicsBody?.categoryBitMask = pipeCategory
        bottomPipe1.physicsBody?.contactTestBitMask = birdCategory

        
        bottomPipe2.position = CGPointMake(1600, 200);
        bottomPipe2.size.height = bottomPipe2.size.height / 2
        bottomPipe2.size.width = bottomPipe2.size.width / 2
        bottomPipe2.physicsBody?.categoryBitMask = pipeCategory
        bottomPipe2.physicsBody?.contactTestBitMask = birdCategory

        
        topPipe1.position = CGPointMake(800, 200 * 5);
        topPipe1.size.height = topPipe1.size.height / 2
        topPipe1.size.width = topPipe1.size.width / 2
        topPipe1.physicsBody?.categoryBitMask = pipeCategory
        topPipe1.physicsBody?.contactTestBitMask = birdCategory

        
        
        topPipe2.position = CGPointMake(1600, 200 * 5);
        topPipe2.size.height = topPipe2.size.height / 2
        topPipe2.size.width = topPipe2.size.width / 2
        topPipe2.physicsBody?.categoryBitMask = pipeCategory
        topPipe2.physicsBody?.contactTestBitMask = birdCategory

    
        
        
        addChild(self.bottomPipe1)
        addChild(self.bottomPipe2)
        addChild(self.topPipe1)
        addChild(self.topPipe2)
        
        
        bottomPipe1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bottomPipe"), size: self.bottomPipe1.size)
        
        bottomPipe2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bottomPipe"), size: self.bottomPipe2.size)
        
        topPipe1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "topPipe"), size: self.topPipe1.size)
        
        topPipe2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "topPipe"), size: self.topPipe2.size)
        
        myFloor1.physicsBody = SKPhysicsBody(edgeLoopFromRect: myFloor1.frame)
        
        myFloor2.physicsBody = SKPhysicsBody(edgeLoopFromRect: myFloor1.frame)
        
        
        bottomPipe1.physicsBody?.dynamic = false
        bottomPipe2.physicsBody?.dynamic = false
        topPipe1.physicsBody?.dynamic = false
        topPipe2.physicsBody?.dynamic = false
        

        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
   
        start=true;
        
        if (birdIsActive)
        {
            self.bird.physicsBody!.applyImpulse(CGVectorMake(0, 150))
        }
        else
        {
            createBirdPhysics()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        bird.position.x = self.frame.width / 2
        bird.physicsBody?.allowsRotation = false

        
        
        myFloor1.position = CGPointMake(myFloor1.position.x-4, myFloor1.position.y);
        myFloor2.position = CGPointMake(myFloor2.position.x-4, myFloor2.position.y);
        
        if (myFloor1.position.x < -myFloor1.size.width / 2){
            myFloor1.position = CGPointMake(myFloor2.position.x + myFloor2.size.width, myFloor1.position.y);
        }
        
        if (myFloor2.position.x < -myFloor2.size.width / 2) {
            myFloor2.position = CGPointMake(myFloor1.position.x + myFloor1.size.width, myFloor2.position.y);
        }
        
        
        if (start) {
            
            bottomPipe1.position = CGPointMake(bottomPipe1.position.x-8, 200);
            bottomPipe2.position = CGPointMake(bottomPipe2.position.x-8, bottomPipe2.position.y);
            topPipe1.position = CGPointMake(topPipe1.position.x-8, 800);
            topPipe2.position = CGPointMake(topPipe2.position.x-8, 700);
            
            if (bottomPipe1.position.x < -bottomPipe1.size.width + 600 / 2){
                bottomPipe1.position = CGPointMake(bottomPipe2.position.x + bottomPipe2.size.width * 4, pipeHeight);
                topPipe1.position = CGPointMake(topPipe2.position.x + topPipe2.size.width * 4, pipeHeight);
            }
            
            if (bottomPipe2.position.x < -bottomPipe2.size.width + 600 / 2) {
                bottomPipe2.position = CGPointMake(bottomPipe1.position.x + bottomPipe1.size.width * 4, pipeHeight);
                topPipe2.position = CGPointMake(topPipe1.position.x + topPipe1.size.width * 4, pipeHeight);
            }
            
            if (bottomPipe1.position.x < self.frame.width/2)
            {
                pipeHeight = randomBetweenNumbers(100, secondNum: 240)
            }
            
            
            
        }
        
        
    }
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat
    {
        
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
        
    }
    
    func createBirdPhysics()
    {
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.bird.size.width / 2))
        
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.contactTestBitMask = pipeCategory
        
        birdIsActive = true
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //GAMEOVER = TRUE
        print("BIRD HAS MADE CONTACT")
        
        
    }

}
