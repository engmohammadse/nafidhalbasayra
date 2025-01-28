//
//  StudentDeleter.swift
//  nafidhalbasayra
//
//  Created by muhammad on 28/01/2025.
//

import Foundation

class StudentDeleter {
    /// دالة حذف الطالب باستخدام `idFromApi`
    static func deleteStudent(withId idFromApi: String, completion: @escaping (Bool, Int, String?) -> Void) {
        // تكوين الرابط مع `idFromApi`
        guard let url = URL(string: "http://198.244.227.48:8082/students/delete/\(idFromApi)") else {
            print("❌ رابط غير صالح.")
            completion(false, -1, "رابط غير صالح.")
            return
        }

        // إعداد الطلب
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // إرسال الطلب باستخدام URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ خطأ أثناء طلب الحذف: \(error.localizedDescription)")
                completion(false, -1, error.localizedDescription)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ استجابة غير صالحة.")
                completion(false, -1, "استجابة غير صالحة.")
                return
            }

            if httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                print("✅ تم حذف الطالب بنجاح.")
                completion(true, httpResponse.statusCode, nil)
            } else {
                let serverMessage = String(data: data ?? Data(), encoding: .utf8) ?? "لا توجد رسالة"
                print("❌ فشل الحذف. رمز الحالة: \(httpResponse.statusCode), الرسالة: \(serverMessage)")
                completion(false, httpResponse.statusCode, serverMessage)
            }
        }.resume()
    }
}
