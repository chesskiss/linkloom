import Foundation
import FirebaseAuth
import Firebase
import Combine

class ListenViewModel: ObservableObject {
    private var speechRecognizer: SpeechRecognizer
    private var timer: Timer?
    private var cancellables: Set<AnyCancellable> = []
    
    init(speechRecognizer: SpeechRecognizer) {
        self.speechRecognizer = speechRecognizer
        
        print("Init occured")
        
        
        // Start the timer
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task {
                let proximities = peerInformation // TODO FIX
                let deviceID = UserDefaults.standard.string(forKey: "userID") ?? "ERROR"
                let transcript = await self.speechRecognizer.getTranscript()
                self.sendTranscriptToServer(transcript, proximities, deviceID)
                await speechRecognizer.resetTranscript()
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func sendTranscriptToServer(_ transcript: String, _ proximities: [String], _ deviceID: String) {
        guard let firebaseToken = Auth.auth().currentUser?.uid else {
            print("Firebase token not available")
            return
        }
        
        NetworkingManager.shared.sendToEnpoint(endpoint: "/input", method: "POST", body: ["transcript": transcript, "devices": proximities, "deviceID": deviceID]) { _ in }
        
        print("SENDING THE TRANSCRIPT")
        print(transcript)
        
        print("SENDING THE PROXIMITIES")
        print(proximities)
        
        print("SENDING THE DEVICE ID")
        print(deviceID)
    }
}
