//
//  MatchesViewModel.swift
//  Chinchilla
//
//  Created by Wyatt Sell on 10/03/2024.
//

import Foundation

class MatchesViewModel: ObservableObject {
    
    private var timer: Timer?
    @Published var matches: [[String: Any]] = []
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task {
                //let deviceID = UserDefaults.standard.string(forKey: "userID") ?? "ERROR"
                NetworkingManager.shared.sendToEnpoint(endpoint: "/get_contacts", method: "GET", body: nil) { result in
                    do {
                        let matches = try result.get()
                        print(matches)
                        DispatchQueue.main.async {
                            // Update matches on the main thread
                            self.matches = matches as! [[String: Any]]
                        }
                        
                    } catch {
                        print("Error getting matches")
                    }
                    
                }
                
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
