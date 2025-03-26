//
//  TokenCreateApi.swift
//  nafidhalbasayra
//
//  Created by muhammad on 23/03/2025.
//

import Foundation

class TokenCreateApi {
    static let shared = TokenCreateApi()

    private init() {}

    // تأكد من أن هذه الدالة async
    func createToken(teacherId: String, token: String, governorateId: String, type: Int) async {
        // URL
        guard let url = URL(string: "http://198.244.227.48:8082/token/create") else {
          //  print("❌ Invalid URL")
            return
        }
        
        // إنشاء الطلب
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // إنشاء البيانات التي سيتم إرسالها
        let parameters: [String: Any] = [
            "teacher_id": teacherId,
            "token": token,
            "governorate_id": governorateId,
            "type": type
        ]
        
        do {
            // تحويل البيانات إلى JSON
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
           // print("❌ Failed to convert parameters to JSON: \(error.localizedDescription)")
            return
        }

        // إرسال الطلب
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
               // print("🟡 HTTP Status Code: \(httpResponse.statusCode)")
                
                // هنا نقوم مباشرة بمعالجة الـ data لأنه لن يكون nil
                do {
                    // محاولة تحويل البيانات المستلمة إلى JSON
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // طباعة الاستجابة
                      //  print("🟡 Response Body: \(jsonResponse)")
                        
                        // إذا كانت الاستجابة تحتوي على رسالة معينة
                        if let message = jsonResponse["message"] as? String {
                          //  print("⚠️ Server Message: \(message)")
                        }
                    }
                } catch {
                  //  print("❌ Failed to parse response body: \(error.localizedDescription)")
                }
                
                // تحقق من حالة الاستجابة
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                   // print("✅ Data sent successfully")
                } else {
                 //   print("❌ Failed to send data. Status code: \(httpResponse.statusCode)")
                }
            }
        } catch {
           // print("❌ Failed to send data: \(error.localizedDescription)")
        }
    }
}
