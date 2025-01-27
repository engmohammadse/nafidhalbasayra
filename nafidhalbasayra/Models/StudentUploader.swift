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
    private var isSendingData = false // Flag لمنع التكرار على مستوى العملية

    init(database: StudentViewModel) {
        self.database = database
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("🌐 الإنترنت متوفر. سيتم رفع البيانات.")
                self?.sendPendingStudentData()
            } else {
                print("❌ لا يوجد اتصال بالإنترنت.")
            }
        }
    }

    func sendPendingStudentData() {
        // التأكد من عدم وجود عملية إرسال جارية
        guard !isSendingData else {
            print("⚠️ عملية إرسال بيانات جارية بالفعل.")
            return
        }

        // تعيين isSendingData لمنع التكرار
        isSendingData = true

        let fetchRequest: NSFetchRequest<StudentInfo> = StudentInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "state == 0 AND isSending == false")

        do {
            // جلب الطلاب غير المرسل بياناتهم باستخدام context
            let unsentStudents = try database.container.viewContext.fetch(fetchRequest)
            print("📤 عدد الطلاب غير المرسل بياناتهم: \(unsentStudents.count)")

            guard !unsentStudents.isEmpty else {
                print("⚠️ لا توجد بيانات غير مرسلة.")
                isSendingData = false
                return
            }

            for student in unsentStudents {
                student.isSending = true // تعيين الطالب كقيد الإرسال
                sendStudentData(student: student) { success, statusCode, errorMessage in
                    DispatchQueue.main.async {
                        student.isSending = false // إعادة تعيين حالة الإرسال عند انتهاء العملية

                        if success {
                            self.database.updateStudentState(entity: student, newState: 1) // تحديث الحالة
                            print("✅ تم تحديث حالة الطالب \(student.name ?? "بدون اسم") إلى مرسل.")
                        } else {
                            print("❌ فشل إرسال بيانات الطالب \(student.name ?? "بدون اسم"). رمز الخطأ: \(statusCode), الرسالة: \(errorMessage ?? "لا توجد رسالة")")
                        }

                        // تحديث Core Data بعد كل عملية
                        self.database.saveStudentData()
                    }
                }
            }
        } catch {
            print("❌ خطأ أثناء جلب البيانات: \(error.localizedDescription)")
        }

        // تعيين isSendingData إلى false بعد الانتهاء
        isSendingData = false
    }

    private func sendStudentData(student: StudentInfo, completion: @escaping (Bool, Int, String?) -> Void) {
        guard let url = URL(string: "http://198.244.227.48:8082/students/register") else {
            print("❌ رابط غير صالح.")
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
            "age": Int(student.age ?? "0") ?? 0,
            "phone_number": student.phoneNumber ?? "default value",
            "degree": student.level ?? "default value",
            "gender": student.gender ?? "ذكر",
            "size": student.size ?? "default value",
            "teacher_id": UserDefaults.standard.string(forKey: "teacherId") ?? "No ID"
        ]

        // تحويل البيانات إلى JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: studentData, options: [])
        } catch {
            print("❌ خطأ أثناء تحويل البيانات إلى JSON: \(error.localizedDescription)")
            completion(false, -1, error.localizedDescription)
            return
        }

        // إرسال الطلب باستخدام URLSession
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
                print("✅ تم إرسال بيانات الطالب \(student.name ?? "بدون اسم") بنجاح.")

                // معالجة الاستجابة واستخراج _id
                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let returnedId = jsonResponse["_id"] as? String {
                            DispatchQueue.main.async {
                                student.idFromApi = returnedId // تحديث idFromApi
                                self.database.saveStudentData() // حفظ التغييرات
                                print("✅ تم تحديث خاصية idFromApi للطالب \(student.name ?? "بدون اسم") بالقيمة: \(returnedId)")
                            }
                        }
                    } catch {
                        print("❌ خطأ أثناء معالجة الاستجابة: \(error.localizedDescription)")
                    }
                }
                completion(true, httpResponse.statusCode, nil)
            } else {
                let serverMessage = String(data: data ?? Data(), encoding: .utf8) ?? "لا توجد رسالة"
                print("❌ فشل إرسال بيانات الطالب. رمز الحالة: \(httpResponse.statusCode), الرسالة: \(serverMessage)")
                completion(false, httpResponse.statusCode, serverMessage)
            }
        }.resume()
    }
}














