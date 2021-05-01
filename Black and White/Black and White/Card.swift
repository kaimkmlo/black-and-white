//
//  Card.swift
//  Black and White
//
//  Created by Kaiming Lo on 9/28/20.
//

import Foundation
import SpriteKit

enum CardType :Int {
  case one = 1,
       two,
       three,
       four,
       five,
       six,
       seven,
       eight
}


class Card : SKSpriteNode {
  let cardType :CardType
  let frontTexture :SKTexture
  let backTexture :SKTexture
  var faceUp = true
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoding not supported")
  }
  
  init(cardType: CardType) {
    self.cardType = cardType
    
    switch cardType {
    case .one:
      frontTexture = SKTexture(imageNamed: "AS")
        backTexture = SKTexture(imageNamed:"redback")
    case .two:
      frontTexture = SKTexture(imageNamed: "2S")
        backTexture = SKTexture(imageNamed:"blueback")
    case .three:
      frontTexture = SKTexture(imageNamed: "3S")
        backTexture = SKTexture(imageNamed:"redback")
    case .four:
      frontTexture = SKTexture(imageNamed: "4S")
        backTexture = SKTexture(imageNamed:"blueback")
    case .five:
      frontTexture = SKTexture(imageNamed: "5S")
        backTexture = SKTexture(imageNamed:"redback")
    case .six:
      frontTexture = SKTexture(imageNamed: "6S")
        backTexture = SKTexture(imageNamed:"blueback")
    case .seven:
      frontTexture = SKTexture(imageNamed: "7S")
        backTexture = SKTexture(imageNamed:"redback")
    case .eight:
      frontTexture = SKTexture(imageNamed: "8S")
        backTexture = SKTexture(imageNamed:"blueback")
    }
    
    super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
  }
    
    func flip() {
      if faceUp {
        self.texture = backTexture
      } else {
        self.texture = frontTexture
      }
      faceUp = !faceUp
    }
}
