//
//  StudentUpdater.swift
//  nafidhalbasayra
//
//  Created by muhammad on 29/01/2025.
//

import Foundation

class StudentUpdater {
    static func updateStudent(student: StudentInfo, completion: @escaping (Bool, Int, String?) -> Void) {
        guard let studentId = student.idFromApi, !studentId.isEmpty else {
            print("❌ لا يمكن تحديث الطالب لأنه لا يحتوي على idFromApi صالح.")
            completion(false, -1, "المعرف غير صالح.")
            return
        }

        guard let url = URL(string: "http://198.244.227.48:8082/students/edit") else {
            print("❌ رابط API غير صالح.")
            completion(false, -1, "رابط API غير صالح.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // بيانات الطالب المحدثة
        let studentData: [String: Any] = [
            "id": studentId,  // إرسال معرف الطالب
            "name": student.name ?? "بدون اسم",
            "age": Int(student.age ?? "0") ?? 0, // تحويل العمر إلى Int
            "phone_number": student.phoneNumber ?? "بدون رقم",
            "degree": student.level ?? "غير محدد",
            "size": student.size ?? "غير محدد",
            "gender": student.gender ?? "خطا باالاختيار",
            "academic_level": student.academic_level ?? "خطا باالاختيار"
            
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: studentData, options: [])
        } catch {
            print("❌ خطأ أثناء تحويل البيانات إلى JSON: \(error.localizedDescription)")
            completion(false, -1, error.localizedDescription)
            return
        }

        // إرسال الطلب
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ خطأ أثناء إرسال البيانات: \(error.localizedDescription)")
                completion(false, -1, error.localizedDescription)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ استجابة غير صالحة.")
                completion(false, -1, "استجابة غير صالحة.")
                return
            }

            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                print("✅ تم تحديث بيانات الطالب بنجاح.")
                completion(true, httpResponse.statusCode, nil)
            } else {
                let serverMessage = String(data: data ?? Data(), encoding: .utf8) ?? "لا توجد رسالة"
                print("❌ فشل التعديل. رمز الحالة: \(httpResponse.statusCode), الرسالة: \(serverMessage)")
                completion(false, httpResponse.statusCode, serverMessage)
            }
        }.resume()
    }
}
