//
//  sendDataIfConnected.swift
//  nafidhalbasayra
//
//  Created by muhammad on 28/11/2024.
//

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




















import Foundation
import Network
import CoreData

class SyncTeacherDataPostApi {
    static let shared = SyncTeacherDataPostApi()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private var coreDataViewModel: CoreDataViewModel?

    private init() {}

    func startMonitoring(coreDataViewModel: CoreDataViewModel) {
        self.coreDataViewModel = coreDataViewModel
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.sendDataIfConnected()
                }
            }
        }
        monitor.start(queue: queue)
    }

    private func sendDataIfConnected() {
        guard let context = coreDataViewModel?.container.viewContext else { return }

        let fetchRequest: NSFetchRequest<TeacherInfo> = TeacherInfo.fetchRequest()

        do {
            let teachers = try context.fetch(fetchRequest)
            for teacher in teachers {
                sendTeacherData(teacher: teacher, context: context)
            }
        } catch {
            print("Failed to fetch teachers: \(error.localizedDescription)")
        }
    }

    private func sendTeacherData(teacher: TeacherInfo, context: NSManagedObjectContext) {
        
        //http://192.168.15.160:8082/
        //198.244.227.48:8082
        guard let url = URL(string: "http://192.168.15.160:8082/teachers/register-teacher") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Date Formatter
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]

        // Format birth_date or use an empty string if nil
        let formattedDate = teacher.birthDay != nil ? dateFormatter.string(from: teacher.birthDay!) : ""

        let body: [String: Any] = [
//            "teacher_id": teacher.teacherID ?? "",
//            "region_id": teacher.province ?? "",
//            "governorate_id": teacher.city ?? "",
            "teacher_id": "670a9990a8cd200cf7b0e8c7",
            "region_id": "672cc19964e07256213b02c8",
            "governorate_id": "672cc19964e07256213b02b2",
            
            "full_name": teacher.name ?? "tbrfb",
            "gender": "male",
//            "birth_date": formattedDate, // Use the formatted date here
            "birth_date": "3/10/2002",
            "phone_number": teacher.phonenumber ?? "rvrv",
            "work": teacher.currentWork ?? "vrvr",
            "mosque_name": teacher.mosquname ?? "vrvr",
            "degree": teacher.academiclevel ?? "vrvr",
            "previous_teacher": teacher.didyoutaught ?? false,
            "image_1": teacher.frontfaceidentity?.base64EncodedString() ?? "",
            "image_2": teacher.backfaceidentity?.base64EncodedString() ?? "",
            "image_3": teacher.profileimage?.base64EncodedString() ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch {
            print("Failed to serialize body: \(error.localizedDescription)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to send data: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Data sent successfully for teacher: \(teacher.name ?? "Unknown")")
                self.deleteTeacher(teacher, context: context)
            } else {
                print("Failed to send data. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            }
        }
        task.resume()
    }


    private func deleteTeacher(_ teacher: TeacherInfo, context: NSManagedObjectContext) {
        context.delete(teacher)

        do {
            try context.save()
            print("Teacher deleted successfully from Core Data.")
        } catch {
            print("Failed to delete teacher: \(error.localizedDescription)")
        }
    }
}