// تعمل مع حفظ ال ID
//import Foundation
//import Network
//import CoreData
//
//class StudentUploader {
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "InternetMonitor")
//    private var database: StudentViewModel
//    private var isSendingData = false  // Flag to prevent multiple simultaneous uploads
//
//    init(database: StudentViewModel) {
//        self.database = database
//        monitor.start(queue: queue)
//        monitor.pathUpdateHandler = { [weak self] path in
//            if path.status == .satisfied {
//                print("🌐 الإنترنت متوفر. سيتم رفع البيانات.")
//                self?.sendPendingStudentData()
//            } else {
//                print("❌ لا يوجد اتصال بالإنترنت.")
//            }
//        }
//    }
//
//    // دالة إرسال بيانات الطلاب غير المرسل بياناتهم
//    func sendPendingStudentData() {
//        // التحقق إذا كان هناك عملية إرسال جارية
//        guard !isSendingData else {
//            print("⚠️ عملية إرسال بيانات جارية بالفعل.")
//            return
//        }
//
//        // تعيين isSendingData إلى true لمنع التكرار
//        isSendingData = true
//
//        // جلب الطلاب الذين لم تُرسل بياناتهم بعد (حيث أن state = 0)
//        let unsentStudents = database.savedEntities.filter { $0.state == 0 }
//        print("📤 عدد الطلاب غير المرسل بياناتهم: \(unsentStudents.count)")
//
//        // إذا كانت هناك بيانات غير مرسلة، نقوم بإرسالها
//        guard !unsentStudents.isEmpty else {
//            print("⚠️ لا توجد بيانات غير مرسلة.")
//            isSendingData = false
//            return
//        }
//
//        // إرسال بيانات كل طالب
//        for student in unsentStudents {
//            sendStudentData(student: student) { success, statusCode, errorMessage in
//                if success {
//                    // إذا تم الإرسال بنجاح، نقوم بتحديث state إلى 1
//                    DispatchQueue.main.async {
//                        self.database.updateStudentState(entity: student, newState: 1)  // تحديث الحالة إلى مرسل
//                        self.database.saveStudentData() // حفظ التغييرات في CoreData
//                        print("✅ تم تحديث حالة الطالب \(student.name ?? "بدون اسم") إلى مرسل.")
//                    }
//                } else {
//                    // في حالة الفشل، نطبع رسالة الخطأ
//                    print("❌ فشل إرسال بيانات الطالب \(student.name ?? "بدون اسم"). رمز الخطأ: \(statusCode), الرسالة: \(errorMessage ?? "لا توجد رسالة")")
//                }
//            }
//        }
//
//        // تعيين isSendingData إلى false بعد اكتمال الإرسال
//        isSendingData = false
//    }
//
//    // دالة إرسال بيانات طالب واحد
//    private func sendStudentData(student: StudentInfo, completion: @escaping (Bool, Int, String?) -> Void) {
//        // التحقق من صحة عنوان URL
//        guard let url = URL(string: "http://198.244.227.48:8082/students/register") else {
//            print("❌ رابط غير صالح.")
//            completion(false, -1, "رابط غير صالح.")
//            return
//        }
//
//        // إعداد الطلب
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // إعداد بيانات الطالب
//        let studentData: [String: Any] = [
//            "name": student.name ?? "default value",
//            "age": Int(student.age ?? "0") ?? 0,
//            "phone_number": student.phoneNumber ?? "default value",
//            "degree": student.level ?? "default value",
//            "gender": student.gender ?? "ذكر",
//            "size": student.size ?? "default value",
//            "teacher_id": UserDefaults.standard.string(forKey: "teacherId") ?? "No ID"
//        ]
//
//        // تحويل البيانات إلى JSON
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: studentData, options: [])
//        } catch {
//            print("❌ خطأ أثناء تحويل البيانات إلى JSON: \(error.localizedDescription)")
//            completion(false, -1, error.localizedDescription)
//            return
//        }
//
//        // إرسال الطلب باستخدام URLSession
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ خطأ أثناء إرسال البيانات: \(error.localizedDescription)")
//                completion(false, -1, error.localizedDescription)
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                print("❌ استجابة غير صالحة.")
//                completion(false, -1, "استجابة غير صالحة.")
//                return
//            }
//
//            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
//                print("✅ تم إرسال بيانات الطالب \(student.name ?? "بدون اسم") بنجاح.")
//
//                // تحليل JSON لاستخراج id وتخزينه
//                if let data = data {
//                    do {
//                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                           let returnedId = jsonResponse["_id"] as? String {
//                            DispatchQueue.main.async {
//                                // تحديث خاصية idFromApi
//                                student.idFromApi = returnedId
//                                self.database.saveStudentData() // حفظ التغييرات في CoreData
//                                print("✅ تم تحديث خاصية idFromApi للطالب \(student.name ?? "بدون اسم") بالقيمة: \(returnedId)")
//                            }
//                        }
//                    } catch {
//                        print("❌ خطأ أثناء معالجة الاستجابة: \(error.localizedDescription)")
//                    }
//                }
//                completion(true, httpResponse.statusCode, nil)
//            } else {
//                let serverMessage = String(data: data ?? Data(), encoding: .utf8) ?? "لا توجد رسالة"
//                print("❌ فشل إرسال بيانات الطالب. رمز الحالة: \(httpResponse.statusCode), الرسالة: \(serverMessage)")
//                completion(false, httpResponse.statusCode, serverMessage)
//            }
//        }.resume()
//    }
//}
//
























