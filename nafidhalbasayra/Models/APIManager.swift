//
//  APIManager.swift
//  nafidhalbasayra
//
//  Created by muhammad on 03/03/2025.
//
import Foundation

class APIManager {
    static let shared = APIManager()

    // ✅ دالة فحص حالة القبول
    func checkAcceptanceStatus(completion: @escaping (Result<Int, Error>) -> Void) {
        guard let teacherId = UserDefaults.standard.string(forKey: "teacherId"),
              !teacherId.isEmpty else {
            completion(.failure(NSError(domain: "UserDefaults", code: 404, userInfo: [NSLocalizedDescriptionKey: "لم يتم العثور على معرف المعلم"])))
            return
        }

        let urlString = "http://198.244.227.48:8082/teachers/checkState/\(teacherId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL", code: 400, userInfo: [NSLocalizedDescriptionKey: "الرابط غير صالح"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let state = jsonResponse["state"] as? Int else {
                completion(.failure(NSError(domain: "Parsing", code: 500, userInfo: [NSLocalizedDescriptionKey: "فشل تحليل البيانات"])))
                return
            }

            // ✅ طباعة `state` في الكونسول لفحص حالته عند التصحيح
            print("📌 استجابة API - الحالة: \(state)")

            // ✅ حفظ سبب الرفض إذا كان `state == 3`
            if state == 3, let rejectionReason = jsonResponse["rejectionReason"] as? String {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(rejectionReason, forKey: "rejectionReason")
                    print("🚨 سبب الرفض المخزن: \(rejectionReason)")
                }
            }

            DispatchQueue.main.async {
                completion(.success(state))
            }
        }

        task.resume()
    }
}





//import Foundation
//
//class APIManager {
//    static let shared = APIManager()
//
//    // ✅ دالة فحص حالة القبول
//    func checkAcceptanceStatus(completion: @escaping (Result<Int, Error>) -> Void) {
//        guard let teacherId = UserDefaults.standard.string(forKey: "teacherId"),
//              !teacherId.isEmpty else {
//            completion(.failure(NSError(domain: "UserDefaults", code: 404, userInfo: [NSLocalizedDescriptionKey: "لم يتم العثور على معرف المعلم"])))
//            return
//        }
//
//        let urlString = "http://198.244.227.48:8082/teachers/checkState/\(teacherId)"
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NSError(domain: "URL", code: 400, userInfo: [NSLocalizedDescriptionKey: "الرابط غير صالح"])))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data,
//                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                  let state = jsonResponse["state"] as? Int else {
//                completion(.failure(NSError(domain: "Parsing", code: 500, userInfo: [NSLocalizedDescriptionKey: "فشل تحليل البيانات"])))
//                return
//            }
//
//            // ✅ حفظ سبب الرفض إذا كان `state == 3`
//            if state == 3, let rejectionReason = jsonResponse["rejectionReason"] as? String {
//                UserDefaults.standard.set(rejectionReason, forKey: "rejectionReason")
//                print("🚨 سبب الرفض المخزن: \(rejectionReason)")
//            }
//
//            completion(.success(state))
//        }
//
//        task.resume()
//    }
//}





//import Foundation
//
//class APIManager {
//    static let shared = APIManager()
//
//    // ✅ دالة فحص حالة القبول
//    func checkAcceptanceStatus(completion: @escaping (Result<Int, Error>) -> Void) {
//        guard let teacherId = UserDefaults.standard.string(forKey: "teacherId"),
//              !teacherId.isEmpty else {
//            completion(.failure(NSError(domain: "UserDefaults", code: 404, userInfo: [NSLocalizedDescriptionKey: "لم يتم العثور على معرف المعلم"])))
//            return
//        }
//
//        let urlString = "http://198.244.227.48:8082/teachers/checkState/\(teacherId)"
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NSError(domain: "URL", code: 400, userInfo: [NSLocalizedDescriptionKey: "الرابط غير صالح"])))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data,
//                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                  let state = jsonResponse["state"] as? Int else {
//                completion(.failure(NSError(domain: "Parsing", code: 500, userInfo: [NSLocalizedDescriptionKey: "فشل تحليل البيانات"])))
//                return
//            }
//
//            completion(.success(state))
//        }
//
//        task.resume()
//    }
//}
