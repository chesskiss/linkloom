import SwiftUI
import AVFoundation


struct ListeningView: View  {
    @StateObject var speechRecognizer: SpeechRecognizer
    @StateObject var viewModel: ListenViewModel
    
    @State private var isRecording = false
    
    var multipeerManager = MultipeerManager()
    
    init() {
        let sr = SpeechRecognizer()
        let viewModel = ListenViewModel(speechRecognizer: sr)
        self._speechRecognizer = StateObject(wrappedValue: sr)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
        
    
    var body: some View {
        VStack {
            Text(speechRecognizer.transcript).foregroundColor(.black)
            
        }
        .onAppear {
            startListening()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func startListening() {
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    
    private func stopListening() {
        speechRecognizer.stopTranscribing()
        isRecording = false
    }
}




struct ListeningViewapView_Previews: PreviewProvider {
    static var previews: some View {
        let speechRecognizer = SpeechRecognizer()
        let viewModel = ListenViewModel(speechRecognizer: speechRecognizer)
        return ListeningView()
    }
}
