import SpriteKit
import GameplayKit
import MultipeerConnectivity
import Foundation
 
enum CardLevel :CGFloat {
  case board = 10
  //case moving = 100
  case enlarged = 200
  case chosen = 100
}




class GameScene: SKScene {
    
    
    var p1 = Hand()
    var p2 = Hand()
    var p1chosenCard : Card?
    var p2chosenCard : Card?
    //var currentplayer:String!
    var p1cardsplayed = [Int]()
    var p2cardsplayed = [Int]()
    var score1 : Int = 0
    var score2 : Int = 0
    let p1score = SKLabelNode(fontNamed: "Futura")
    let p2score = SKLabelNode(fontNamed: "Futura")
    var p1confirm:Bool = false
    var p2confirm:Bool = false
    
    let flipbutton = SKSpriteNode(imageNamed: "button1")
    let backbutton = SKSpriteNode(imageNamed: "button1")
    let confirmbutton = Button(unpressedimage: "confirmbtn1", pressedimage: "confirmbtn2")
    
    var appDelegate:AppDelegate!
     
    
    override func didMove(to view: SKView) {

        
        /*appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate.mpchandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        appDelegate.mpchandler.setupSession()
        appDelegate.mpchandler.advertiseSelf(advertise: true)*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedDataWithNotification), name: NSNotification.Name("MPC_DidReceiveDataNotification"), object: nil)
        //currentplayer = UIDevice.current.name
        
        setuptable()
        setupscore()
        setupcard()
        setupbutton()
        
    }
    
    func setuptable(){
        let table = SKSpriteNode(imageNamed: "table")
        addChild(table)
        table.position = CGPoint(x: size.width/2, y: size.height/2)
        table.size = CGSize(width: size.width, height: size.height)
        table.zPosition = -1
        
    }
    
    func setupscore(){
        p1score.text = "Score: \(score1)"
        p2score.text = "Opponent: \(score2)"
        p1score.fontSize = 20
        p2score.fontSize = 20
        p1score.fontColor = SKColor.white
        p2score.fontColor = SKColor.white
        p1score.position = CGPoint(x: frame.midX-140, y: frame.midY-15)
        p2score.position = CGPoint(x:frame.midX-161, y:frame.midY+15)
        
        addChild(p1score)
        addChild(p2score)
    }
    
    func setupbutton(){
        // Flip Button
        
        flipbutton.name = "flipbtn"
        flipbutton.size.height = 44
        flipbutton.size.width = 84
        flipbutton.position = CGPoint(x: frame.midX+140, y: frame.midY-200)
        flipbutton.color = SKColor.clear
        
        // Back Button
        
        backbutton.name = "backbtn"
        backbutton.size.height = 44
        backbutton.size.width = 84
        backbutton.position = CGPoint(x: frame.midX+40, y: frame.midY-200)
        backbutton.color = SKColor.clear
        
        // Confirm Button to start round
        
        confirmbutton.name = "confirmbtn"
        confirmbutton.size.height = 72
        confirmbutton.size.width = 72
        confirmbutton.position = CGPoint(x: frame.midX+140, y: frame.midY)
        confirmbutton.color = SKColor.clear
        
        addChild(flipbutton)
        addChild(backbutton)
        addChild(confirmbutton)
    }

    func setupcard(){
        //let p2 = Hand()
        for (index,card) in p1.hand.enumerated(){
            card.position = CGPoint(x: frame.midX-180+50*(CGFloat(index)), y: frame.midY-300)
            card.size = CGSize(width: 64, height: 89)
            addChild(card)
        }
        
        p2.hand.shuffle()
        for (index,card) in p2.hand.enumerated(){
            card.position = CGPoint(x: frame.midX-180+50*(CGFloat(index)), y: frame.midY+300)
            card.size = CGSize(width: 64, height: 89)
            card.flip()
            addChild(card)
        }
    }
    
    func startround(){
        if let card1 = p1chosenCard, let card2 = p2chosenCard{
            let card1num = card1.cardType.rawValue
            let card2num = card2.cardType.rawValue
            if card1num > card2num{
                score1+=1
            }else if card1num < card2num{
                score2+=1
            }
            
            p1cardsplayed.append(card1num)
            p2cardsplayed.append(card2num)
            
            if let p2cardindex = p2.hand.firstIndex(where: {$0.cardType.rawValue == card2num}){
                p1.hand[card1num-1].removeFromParent()
                p2.hand[p2cardindex].removeFromParent()
            }
        }
    }
    
    func updatescore(){
        p1score.text = "My Score: \(score1)"
        p2score.text = "Opponent: \(score2)"
    }
    
    func checkresults(){
        p1chosenCard = nil
        p2chosenCard = nil
        // Check if any card remains on board
        for card in p1.hand{
            if card.parent == self{
                return
            }else{
                continue
            }
        }
        // Create alerts
        let alert:UIAlertController
        let resultalert:UIAlertController
        let rootViewController = self.view?.window!.rootViewController!
        
        // Fill in the result
        var results:String = "Round\n"
        for i in 0...(p1cardsplayed.count-1) {
            results.append("\(p1cardsplayed[i]) \(i) \(p2cardsplayed[i]) \n")
        }
        
        resultalert = UIAlertController(title:"Black and White", message: results, preferredStyle: UIAlertController.Style.alert)
        let menuScene = MenuScene(size:CGSize(width: 768, height: 1024))
        menuScene.scaleMode = .aspectFill
        let gameScene = GameScene(size:CGSize(width: 768, height: 1024))
        gameScene.scaleMode = .aspectFill
        resultalert.addAction(UIAlertAction(title:"Main Menu", style: UIAlertAction.Style.default, handler: { action in self.view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.25))
        }))
        resultalert.addAction(UIAlertAction(title:"Play Again", style: UIAlertAction.Style.default, handler: { action in self.view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 0.25))
        }))
        
        // Check who won
        if score1 > score2{
            alert = UIAlertController(title:"Black and White", message:"You Won", preferredStyle: UIAlertController.Style.alert)
            
        }else if score1 < score2{
            alert = UIAlertController(title:"Black and White", message:"You Lost", preferredStyle: UIAlertController.Style.alert)
            
        }else{
            alert = UIAlertController(title:"Black and White", message:"You Tied", preferredStyle: UIAlertController.Style.alert)
            
        }
        alert.addAction(UIAlertAction(title: "View Results", style: UIAlertAction.Style.default, handler: { action in rootViewController!.present(resultalert, animated: true, completion: nil)
        }))
        
        
        
        rootViewController!.present(alert, animated: true, completion: nil)
        
    }
    
    func moveP1CardToMiddle(card: Card){
        p1chosenCard?.run(SKAction.move(to: CGPoint(x: frame.midX-180+50*(CGFloat((p1chosenCard?.cardType.rawValue ?? 1)-1)), y: frame.midY-300), duration: 0.5))
        p1chosenCard = card
        card.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
        card.run(SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY-60), duration: 0.5))
    }
    func moveP2CardToMiddle(cardRawValue: Int){
        
        p2chosenCard?.run(SKAction.move(to: CGPoint(x: frame.midX-180+50*(CGFloat((p2chosenCard?.cardType.rawValue ?? 1)-1)), y: frame.midY+300), duration: 0.5))
        p2chosenCard = p2.hand.first(where: {$0.cardType.rawValue == cardRawValue})
        p2chosenCard?.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
        p2chosenCard?.run(SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY+60), duration: 0.5))
    }
    
    
    @objc func handleReceivedDataWithNotification(notification:NSNotification){
        let userInfo = notification.userInfo! as Dictionary
        let receivedData:NSData = userInfo["data"] as! NSData
        
        do{
            
            let message = try JSONSerialization.jsonObject(with: receivedData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            let senderPeerID:MCPeerID = userInfo["peerID"] as! MCPeerID
            _ = senderPeerID.displayName
            
            if let p2chosenCardRawValue = message.object(forKey: "chosencard") as? Int{
                moveP2CardToMiddle(cardRawValue: p2chosenCardRawValue)
            }else if let p2confirm = message.object(forKey: "confirm") as? Bool{
                self.p2confirm = p2confirm
                if(self.p1confirm == true && self.p2confirm == true){
                    startround()
                    updatescore()
                    self.p1confirm = false
                    self.p2confirm = false
                    checkresults()
                    
                }
                
            }
            
            
        }catch{
            print("error: \(error.localizedDescription)")
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            // Double click to choose a card
            if let card = atPoint(location) as? Card {
              //card.zPosition = CardLevel.moving.rawValue
              //card.removeAction(forKey: "drop")
              //card.run(SKAction.scale(to: 1.1, duration: 0.25), withKey: "pickup")
              if touch.tapCount > 1 {
                if location.y < frame.midY{
                    moveP1CardToMiddle(card: card)
                }
                let messageDict = ["chosencard": p1chosenCard!.cardType.rawValue] as [String : Any]
                
                do{
                    let messageData = try JSONSerialization.data(withJSONObject: messageDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                    appDelegate = UIApplication.shared.delegate as? AppDelegate
                    try appDelegate.mpchandler.session.send(messageData, toPeers: appDelegate.mpchandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
                }catch{
                    print("error: \(error.localizedDescription)")
                }
                //card.flip()
              }

            }
            
            let touchedNode = self.atPoint(location)
            
            if let name = touchedNode.name {
                
                // Confirm Button
                if name == "confirmbtn"{
                    confirmbutton.pressed()
                }
            }
            
            
      }
    }


    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      for touch in touches {
        let location = touch.location(in: self)
        if let card = atPoint(location) as? Card {
            // Scale a card bigger if tapped once
            if location.y < frame.midY{
                for cards in p1.hand{
                cards.zPosition = CardLevel.board.rawValue
                cards.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
                }
                card.zPosition = CardLevel.chosen.rawValue
                card.run(SKAction.scale(to: 1.2, duration: 0.25), withKey: "choose")
            }else if location.y > frame.midY{
                for cards in p2.hand{
                cards.zPosition = CardLevel.board.rawValue
                cards.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
                }
                card.zPosition = CardLevel.chosen.rawValue
                card.run(SKAction.scale(to: 1.2, duration: 0.25), withKey: "choose")
            }
        }else{
            // Scale all card back to normal
            if location.y < frame.midY{
                for cards in p1.hand{
                    cards.zPosition = CardLevel.board.rawValue
                    cards.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
                }
            }else if location.y > frame.midY{
                for cards in p2.hand{
                    cards.zPosition = CardLevel.board.rawValue
                    cards.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
                }
            }
        }
        
        let touchedNode = self.atPoint(location)
        
        if let name = touchedNode.name {
            // Flip Button
            if name == "flipbtn" {
                /*for card in p1.hand{
                    card.flip()
                }*/
                
                /*appDelegate.mpchandler.setupMCBrowser()
                let gameViewController = self.view?.window!.rootViewController!
                gameViewController!.present(appDelegate.mpchandler.browser, animated: true, completion: nil)*/
            }
            