// تعمل بدون id
//import Foundation
//import Network
//import CoreData
//
//class StudentUploader {
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "InternetMonitor")
//    private var database: StudentViewModel
//    private var isSendingData = false  // Flag to prevent multiple simultaneous uploads
//
//    init(database: StudentViewModel) {
//        self.database = database
//        monitor.start(queue: queue)
//        monitor.pathUpdateHandler = { [weak self] path in
//            if path.status == .satisfied {
//                print("🌐 الإنترنت متوفر. سيتم رفع البيانات.")
//                self?.sendPendingStudentData()
//            } else {
//                print("❌ لا يوجد اتصال بالإنترنت.")
//            }
//        }
//    }
//
//    // دالة إرسال بيانات الطلاب غير المرسل بياناتهم
//    func sendPendingStudentData() {
//        // التحقق إذا كان هناك عملية إرسال جارية
//        guard !isSendingData else {
//            print("⚠️ عملية إرسال بيانات جارية بالفعل.")
//            return
//        }
//
//        // تعيين isSendingData إلى true لمنع التكرار
//        isSendingData = true
//
//        // جلب الطلاب الذين لم تُرسل بياناتهم بعد (حيث أن state = 0)
//        let unsentStudents = database.savedEntities.filter { $0.state == 0 }
//        print("📤 عدد الطلاب غير المرسل بياناتهم: \(unsentStudents.count)")
//
//        // إذا كانت هناك بيانات غير مرسلة، نقوم بإرسالها
//        guard !unsentStudents.isEmpty else {
//            print("⚠️ لا توجد بيانات غير مرسلة.")
//            isSendingData = false
//            return
//        }
//
//        // إرسال بيانات كل طالب
//        for student in unsentStudents {
//            sendStudentData(student: student) { success, statusCode, errorMessage in
//                if success {
//                    // إذا تم الإرسال بنجاح، نقوم بتحديث state إلى 1
//                    DispatchQueue.main.async {
//                        self.database.updateStudentState(entity: student, newState: 1)  // تحديث الحالة إلى مرسل
//                        self.database.saveStudentData() // حفظ التغييرات في CoreData
//                        print("✅ تم تحديث حالة الطالب \(student.name ?? "بدون اسم") إلى مرسل.")
//                    }
//                } else {
//                    // في حالة الفشل، نطبع رسالة الخطأ
//                    print("❌ فشل إرسال بيانات الطالب \(student.name ?? "بدون اسم"). رمز الخطأ: \(statusCode), الرسالة: \(errorMessage ?? "لا توجد رسالة")")
//                }
//            }
//        }
//
//        // تعيين isSendingData إلى false بعد اكتمال الإرسال
//        isSendingData = false
//    }
//
//    // دالة إرسال بيانات طالب واحد
//    private func sendStudentData(student: StudentInfo, completion: @escaping (Bool, Int, String?) -> Void) {
//        // التحقق من صحة عنوان URL
//        guard let url = URL(string: "http://198.244.227.48:8082/students/register") else {
//            print("❌ رابط غير صالح.")
//            completion(false, -1, "رابط غير صالح.")
//            return
//        }
//
//        // إعداد الطلب
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // إعداد بيانات الطالب
//        let studentData: [String: Any] = [
//            "name": student.name ?? "default value",
//            "age": Int(student.age ?? "0") ?? 0,
//            "phone_number": student.phoneNumber ?? "default value",
//            "degree": student.level ?? "default value",
//            "gender": student.gender ?? "ذكر",
//            "size": student.size ?? "default value",
//            "teacher_id": UserDefaults.standard.string(forKey: "teacherId") ?? "No ID"
//        ]
//
//        // تحويل البيانات إلى JSON
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: studentData, options: [])
//        } catch {
//            print("❌ خطأ أثناء تحويل البيانات إلى JSON: \(error.localizedDescription)")
//            completion(false, -1, error.localizedDescription)
//            return
//        }
//
//        // إرسال الطلب باستخدام URLSession
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ خطأ أثناء إرسال البيانات: \(error.localizedDescription)")
//                completion(false, -1, error.localizedDescription)
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                print("❌ استجابة غير صالحة.")
//                completion(false, -1, "استجابة غير صالحة.")
//                return
//            }
//
//            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
//                print("✅ تم إرسال بيانات الطالب \(student.name ?? "بدون اسم") بنجاح.")
//                completion(true, httpResponse.statusCode, nil)
//            } else {
//                let serverMessage = String(data: data ?? Data(), encoding: .utf8) ?? "لا توجد رسالة"
//                print("❌ فشل إرسال بيانات الطالب. رمز الحالة: \(httpResponse.statusCode), الرسالة: \(serverMessage)")
//                completion(false, httpResponse.statusCode, serverMessage)
//            }
//        }.resume()
//    }
//}




























