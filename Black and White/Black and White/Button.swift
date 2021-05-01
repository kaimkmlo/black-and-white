//
//  Button.swift
//  Black and White
//
//  Created by Kaiming Lo on 10/5/20.
//
import SpriteKit

class Button : SKSpriteNode{
    var btntexture: SKTexture
    var pressedimage: String
    var unpressedimage: String
    
    init (unpressedimage: String, pressedimage: String){
        self.pressedimage = pressedimage
        self.unpressedimage = unpressedimage
        btntexture = SKTexture(imageNamed: unpressedimage)
        
        super.init(texture: btntexture, color: UIColor.clear, size: btntexture.size())
    }
    
    func pressed(){
        btntexture = SKTexture(imageNamed: self.pressedimage)
        self.texture = btntexture
    }
    
    func unpressed(){
        self.btntexture = SKTexture(imageNamed: self.unpressedimage)
        self.texture = btntexture
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
