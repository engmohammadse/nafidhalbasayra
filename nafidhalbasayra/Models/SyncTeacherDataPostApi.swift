//
//  sendDataIfConnected.swift
//  nafidhalbasayra
//
//  Created by muhammad on 28/11/2024.
//

//"teacher_id": "674da25d2b64e4f547d9ce58", // تخصيص إذا لزم الأمر
//"region_id": "674da25d2b64e4f547d9ccdd", // تخصيص إذا لزم الأمر
//"governorate_id": "674da25d2b64e4f547d9ccc7",

// work exclude image local
import UIKit

class SyncTeacherDataPostApi {
    static let shared = SyncTeacherDataPostApi()

    private init() {}
    
    func sendTeacherDataFromViewModel(viewModel: TeacherDataViewModel) {
     
        
        // التأكد من وجود الصور
              guard let profileImage = viewModel.profileimage,
                    let frontFaceImage = viewModel.frontfaceidentity,
                    let backFaceImage = viewModel.backfaceidentity else {
                 // print("❌ One or more required images are missing.")
                  return
              }

//              // التأكيد على أن الصور موجودة
//              print("Profile Image عند الإرسال: \(profileImage != nil ? "موجودة" : "غير موجودة")")
//              print("Front Face Image عند الإرسال: \(frontFaceImage != nil ? "موجودة" : "غير موجودة")")
//              print("Back Face Image عند الإرسال: \(backFaceImage != nil ? "موجودة" : "غير موجودة")")
//
//        

        // URL
//    http://192.168.15.160:8082/teachers/register-teacher
//    http://198.244.227.48:8082/teachers/register-teacher
        guard let url = URL(string: "http://198.244.227.48:8082/teachers/register-teacher") else {
            print("❌ Invalid URL")
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        
        let teacherId = UserDefaults.standard.string(forKey: "teacherId") ?? "No ID"
        
        let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd" // تحويل التاريخ إلى الصيغة المطلوبة
          let dateString = dateFormatter.string(from: viewModel.birthDay ?? Date())

        // إضافة الحقول النصية
        let parameters: [String: String] = [
            "teacher_id": teacherId, //"6745c9453e5fc4b217eef1ae",
            "region_id": viewModel.regionIdfromApi,
            "governorate_id": viewModel.cityIdfromApi,
            "full_name": viewModel.name,
            "birth_date": dateString, //"3/10/2002"
            "phone_number": viewModel.phonenumber,
            "work": viewModel.currentWork,
            "mosque_name": viewModel.mosquname,
            "degree": viewModel.academiclevel,
            "gender": viewModel.gender,
            //"previous_teacher": viewModel.didyoutaught == true ? "true" : "false"
        ]
        
        // إضافة `previous_teacher` كـ Boolean
        let previousTeacherValue = viewModel.didyoutaught! ? true : false
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"previous_teacher\"\r\n\r\n".data(using: .utf8)!)
           body.append("\(previousTeacherValue)\r\n".data(using: .utf8)!)

        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        let images = [
            ("image_1", profileImage, "profile-image.jpg"),
            ("image_2", frontFaceImage, "front-face-image.jpg"),
            ("image_3", backFaceImage, "back-face-image.jpg")
        ]

        for (name, image, fileName) in images {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }


        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        // إرسال الطلب
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
          
            if let error = error {
                print("❌ Failed to send data: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("🟡 HTTP Status Code: \(httpResponse.statusCode)")
                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                    print("🟡 Response Body: \(responseBody)")
                }

                if httpResponse.statusCode == 200 {
                    print("✅ Data sent successfully for teacher: \(viewModel.name)")
//                    DispatchQueue.main.async {
//                        viewModel.isLoadingRP2 = false
//                        viewModel.sendTeacherDataToBackEndState = 1 // أو أي حالة تريد تعيينها
//                    }

                   
                    
                } else {
                    print("❌ Failed to send data. Status code: \(httpResponse.statusCode)")
//                    DispatchQueue.main.async {
//                        viewModel.isLoadingRP2 = false
//                        viewModel.sendTeacherDataToBackEndState = 2 // أو أي حالة تريد تعيينها
//                    }



                }
                
                
                
                
                DispatchQueue.main.async {
                       viewModel.isLoadingRP2 = false
                       if httpResponse.statusCode == 200 {
                           viewModel.sendTeacherDataToBackEndState = 1
                           
                           //  **تنزيل الصورة الجديدة بعد نجاح الإرسال**
//                       if let data = data,
//                          let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                          let imageUrl = json["image_1"] as? String {
//                           
//                           let fullImageUrl = "http://198.244.227.48:8082\(imageUrl)"
//                           downloadAndSaveImage(imageUrl: fullImageUrl) {
//                               
//                           }
//                           //
//                         }
                       } else {
                           viewModel.sendTeacherDataToBackEndState = 2
                       }
                   }
                
                
            }
            
            
         
            
        }
        task.resume()
    }


}



        
        