// تعمل
//import Foundation
//import Network
//import CoreData
//
//class StudentUploader {
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "InternetMonitor")
//    private var database: StudentViewModel
//
//    init(database: StudentViewModel) {
//        self.database = database
//        monitor.start(queue: queue)
//        monitor.pathUpdateHandler = { [weak self] path in
//            if path.status == .satisfied {
//                print("🌐 الإنترنت متوفر. سيتم رفع البيانات.")
//                self?.sendPendingStudentData()
//            } else {
//                print("❌ لا يوجد اتصال بالإنترنت.")
//            }
//        }
//    }
//
//    // دالة إرسال بيانات الطلاب غير المرسل بياناتهم
//    func sendPendingStudentData() {
//        // جلب الطلاب الذين لم تُرسل بياناتهم بعد (حيث أن state = 0)
//        let unsentStudents = database.savedEntities.filter { $0.state == 0 }
//        print("📤 عدد الطلاب غير المرسل بياناتهم: \(unsentStudents.count)")
//
//        // إذا كانت هناك بيانات غير مرسلة، نقوم بإرسالها
//        guard !unsentStudents.isEmpty else {
//            print("⚠️ لا توجد بيانات غير مرسلة.")
//            return
//        }
//
//        // إرسال بيانات كل طالب
//        for student in unsentStudents {
//            sendStudentData(student: student) { success, statusCode, errorMessage in
//                if success {
//                    // إذا تم الإرسال بنجاح، نقوم بتحديث state إلى 1
//                    DispatchQueue.main.async {
//                        self.database.updateStudentState(entity: student, newState: 1)  // تحديث الحالة إلى مرسل
//                        self.database.saveStudentData() // حفظ التغييرات في CoreData
//                        print("✅ تم تحديث حالة الطالب \(student.name ?? "بدون اسم") إلى مرسل.")
//                    }
//                } else {
//                    // في حالة الفشل، نطبع رسالة الخطأ
//                    print("❌ فشل إرسال بيانات الطالب \(student.name ?? "بدون اسم"). رمز الخطأ: \(statusCode), الرسالة: \(errorMessage ?? "لا توجد رسالة")")
//                }
//            }
//        }
//    }
//
//    // دالة إرسال بيانات طالب واحد
//    private func sendStudentData(student: StudentInfo, completion: @escaping (Bool, Int, String?) -> Void) {
//        // التحقق من صحة عنوان URL
//        guard let url = URL(string: "http://198.244.227.48:8082/students/register") else {
//            print("❌ رابط غير صالح.")
//            completion(false, -1, "رابط غير صالح.")
//            return
//        }
//
//        // إعداد الطلب
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // إعداد بيانات الطالب
//        let studentData: [String: Any] = [
//            "name": student.name ?? "default value",
//            "age": Int(student.age ?? "0") ?? 0,
//            "phone_number": student.phoneNumber ?? "default value",
//            "degree": student.level ?? "default value",
//            "gender": student.gender ?? "ذكر",
//            "size": student.size ?? "default value",
//            "teacher_id": UserDefaults.standard.string(forKey: "teacherId") ?? "No ID"
//        ]
//
//        // تحويل البيانات إلى JSON
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: studentData, options: [])
//        } catch {
//            print("❌ خطأ أثناء تحويل البيانات إلى JSON: \(error.localizedDescription)")
//            completion(false, -1, error.localizedDescription)
//            return
//        }
//
//        // إرسال الطلب باستخدام URLSession
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ خطأ أثناء إرسال البيانات: \(error.localizedDescription)")
//                completion(false, -1, error.localizedDescription)
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                print("❌ استجابة غير صالحة.")
//                completion(false, -1, "استجابة غير صالحة.")
//                return
//            }
//
//            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
//                print("✅ تم إرسال بيانات الطالب \(student.name ?? "بدون اسم") بنجاح.")
//                completion(true, httpResponse.statusCode, nil)
//            } else {
//                let serverMessage = String(data: data ?? Data(), encoding: .utf8) ?? "لا توجد رسالة"
//                print("❌ فشل إرسال بيانات الطالب. رمز الحالة: \(httpResponse.statusCode), الرسالة: \(serverMessage)")
//                completion(false, httpResponse.statusCode, serverMessage)
//            }
//        }.resume()
//    }
//}























