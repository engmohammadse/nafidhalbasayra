//
//  LoginRequest.swift
//  nafidhalbasayra
//
//  Created by muhammad on 15/10/2024.
//



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
    // إصلاح المشكلة: إضافة متغير لحفظ حالة الخطأ
    private var lastErrorMessage: String?

    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        // إعادة تعيين الخطأ السابق عند بداية محاولة جديدة
        lastErrorMessage = nil

        guard let url = URL(string: "http://198.244.227.48:8082/auth/teachers/login") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
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

            if httpResponse.statusCode == 401 {
                if let data = data {
                    do {
                        let decodedError = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        let errorMessage = decodedError.message

                        // إصلاح المشكلة: التحقق إذا كانت الرسالة مختلفة
                        if self.lastErrorMessage != errorMessage {
                            self.lastErrorMessage = errorMessage // حفظ الرسالة الحالية
                            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            completion(.failure(error))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    let errorMessage = "Unauthorized"
                    if self.lastErrorMessage != errorMessage {
                        self.lastErrorMessage = errorMessage
                        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    }
                }
                return
            }

            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    completion(.success(decodedResponse))
                } catch let decodingError {
                    completion(.failure(decodingError))
                }
            } else {
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected server response"])))
            }
        }.resume()
    }
}


















//old
//import Foundation
////import Network
//
//// Login Model
//struct LoginRequest: Codable {
//    let username: String
//    let password: String
//}
//
//struct LoginResponse: Codable {
//    let id: String
//    let state: Int
//    let message: String
//}
//
//// ErrorResponse Model for 401 Errors
//struct ErrorResponse: Codable {
//    let message: String
//}
//
//// API Service
//class ApiService {
//    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
//        guard let url = URL(string: "http://198.244.227.48:8082/auth/teachers/login") else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let loginData = LoginRequest(username: username, password: password)
//
//        do {
//            let requestBody = try JSONEncoder().encode(loginData)
//            request.httpBody = requestBody
//        } catch {
//            completion(.failure(error))
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response from server"])))
//                return
//            }
//
//            if httpResponse.statusCode == 401 {
//                if let data = data {
//                    do {
//                        let decodedError = try JSONDecoder().decode(ErrorResponse.self, from: data)
//                        let errorMessage = decodedError.message
//                        let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage])
//                        completion(.failure(error))
//                    } catch {
//                        completion(.failure(error))
//                    }
//                } else {
//                    completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
//                }
//                return
//            }
//
//            if httpResponse.statusCode == 200 {
//                guard let data = data else {
//                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
//                    return
//                }
//
//                do {
//                    let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
//                    completion(.success(decodedResponse))
//                } catch let decodingError {
//                    completion(.failure(decodingError))
//                }
//            } else {
//                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected server response"])))
//            }
//        }.resume()
//    }
//}
