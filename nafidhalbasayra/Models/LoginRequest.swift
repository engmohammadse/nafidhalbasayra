//
//  LoginRequest.swift
//  nafidhalbasayra
//
//  Created by muhammad on 15/10/2024.
//

import Foundation
import Network

// Login Model
struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let id: String
    let state: Int
    let message: String
}

// ErrorResponse Model for 401 Errors
struct ErrorResponse: Codable {
    let message: String
}

// API Service
class ApiService {
    
    // Network connectivity checker
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        
        // Check network connectivity
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // Internet is available, proceed with login
                
                guard let url = URL(string: "http://198.244.227.48:8082/auth/teachers/login") else {
                    print("Invalid URL")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                let loginData = LoginRequest(username: username, password: password)

                do {
                    let requestBody = try JSONEncoder().encode(loginData)
                    request.httpBody = requestBody
                } catch {
                    completion(.failure(error))
                    return
                }

                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response from server"])))
                        return
                    }

                    // Handle 401 Unauthorized status
                    if httpResponse.statusCode == 401 {
                        if let data = data {
                            do {
                                // Decode the error message from response body
                                let decodedError = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                let errorMessage = decodedError.message
                                let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                                completion(.failure(error))
                            } catch {
                                completion(.failure(error))
                            }
                        } else {
                            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
                        }
                        return
                    }

                    // Handle success (200 status code)
                    if httpResponse.statusCode == 200 {
                        guard let data = data else {
                            print("No data returned")
                            return
                        }

                        do {
                            let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                            DispatchQueue.main.async {
                                completion(.success(decodedResponse))
                            }
                        } catch let decodingError {
                            completion(.failure(decodingError))
                        }
                    } else {
                        // Handle other unexpected server responses
                        completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected server response"])))
                    }
                }.resume()
                
            } else {
                // No internet connection
                let error = NSError(domain: "", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])
                completion(.failure(error))
            }
        }
    }
}