//import Foundation
//import Network
//
//class StudentUploader {
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "InternetMonitor")
//    private var database: StudentViewModel
//
//    init(database: StudentViewModel) {
//        self.database = database
//        monitor.start(queue: queue)
//        monitor.pathUpdateHandler = { [weak self] path in
//            if path.status == .satisfied {
//                print("🌐 الإنترنت متوفر. سيتم رفع البيانات.")
//                self?.sendPendingStudentData()
//            } else {
//                print("❌ لا يوجد اتصال بالإنترنت.")
//            }
//        }
//    }
//
//    func sendPendingStudentData() {
//        let unsentStudents = database.savedEntities.filter { $0.state == 0 }
//        print("📤 عدد الطلاب غير المرسل بياناتهم: \(unsentStudents.count)")
//
//        guard !unsentStudents.isEmpty else {
//            print("⚠️ لا توجد بيانات غير مرسلة.")
//            return
//        }
//
//        for student in unsentStudents {
//            sendStudentData(student: student) { success, statusCode, errorMessage in
//                if success {
//                    DispatchQueue.main.async {
//                        self.database.updateStudentState(entity: student, newState: 1)
//                        print("✅ تم تحديث حالة الطالب \(student.name ?? "بدون اسم") إلى مرسل.")
//                    }
//                } else {
//                    print("❌ فشل إرسال بيانات الطالب \(student.name ?? "بدون اسم"). رمز الخطأ: \(statusCode), الرسالة: \(errorMessage ?? "لا توجد رسالة")")
//                }
//            }
//        }
//    }
//
//    private func sendStudentData(student: StudentInfo, completion: @escaping (Bool, Int, String?) -> Void) {
//        guard let url = URL(string: "http://198.244.227.48:8082/students/register") else {
//            print("❌ رابط غير صالح.")
//            completion(false, -1, "رابط غير صالح.")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let studentData: [String: Any] = [
//            "name": student.name ?? "default value",
//            "age": Int(student.age ?? "0") ?? 0,
//            "phone_number": student.phoneNumber ?? "default value",
//            "degree": student.level ?? "default value",
//            "gender": student.gender ?? "ذكر",
//            "size": student.size ?? "default value",
//            "teacher_id": UserDefaults.standard.string(forKey: "teacherId") ?? "No ID"
//            
//        ]
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: studentData, options: [])
//        } catch {
//            print("❌ خطأ أثناء تحويل البيانات إلى JSON: \(error.localizedDescription)")
//            completion(false, -1, error.localizedDescription)
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ خطأ أثناء إرسال البيانات: \(error.localizedDescription)")
//                completion(false, -1, error.localizedDescription)
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                print("❌ استجابة غير صالحة.")
//                completion(false, -1, "استجابة غير صالحة.")
//                return
//            }
//
//            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
//                print("✅ تم إرسال بيانات الطالب \(student.name ?? "بدون اسم") بنجاح.")
//                completion(true, httpResponse.statusCode, nil)
//            } else {
//                let serverMessage = String(data: data ?? Data(), encoding: .utf8) ?? "لا توجد رسالة"
//                print("❌ فشل إرسال بيانات الطالب. رمز الحالة: \(httpResponse.statusCode), الرسالة: \(serverMessage)")
//                completion(false, httpResponse.statusCode, serverMessage)
//            }
//        }.resume()
//    }
//}
