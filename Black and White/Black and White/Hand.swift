//
//  Hand.swift
//  Black and White
//
//  Created by Kaiming Lo on 9/28/20.
//

import Foundation

class Hand {
    var hand = [Card]()
    
    init(){
        hand.append(Card(cardType: .one))
        hand.append(Card(cardType: .two))
        hand.append(Card(cardType: .three))
        hand.append(Card(cardType: .four))
        hand.append(Card(cardType: .five))
        hand.append(Card(cardType: .six))
        hand.append(Card(cardType: .seven))
        hand.append(Card(cardType: .eight))
    }
    
    func reset(){
        hand.removeAll()
        hand.append(Card(cardType: .one))
        hand.append(Card(cardType: .two))
        hand.append(Card(cardType: .three))
        hand.append(Card(cardType: .four))
        hand.append(Card(cardType: .five))
        hand.append(Card(cardType: .six))
        hand.append(Card(cardType: .seven))
        hand.append(Card(cardType: .eight))
    }
    
    func playcard (value: Int){
        hand.remove(at: value-1)
    }
}