            // Back button to put back card
            if name == "backbtn"{
                p1.hand[(p1chosenCard?.cardType.rawValue ?? 1)-1].run(SKAction.move(to: CGPoint(x: frame.midX-180+50*(CGFloat((p1chosenCard?.cardType.rawValue ?? 1)-1)), y: frame.midY-300), duration: 0.25))
                p2.hand[(p2chosenCard?.cardType.rawValue ?? 1)-1].run(SKAction.move(to: CGPoint(x: frame.midX-180+50*(CGFloat((p2chosenCard?.cardType.rawValue ?? 1)-1)), y: frame.midY+300), duration: 0.25))
            }
            
            // Confirm Button
            if name == "confirmbtn"{
                confirmbutton.unpressed()
                p1confirm = true
                let messageDict = ["confirm": p1confirm] as [String : Bool]
                
                do{
                    let messageData = try JSONSerialization.data(withJSONObject: messageDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                    appDelegate = UIApplication.shared.delegate as? AppDelegate
                    try appDelegate.mpchandler.session.send(messageData, toPeers: appDelegate.mpchandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
                }catch{
                    print("error: \(error.localizedDescription)")
                }
                
                if(self.p1confirm == true && self.p2confirm == true){
                    startround()
                    updatescore()
                    self.p1confirm = false
                    self.p2confirm = false
                    checkresults()
                }
            }
        }
        
        //if let card = atPoint(location) as? Card {
          //card.zPosition = CardLevel.board.rawValue
          //card.removeAction(forKey: "pickup")
          //card.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
          //card.removeFromParent()
          //addChild(card)
        //}
      }
    }
    
    /*override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      for touch in touches {
        let location = touch.location(in: self)           // 1
        if let card = atPoint(location) as? Card {        // 2
          card.position = location
        }
      }
    }*/

    
    
}
