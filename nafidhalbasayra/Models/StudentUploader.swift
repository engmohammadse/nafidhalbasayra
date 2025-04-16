//
//  StudentUploader.swift
//  nafidhalbasayra
//
//  Created by muhammad on 25/01/2025.
//


import Foundation
import Network
import CoreData

class StudentUploader {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetMonitor")
    private var database: StudentViewModel
    private let context = CoreDataManager.shared.viewContext
    private var isSendingData = false // Flag لمنع التكرار على مستوى العملية

    init(database: StudentViewModel) {
        self.database = database
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
              //  print("🌐 الإنترنت متوفر. سيتم رفع البيانات.")
                self?.sendPendingStudentData()
            } else {
               // print("❌ لا يوجد اتصال بالإنترنت.")
            }
        }
    }
    
    
    
    func sendPendingStudentData() {
        // التأكد من عدم وجود عملية إرسال جارية
        guard !isSendingData else {
            //print("⚠️ عملية إرسال بيانات جارية بالفعل.")
            return
        }

        // تعيين isSendingData لمنع التكرار
        isSendingData = true

        let fetchRequest: NSFetchRequest<StudentInfo> = StudentInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "state == 0 AND isSending == false")

        do {
            // جلب الطلاب غير المرسل بياناتهم باستخدام context
            let unsentStudents = try context.fetch(fetchRequest)
          //  print("📤 عدد الطلاب غير المرسل بياناتهم: \(unsentStudents.count)")

            guard !unsentStudents.isEmpty else {
               // print("⚠️ لا توجد بيانات غير مرسلة.")
                isSendingData = false
                return
            }

            // إرسال بيانات الطلاب واحدًا تلو الآخر باستخدام recursion أو looping مع completion handler
            sendNextStudent(unsentStudents: unsentStudents, index: 0)
        } catch {
          //  print("❌ خطأ أثناء جلب البيانات: \(error.localizedDescription)")
            isSendingData = false
        }
    }

    private func sendNextStudent(unsentStudents: [StudentInfo], index: Int) {
        guard index < unsentStudents.count else {
            // إذا تم إرسال جميع البيانات
          //  print("✅ تم إرسال بيانات جميع الطلاب.")
            isSendingData = false
            return
        }

        let student = unsentStudents[index]
        student.isSending = true // تعيين الطالب كقيد الإرسال
        sendStudentData(student: student) { success, statusCode, errorMessage in
            DispatchQueue.main.async {
                student.isSending = false // إعادة تعيين حالة الإرسال عند انتهاء العملية

                if success {
                    self.database.updateStudentState(entity: student, newState: 1) // تحديث الحالة
                  //  print("✅ تم تحديث حالة الطالب \(student.name ?? "بدون اسم") إلى مرسل.")
                } else {
                  //  print("❌ فشل إرسال بيانات الطالب \(student.name ?? "بدون اسم"). رمز الخطأ: \(statusCode), الرسالة: \(errorMessage ?? "لا توجد رسالة")")
                }

                // تحديث Core Data بعد كل عملية
                self.database.saveStudentData()

                // الانتقال إلى إرسال بيانات الطالب التالي بعد الانتهاء من إرسال بيانات الطالب الحالي
                self.sendNextStudent(unsentStudents: unsentStudents, index: index + 1)
            }
        }
    }

    



    private func sendStudentData(student: StudentInfo, completion: @escaping (Bool, Int, String?) -> Void) {
        guard let url = URL(string: "http://198.244.227.48:8082/students/register") else {
           // print("❌ رابط غير صالح.")
            completion(false, -1, "رابط غير صالح.")
            return
        }

        // إعداد الطلب
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // إعداد بيانات الطالب
        let studentData: [String: Any] = [
            "name": student.name ?? "default value",
            "age": Int(student.age ?? "00") ?? 000,
            "phone_number": student.phoneNumber ?? "default value",
            "degree": student.level ?? "default value",
            "gender": student.gender ?? "خطا باالاختيار",
            "size": student.size ?? "default value",
            "academic_level": student.academic_level ?? "خطا باالاختيار",
            "teacher_id": UserDefaults.standard.string(forKey: "teacherId") ?? "No ID"
        ]

        // تحويل البيانات إلى JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: studentData, options: [])
        } catch {
           // print("❌ خطأ أثناء تحويل البيانات إلى JSON: \(error.localizedDescription)")
            completion(false, -1, error.localizedDescription)
            return
        }

        // إرسال الطلب باستخدام URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
              //  print("❌ خطأ أثناء إرسال البيانات: \(error.localizedDescription)")
                completion(false, -1, error.localizedDescription)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
              //  print("❌ استجابة غير صالحة.")
                completion(false, -1, "استجابة غير صالحة.")
                return
            }

            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
              //  print("✅ تم إرسال بيانات الطالب \(student.name ?? "بدون اسم") بنجاح.")

                // معالجة الاستجابة واستخراج _id
                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let returnedId = jsonResponse["_id"] as? String {
                            DispatchQueue.main.async {
                                student.idFromApi = returnedId // تحديث idFromApi
                                self.database.saveStudentData() // حفظ التغييرات
                               // print("✅ تم تحديث خاصية idFromApi للطالب \(student.name ?? "بدون اسم") بالقيمة: \(returnedId)")
                            }
                        }
                    } catch {
                       // print("❌ خطأ أثناء معالجة الاستجابة: \(error.localizedDescription)")
                    }
                }
                completion(true, httpResponse.statusCode, nil)
            } else {
                let serverMessage = String(data: data ?? Data(), encoding: .utf8) ?? "لا توجد رسالة"
              //  print("❌ فشل إرسال بيانات الطالب. رمز الحالة: \(httpResponse.statusCode), الرسالة: \(serverMessage)")
                completion(false, httpResponse.statusCode, serverMessage)
            }
        }.resume()
    }
}