// الان يعمل
//import UIKit
//
//class SyncTeacherDataPostApi {
//    static let shared = SyncTeacherDataPostApi()
//    
//
//    private init() {}
//    
//    func sendTeacherDataFromViewModel(viewModel: TeacherDataViewModel) {
//        
//        // تحقق من teacherId في UserDefaults وقم بطباعته
//                if let teacherId = UserDefaults.standard.string(forKey: "teacherId") {
//                    print("✅ teacherId is a string: \(teacherId)")
//                } else {
//                    print("❌ teacherId is not a string or doesn't exist.")
//                }
//        
//        
//        
//        
//        
//        // تحميل الصورة من الأصول
//        guard let sharedImage = UIImage(named: "login") else {
//            print("❌ Failed to load image 'login' from assets. Make sure the image name is correct.")
//            return
//        }
//
//        // التأكيد على أن الصورة تم تحميلها
//        print("Profile Image عند الإرسال: \(sharedImage != nil ? "موجودة" : "غير موجودة")")
//        print("Front Face Image عند الإرسال: \(sharedImage != nil ? "موجودة" : "غير موجودة")")
//        print("Back Face Image عند الإرسال: \(sharedImage != nil ? "موجودة" : "غير موجودة")")
//
//        // URL
////    http://192.168.15.160:8082/teachers/register-teacher
////    http://198.244.227.48:8082/teachers/register-teacher
//        guard let url = URL(string: "http://198.244.227.48:8082/teachers/register-teacher") else {
//            print("❌ Invalid URL")
//            return
//        }
//
//        let boundary = "Boundary-\(UUID().uuidString)"
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "accept")
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        var body = Data()
//        
//        
//        let teacherId = UserDefaults.standard.string(forKey: "teacherId") ?? "No ID"
//        
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" // تحويل التاريخ إلى الصيغة المطلوبة
//        let dateString = dateFormatter.string(from: viewModel.birthDay ?? Date())
//
//        // إضافة الحقول النصية
//        let parameters: [String: String] = [
//            
//           
//         
//            "teacher_id":  "6745c9453e5fc4b217eef1ae" , //"6745c9453e5fc4b217eef1b3"
//            "region_id": viewModel.regionIdfromApi,// // "672cc19964e07256213b02c8"
//            "governorate_id": viewModel.cityIdfromApi, // 672cc19964e07256213b02b2
//            "full_name": viewModel.name,
//            "birth_date": "3/10/2002",//dateString,
//            "phone_number": viewModel.phonenumber,
//            "work": viewModel.currentWork,
//            "mosque_name": viewModel.mosquname,
//            "degree": viewModel.academiclevel,
//            "gender": viewModel.gender ,
//           // "previous_teacher": viewModel.didyoutaught == true ? true : false
//
//
//
//        ]
//        
//        
//        // إضافة `previous_teacher` كـ Boolean
//             let previousTeacherValue = viewModel.didyoutaught
//             body.append("--\(boundary)\r\n".data(using: .utf8)!)
//             body.append("Content-Disposition: form-data; name=\"previous_teacher\"\r\n\r\n".data(using: .utf8)!)
//             body.append("\(previousTeacherValue)\r\n".data(using: .utf8)!)
//        
//        
//        // طباعة البيانات المرسلة
//              print("📤 Preparing to send the following data:")
//              for (key, value) in parameters {
//                  print(" - \(key): \(value)")
//                  body.append("--\(boundary)\r\n".data(using: .utf8)!)
//                  body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//                  body.append("\(value)\r\n".data(using: .utf8)!)
//              }
//        
//        
//      
//
//        
//        //
//
//        for (key, value) in parameters {
//            body.append("--\(boundary)\r\n".data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//            body.append("\(value)\r\n".data(using: .utf8)!)
//        }
//
//        // إضافة الصور (جميعها نفس الصورة)
//        let images = [
//            ("image_1", sharedImage, "login-image-1.png"),
//            ("image_2", sharedImage, "login-image-2.png"),
//            ("image_3", sharedImage, "login-image-3.png")
//        ]
//
//        for (name, image, fileName) in images {
//            guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }
//
//            body.append("--\(boundary)\r\n".data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
//            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//            body.append(imageData)
//            body.append("\r\n".data(using: .utf8)!)
//        }
//
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        request.httpBody = body
//
//        // إرسال الطلب
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ Failed to send data: \(error.localizedDescription)")
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                print("🟡 HTTP Status Code: \(httpResponse.statusCode)")
//                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
//                    print("🟡 Response Body: \(responseBody)")
//                }
//
//                if httpResponse.statusCode == 200 {
//                    print("✅ Data sent successfully for teacher: \(viewModel.name)")
//                } else {
//                    print("❌ Failed to send data. Status code: \(httpResponse.statusCode)")
//                }
//            }
//        }
//        task.resume()
//    }
//
//
//}














