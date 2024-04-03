//
//  NearbyUsers.swift
//  Chinchilla
//
//  Created by Samantha Vaca on 3/9/24.
//

import Foundation

class BonjourManager: NSObject, NetServiceBrowserDelegate {
    var serviceBrowser: NetServiceBrowser!

    override init() {
        super.init()
        serviceBrowser = NetServiceBrowser()
        serviceBrowser.delegate = self
        serviceBrowser.searchForServices(ofType: "_Chinchilla._tcp", inDomain: "")
        print("BONJOURING")
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("Found Service: \(service)")
        // Handle found service here
        // For example, you can add the service to an array
        // or perform other actions based on the discovered service
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        print("Removed Service: \(service)")
        // Handle removed service here
        // For example, you can remove the service from an array
        // or perform other actions based on the removed service
    }
}
