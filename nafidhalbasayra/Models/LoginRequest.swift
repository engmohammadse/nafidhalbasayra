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
    private var lastErrorMessage: String?

    // دالة لتسجيل الدخول
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        // إعادة تعيين الخطأ السابق عند بداية محاولة جديدة
        lastErrorMessage = nil

        guard let url = URL(string: "http://198.244.227.48:8082/auth/teachers/login") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL غير صالح"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 50 // تحديد وقت الانتظار للاستجابة

        let loginData = LoginRequest(username: username, password: password)

        do {
            let requestBody = try JSONEncoder().encode(loginData)
            request.httpBody = requestBody
        } catch {
            completion(.failure(error))
            return
        }

        // send another one if the request.timeoutInterval = 50 was finish
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as NSError? {
                if error.code == NSURLErrorTimedOut {
                    // إعادة إرسال الطلب مرة أخرى إذا انتهت المهلة
                    self.login(username: username, password: password, completion: completion)
                    return
                }
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "لا يوجد استجابة من الخادم"])))
                return
            }

            switch httpResponse.statusCode {
            case 401:
                self.handleUnauthorizedError(data: data, completion: completion)
            case 200:
                self.handleSuccessfulLoginResponse(data: data, completion: completion)
            default:
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "استجابة غير متوقعة من الخادم"])))
            }
        }.resume()

   
    }

    // دالة معالجة الأخطاء من النوع 401
    private func handleUnauthorizedError(data: Data?, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        if let data = data {
            do {
                let decodedError = try JSONDecoder().decode(ErrorResponse.self, from: data)
                let errorMessage = decodedError.message

                // التحقق من الرسالة إذا كانت مختلفة
                if self.lastErrorMessage != errorMessage {
                    self.lastErrorMessage = errorMessage
                    let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        } else {
            let errorMessage = "غير مخول"
            if self.lastErrorMessage != errorMessage {
                self.lastErrorMessage = errorMessage
                completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }
    }

    // دالة لمعالجة الاستجابة الناجحة
    private func handleSuccessfulLoginResponse(data: Data?, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let data = data else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "لا توجد بيانات تم إرجاعها"])))
            return
        }

        do {
            let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            completion(.success(decodedResponse))
        } catch let decodingError {
            completion(.failure(decodingError))
        }
    }
}

















//
//import Foundation
//import Network
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
//    // إصلاح المشكلة: إضافة متغير لحفظ حالة الخطأ
//    private var lastErrorMessage: String?
//
//    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
//        // إعادة تعيين الخطأ السابق عند بداية محاولة جديدة
//        lastErrorMessage = nil
//
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
//
//                        // إصلاح المشكلة: التحقق إذا كانت الرسالة مختلفة
//                        if self.lastErrorMessage != errorMessage {
//                            self.lastErrorMessage = errorMessage // حفظ الرسالة الحالية
//                            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage])
//                            completion(.failure(error))
//                        }
//                    } catch {
//                        completion(.failure(error))
//                    }
//                } else {
//                    let errorMessage = "Unauthorized"
//                    if self.lastErrorMessage != errorMessage {
//                        self.lastErrorMessage = errorMessage
//                        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
//                    }
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