//import Foundation
//import Network
//import CoreData
//import Combine
//
//class SyncTeacherDataPostApi: ObservableObject {
//    static let shared = SyncTeacherDataPostApi()
//
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "NetworkMonitor")
//    private var timer: Timer?
//
//    private var coreDataViewModel: CoreDataViewModel?
//
//    @Published var isConnected = false
//
//    private init() {}
//
//    func startMonitoring(coreDataViewModel: CoreDataViewModel) {
//        self.coreDataViewModel = coreDataViewModel
//
//        // مراقبة حالة الشبكة
//        monitor.pathUpdateHandler = { path in
//            DispatchQueue.main.async {
//                self.isConnected = (path.status == .satisfied)
//                print("Network status: \(self.isConnected ? "Connected" : "Disconnected")")
//                
//                if self.isConnected {
//                    self.checkServerReachability { reachable in
//                        if reachable {
//                            print("Server is reachable. Preparing to send data...")
//                            self.sendDataIfConnected()
//                        } else {
//                            print("Server is not reachable. Please check server configuration or network restrictions.")
//                        }
//                    }
//                } else {
//                    print("No internet connection. Network path is unsatisfied.")
//                }
//            }
//        }
//        monitor.start(queue: queue)
//
//        // إعداد مؤقت لإرسال البيانات بشكل دوري
//        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
//            if self.isConnected {
//                self.checkServerReachability { reachable in
//                    if reachable {
//                        print("Timer triggered: Server is reachable. Sending data...")
//                        self.sendDataIfConnected()
//                    } else {
//                        print("Timer triggered: Server is not reachable.")
//                    }
//                }
//            } else {
//                print("Timer triggered: No internet connection.")
//            }
//        }
//    }
//
//    private func checkServerReachability(completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: "http://192.168.15.160:8082/teachers/register-teacher") else {
//            print("Invalid server URL.")
//            completion(false)
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "HEAD"
//        URLSession.shared.dataTask(with: request) { _, response, error in
//            if let error = error {
//                print("Failed to reach server: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                completion(true)
//            } else {
//                print("Server not reachable or returned unexpected status.")
//                completion(false)
//            }
//        }.resume()
//    }
//
//    private func sendDataIfConnected() {
//        guard let context = coreDataViewModel?.container.viewContext else {
//            print("Core Data context is nil.")
//            return
//        }
//
//        let fetchRequest: NSFetchRequest<TeacherInfo> = TeacherInfo.fetchRequest()
//
//        do {
//            let teachers = try context.fetch(fetchRequest)
//            print("Fetched teachers: \(teachers.count)")
//            for teacher in teachers {
//                print("Preparing to send data for teacher: \(teacher.name ?? "Unknown")")
//                sendTeacherData(teacher: teacher)
//            }
//        } catch {
//            print("Failed to fetch teachers: \(error.localizedDescription)")
//        }
//    }
//
//    private func sendTeacherData(teacher: TeacherInfo) {
//        guard let url = URL(string: "http://198.244.227.48:8082/teachers/register-teacher") else {
//            print("Invalid URL.")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        // إنشاء الحدود
//        let boundary = UUID().uuidString
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        // بناء الجسم
//        var body = Data()
//
//        // إضافة الحقول النصية
//        func appendTextField(name: String, value: String) {
//            body.append("--\(boundary)\r\n".data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
//            body.append("\(value)\r\n".data(using: .utf8)!)
//        }
//
//        appendTextField(name: "teacher_id", value: "674da25d2b64e4f547d9ce58")
//        appendTextField(name: "region_id", value: "674da25d2b64e4f547d9ccdd")
//        appendTextField(name: "governorate_id", value: "674da25d2b64e4f547d9ccc7")
//        appendTextField(name: "full_name", value: teacher.name ?? "Unknown Name")
//        appendTextField(name: "birth_date", value: "3/10/2002") // يمكن التعديل لتتوافق مع بياناتك
//        appendTextField(name: "phone_number", value: String(teacher.phonenumber))
//        appendTextField(name: "work", value: "no work")
//        appendTextField(name: "mosque_name", value: "no name")
//        appendTextField(name: "degree", value: "no degree")
//        appendTextField(name: "previous_teacher", value: teacher.didyoutaught ? "true" : "false")
//        appendTextField(name: "gender", value: "ذكر")
//
//        // إضافة الملفات
//        func appendFileField(name: String, fileName: String, mimeType: String, fileData: Data?) {
//            guard let fileData = fileData else { return }
//            body.append("--\(boundary)\r\n".data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
//            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
//            body.append(fileData)
//            body.append("\r\n".data(using: .utf8)!)
//        }
//
//        appendFileField(name: "image_1", fileName: "front_identity.jpg", mimeType: "image/jpeg", fileData: teacher.frontfaceidentity)
//        appendFileField(name: "image_2", fileName: "back_identity.jpg", mimeType: "image/jpeg", fileData: teacher.backfaceidentity)
//        appendFileField(name: "image_3", fileName: "profile_picture.jpg", mimeType: "image/jpeg", fileData: teacher.profileimage)
//
//        // إنهاء الجسم
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//
//        request.httpBody = body
//
//        // إرسال الطلب
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Failed to send data for teacher \(teacher.name ?? "Unknown"): \(error.localizedDescription)")
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                print("HTTP Status Code: \(httpResponse.statusCode)")
//                if httpResponse.statusCode == 200 {
//                    print("Data sent successfully for teacher: \(teacher.name ?? "Unknown")")
//                } else {
//                    print("Failed to send data for teacher \(teacher.name ?? "Unknown"). Status code: \(httpResponse.statusCode)")
//                }
//            }
//
//            if let data = data {
//                print("Response Data: \(String(data: data, encoding: .utf8) ?? "No data")")
//            }
//        }
//        task.resume()
//    }
//
//    func stopMonitoring() {
//        monitor.cancel()
//        timer?.invalidate()
//        print("Stopped monitoring network.")
//    }
//}
















