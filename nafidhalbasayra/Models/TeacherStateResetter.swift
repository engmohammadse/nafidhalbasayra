//
//  TeacherStateResetter.swift
//  nafidhalbasayra
//
//  Created by muhammad on 14/04/2025.
//

import Foundation

class TeacherStateResetter {
    static func resetTeacherState(completion: @escaping (Bool, Int?, String?) -> Void) {
        
        let defaults = UserDefaults.standard
        guard let teacherId = defaults.string(forKey: "teacherId"), !teacherId.isEmpty else {
            completion(false, nil, "لا يوجد teacherId مخزن في UserDefaults.")
            return
        }

        let urlString = "http://198.244.227.48:8082/teachers/reset-state/\(teacherId)"
        guard let url = URL(string: urlString) else {
            completion(false, nil, "الرابط غير صالح.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, nil, "خطأ في الطلب: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, nil, "استجابة غير صالحة.")
                return
            }

            // تحقق من كود الاستجابة
            guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
                let statusCode = httpResponse.statusCode
                let serverMessage = String(data: data ?? Data(), encoding: .utf8) ?? "لا توجد رسالة"
                completion(false, statusCode, "فشل الطلب. كود الاستجابة: \(statusCode). الرسالة: \(serverMessage)")
                return
            }

            guard let data = data else {
                completion(false, httpResponse.statusCode, "لا توجد بيانات في الاستجابة.")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let teacher = json["teacher"] as? [String: Any],
                   let state = teacher["state"] as? Int {

                    // تخزين state في UserDefaults
                    defaults.set(state, forKey: "loginState")

                    completion(true, state, nil)
                } else {
                    completion(false, httpResponse.statusCode, "لم يتم العثور على البيانات المطلوبة.")
                }
            } catch {
                completion(false, httpResponse.statusCode, "فشل في تحليل الاستجابة: \(error.localizedDescription)")
            }
        }.resume()
    }
}
