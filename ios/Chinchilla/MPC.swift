//
//  MPC.swift
//  Chinchilla
//
//  Created by Samantha Vaca on 3/9/24.
//

import Foundation
import MultipeerConnectivity
import UIKit

/*
class GlobalViewModel: ObservableObject {
    @Published var peerInformation: [String] = []
    
    init() {
        peerInformation = []
    }
    
    func addPeerInfo(_ info: String) {
        peerInformation.append(info)
    }
}
 */

var peerInformation: [String] = []

class MultipeerManager: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(peerID)
        if let message = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                // Handle the received message on the main thread
                print("Received message: \(message) from \(peerID.displayName)")
                
                if !(peerInformation.contains(message)) {
                    // Add information to the array
                    peerInformation.append(message)
                }
            }
        } else {
            print("Failed to decode message from \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(peerID)
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(peerID)
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        print(peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print(peerID)
    }
    
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    
    
    override init() {
        super.init()
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: "chin-chill")
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "chin-chill")
        advertiser.delegate = self
        
        startServices()
    }
    
    func startServices() {
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    // MCNearbyServiceBrowserDelegate method
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found peer: \(peerID.displayName)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }

    // MCSessionDelegate method
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connected {
            print("Connected to \(peerID.displayName)")
            sendData(message: UserDefaults.standard.string(forKey: "userID") ?? "ERROR")
        }
    }

    // Automatically accept invitations
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
    
    func sendData(message: String) {
        guard session.connectedPeers.count > 0 else {
            print("No connected peers")
            return
        }
        
        if let data = message.data(using: .utf8) {
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
    }
    
}


