//
//  MPCHandler.swift
//  Black and White
//
//  Created by Kaiming Lo on 10/7/20.
//

import Foundation
import MultipeerConnectivity

class MPCHandler: NSObject, MCSessionDelegate, MCBrowserViewControllerDelegate{
    
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant!
    
    func setupPeerWithDisplayName (displayName: String){
        peerID = MCPeerID(displayName: displayName)

    }
    func setupSession(){
        session = MCSession(peer: peerID)
        session.delegate = self
    }
    
    func setupBrowser(){
        browser = MCBrowserViewController(serviceType: "bnw", session: session)
        
    }
    
    func advertiseSelf(advertise:Bool){
        if advertise{
            advertiser = MCAdvertiserAssistant(serviceType: "bnw", discoveryInfo: nil, session: session)
            advertiser.start()
        }else{
            advertiser.stop()
            advertiser = nil
        }
    }
    
    func setupMCBrowser(){
        if self.session != nil{
            self.setupBrowser()
            self.browser.delegate = self
            
            
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerID":peerID, "state":state.rawValue] as [String : Any]
        DispatchQueue.main.async {
            ()-> Void in NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MPCDidChangeStateNotification"),object:nil,userInfo:userInfo)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo = ["data":data, "peerID":peerID] as [String : Any]
        DispatchQueue.main.async {
            ()-> Void in NotificationCenter.default.post(name: NSNotification.Name("MPC_DidReceiveDataNotification"),object:nil,userInfo:userInfo)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
   
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.browser.dismiss(animated: true, completion: nil)
    }
    
    
}