//
//
//
//
//import Foundation
//import Network
//import CoreData
//
//class SyncTeacherDataPostApi {
//    static let shared = SyncTeacherDataPostApi()
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "NetworkMonitor")
//
//    private var coreDataViewModel: CoreDataViewModel?
//
//    private init() {}
//
//    func startMonitoring(coreDataViewModel: CoreDataViewModel) {
//        self.coreDataViewModel = coreDataViewModel
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                DispatchQueue.main.async {
//                    self.sendDataIfConnected()
//                }
//            }
//        }
//        monitor.start(queue: queue)
//    }
//
//    private func sendDataIfConnected() {
//        guard let context = coreDataViewModel?.container.viewContext else { return }
//
//        let fetchRequest: NSFetchRequest<TeacherInfo> = TeacherInfo.fetchRequest()
//
//        do {
//            let teachers = try context.fetch(fetchRequest)
//            for teacher in teachers {
//                sendTeacherData(teacher: teacher, context: context)
//            }
//        } catch {
//            print("Failed to fetch teachers: \(error.localizedDescription)")
//        }
//    }
//
//    private func sendTeacherData(teacher: TeacherInfo, context: NSManagedObjectContext) {
//        
//        //http://192.168.15.160:8082/
//        //198.244.227.48:8082
//        guard let url = URL(string: "http://198.244.227.48:8082/teachers/register-teacher") else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // Date Formatter
//        let dateFormatter = ISO8601DateFormatter()
//        dateFormatter.formatOptions = [.withFullDate]
//
//        // Format birth_date or use an empty string if nil
//        let formattedDate = teacher.birthDay != nil ? dateFormatter.string(from: teacher.birthDay!) : ""
//
//        let body: [String: Any] = [
////            "teacher_id": teacher.teacherID ?? "",
////            "region_id": teacher.province ?? "",
////            "governorate_id": teacher.city ?? "",
//            "teacher_id": "670a9990a8cd200cf7b0e8c7",
//            "region_id": "672cc19964e07256213b02c8",
//            "governorate_id": "672cc19964e07256213b02b2",
//            
//            "full_name": teacher.name ?? "tbrfb",
//            "gender": "male",
////            "birth_date": formattedDate, // Use the formatted date here
//            "birth_date": "3/10/2002",
//            "phone_number": teacher.phonenumber ?? "rvrv",
//            "work": teacher.currentWork ?? "vrvr",
//            "mosque_name": teacher.mosquname ?? "vrvr",
//            "degree": teacher.academiclevel ?? "vrvr",
//            "previous_teacher": teacher.didyoutaught ?? false,
//            "image_1": teacher.frontfaceidentity?.base64EncodedString() ?? "",
//            "image_2": teacher.backfaceidentity?.base64EncodedString() ?? "",
//            "image_3": teacher.profileimage?.base64EncodedString() ?? ""
//        ]
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
//        } catch {
//            print("Failed to serialize body: \(error.localizedDescription)")
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Failed to send data: \(error.localizedDescription)")
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                print("Data sent successfully for teacher: \(teacher.name ?? "Unknown")")
//                self.deleteTeacher(teacher, context: context)
//            } else {
//                print("Failed to send data. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
//            }
//        }
//        task.resume()
//    }
//
//
//    private func deleteTeacher(_ teacher: TeacherInfo, context: NSManagedObjectContext) {
//        context.delete(teacher)
//
//        do {
//            try context.save()
//            print("Teacher deleted successfully from Core Data.")
//        } catch {
//            print("Failed to delete teacher: \(error.localizedDescription)")
//        }
//    }
//}
