import UIKit
import SpriteKit
import SwiftUI
import MultipeerConnectivity
 
class GameViewController: UIViewController {
    
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        let scene = MenuScene(size:CGSize(width: 768, height: 1024))
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        
        
        
    }
     
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
