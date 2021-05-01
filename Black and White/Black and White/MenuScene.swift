//
//  MenuScene.swift
//  Black and White
//
//  Created by Kaiming Lo on 10/6/20.
//


import GameKit
import SpriteKit
import MultipeerConnectivity

class MenuScene: SKScene, MCBrowserViewControllerDelegate{
    
    var appDelegate:AppDelegate!
    private let transition = SKTransition.fade(withDuration: 0.5)
    //private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    

    let localButton = Button(unpressedimage: "confirmbtn1", pressedimage: "confirmbtn2")
    let startButton = Button(unpressedimage: "confirmbtn1", pressedimage: "confirmbtn2")
  
  // MARK: - Init
  
    /*override init() {
    super.init(size: .zero)

    scaleMode = .resizeFill
    }
    

    required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }*/

    override func didMove(to view: SKView) {
    super.didMove(to: view)

    //feedbackGenerator.prepare()

    setUpScene()
        
    appDelegate = UIApplication.shared.delegate as? AppDelegate
    appDelegate.mpchandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
    appDelegate.mpchandler.setupSession()
    appDelegate.mpchandler.advertiseSelf(advertise: true)
    }

    /*override func didChangeSize(_ oldSize: CGSize) {
    removeAllChildren()
    setUpScene(in: view)
    }*/
  
    private func setUpScene() {

    let menuBackground = SKSpriteNode(imageNamed: "menuBackground")
    addChild(menuBackground)

    localButton.name = "localButton"
    localButton.size.width = 150
    localButton.size.height = 150
    localButton.position = CGPoint(x: frame.midX, y: frame.midY)
    localButton.color = SKColor.clear

    addChild(localButton)
        
    startButton.name = "startButton"
    startButton.size.width = 150
    startButton.size.height = 150
    startButton.position = CGPoint(x: frame.midX, y: frame.midY-200)
    startButton.color = SKColor.clear

    addChild(startButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      for touch in touches {
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        if let name = touchedNode.name {
            if name == "localButton"{
              localButton.pressed()
            }
        }
        
      }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      for touch in touches {
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        if let name = touchedNode.name {
            if name == "localButton"{
              
                localButton.unpressed()
                //let gameScene = GameScene(size:CGSize(width: 768, height: 1024))
                //gameScene.scaleMode = .aspectFill
                //self.view?.presentScene(gameScene, transition: self.transition)
                
                if appDelegate.mpchandler.session != nil{
                    appDelegate.mpchandler.setupBrowser()
                    appDelegate.mpchandler.browser.delegate = self
                    
                    let gameViewController = self.view?.window!.rootViewController!
                    gameViewController!.present(appDelegate.mpchandler.browser, animated: true, completion: nil)
                }
                
            }else if name == "startButton"{
                let gameScene = GameScene(size:CGSize(width: 768, height: 1024))
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: self.transition)
            }
        }
        
      }
        
    }
    
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpchandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpchandler.browser.dismiss(animated: true, completion: nil)
    }
    
   
    
    
}

