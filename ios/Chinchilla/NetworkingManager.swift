import Foundation
import FirebaseAuth

class NetworkingManager {
    static let shared = NetworkingManager()
    
    private let baseURL = URL(string: "http://localhost:5000")!
    
    func sendToEnpoint(endpoint: String, method: String, body: [String: Any]?, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        // Get Firebase ID token using completion handler
        Auth.auth().currentUser?.getIDTokenResult(completion: { idToken, error in
            guard let idToken = idToken, error == nil else {
                print("Error getting ID token: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Set request method
            request.httpMethod = method
            
            // Set request headers
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(idToken.token)", forHTTPHeaderField: "Authorization")
            
            // Convert request body to JSON data
            do {
                if (body != nil) {
                    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                }
            } catch {
                print("Error encoding request body: \(error)")
                completion(.failure(error))
                return
            }
            
            // Create URLSession data task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: nil)))
                    return
                }
                
                if response.statusCode == 200 {
                    print("Transcript successfully sent to server")
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        completion(.success(json))
                    } catch {
                        print("Error decoding response: \(error)")
                        completion(.failure(error))
                    }
                } else {
                    print("Server error: \(response.statusCode)")
                    completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: nil)))
                }
            }
            
            // Start the data task
            task.resume()
        })
    }
}
