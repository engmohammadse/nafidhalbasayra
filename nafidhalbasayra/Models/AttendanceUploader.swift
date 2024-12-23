//
//  sendAttendanceData.swift
//  nafidhalbasayra
//
//  Created by muhammad on 23/12/2024.
//



import Foundation
import Network

struct AttendanceEntity: Identifiable {
    var id: String
    var latitude: Double?
    var longitude: Double?
    var numberOfStudents: Int?
    var image: Data?
    var notes: String?
    var date: String?
    var state: Int // 0 = not sent, 1 = sent
}
    



import Foundation
import Network

class AttendanceUploader {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetMonitor")
    private let database: AttendaceStatusViewModel // الربط مع قاعدة البيانات

    init(database: AttendaceStatusViewModel) {
        self.database = database
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("🌐 Internet connection is available.")
                self?.sendPendingAttendanceData()
            } else {
                print("❌ No internet connection.")
            }
        }
        print("✅ Uploader initialized and monitoring started.")
    }

    private func sendPendingAttendanceData() {
        let unsentEntities = database.savedEntities.filter { $0.state == 0 }
        
        print("📦 Total saved entities: \(database.savedEntities.count)")
        print("📦 Unsent entities: \(unsentEntities.count)")

        guard !unsentEntities.isEmpty else {
            print("⚠️ No unsent data to send.")
            return
        }

        for entity in unsentEntities {
            print("📤 Preparing to send data for entity ID: \(entity.id ?? "No ID")...")
            sendAttendanceData(entity: entity) { success, statusCode, errorMessage in
                if success {
                    DispatchQueue.main.async {
                        if let index = self.database.savedEntities.firstIndex(where: { $0.id == entity.id }) {
                            self.database.savedEntities[index].state = 1
                            self.database.saveData()
                            print("✅ Successfully updated state for entity ID: \(entity.id ?? "No ID") to sent.")
                        }
                    }
                } else {
                    print("❌ Failed to send data for entity ID: \(entity.id ?? "No ID"). Status code: \(statusCode), Error: \(errorMessage ?? "Unknown error")")
                }
            }
        }
    }

    private func sendAttendanceData(entity: AttendaceStatus, completion: @escaping (Bool, Int, String?) -> Void) {
        guard let url = URL(string: "http://198.244.227.48:8082/attendance/send-attendance") else {
            print("❌ Invalid URL")
            completion(false, -1, "Invalid URL")
            return
        }

        print("🌐 Sending data for entity ID: \(entity.id ?? "No ID") to URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // إعداد بيانات الطلب
        let numberOfStudents = entity.numberOfStudents ?? "0"
        let notes = entity.notes ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = dateFormatter.string(from: entity.date ?? Date())
        let location = "{\"lng\":\(entity.longitude),\"lat\":\(entity.latitude)}"

        var body = Data()
        body.append(convertFormField(name: "teacher_id", value: "12345", using: boundary)) // استبدل بـ ID المعلم الفعلي
        body.append(convertFormField(name: "students_number", value: numberOfStudents, using: boundary))
        body.append(convertFormField(name: "message", value: notes, using: boundary))
        body.append(convertFormField(name: "register_location", value: location, using: boundary))
        body.append(convertFormField(name: "register_date", value: dateString, using: boundary))
        if let imageData = entity.image {
            body.append(convertFileField(name: "image", fileName: "image.jpg", mimeType: "image/jpeg", fileData: imageData, using: boundary))
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        print("📤 Request body created: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "No Body")")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error sending data for entity \(entity.id ?? "No ID"): \(error.localizedDescription)")
                completion(false, -1, error.localizedDescription)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response for entity \(entity.id ?? "No ID")")
                completion(false, -1, "Invalid response")
                return
            }

            if httpResponse.statusCode == 200 {
                print("✅ Data sent successfully for entity ID: \(entity.id ?? "No ID") with status code: \(httpResponse.statusCode)")
                completion(true, httpResponse.statusCode, nil)
            } else {
                let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                print("❌ Failed to send data for entity ID: \(entity.id ?? "No ID"). Status code: \(httpResponse.statusCode), Error: \(errorMessage)")
                completion(false, httpResponse.statusCode, errorMessage)
            }
        }.resume()
    }

    private func convertFormField(name: String, value: String, using boundary: String) -> Data {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
        fieldString += "\(value)\r\n"
        return fieldString.data(using: .utf8)!
    }

    private func convertFileField(name: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n"
        fieldString += "Content-Type: \(mimeType)\r\n\r\n"
        var data = fieldString.data(using: .utf8)!
        data.append(fileData)
        data.append("\r\n".data(using: .utf8)!)
        return data
    }
}

















//import Foundation
//import Network
//
//struct AttendanceEntity: Identifiable {
//    var id: String
//    var latitude: Double?
//    var longitude: Double?
//    var numberOfStudents: Int?
//    var image: Data?
//    var notes: String?
//    var date: String?
//    var state: Int // 0 = not sent, 1 = sent
//}
//
//
//
//
//
//class AttendanceUploader {
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "InternetMonitor")
//    private let database: AttendaceStatusViewModel // قاعدة البيانات
//    
//    
//    
//    
//    
//    
//    
//    
//
//    init(database: AttendaceStatusViewModel) {
//        self.database = database
//        monitor.start(queue: queue)
//        monitor.pathUpdateHandler = { [weak self] path in
//            if path.status == .satisfied {
//                print("🌐 Internet connection is available.")
//                self?.sendPendingAttendanceData()
//            } else {
//                print("❌ No internet connection.")
//            }
//        }
//
//    }
//
//    private func sendPendingAttendanceData() {
//        // جلب الكيانات التي حالتها state = 0
//        let unsentEntities = database.savedEntities.filter { $0.state == 0 }
//        
//        print("📦 Total saved entities: \(database.savedEntities.count)") // طباعة عدد كل الكيانات
//        print("📦 Unsent entities: \(unsentEntities.count)") // طباعة عدد الكيانات غير المرسلة
//        
//        // طباعة جميع الكيانات المحفوظة للتأكد من البيانات
//        for entity in database.savedEntities {
//            print("""
//            Entity:
//            ID: \(entity.id ?? "No ID")
//            State: \(entity.state)
//            Latitude: \(entity.latitude)
//            Longitude: \(entity.longitude)
//            Notes: \(entity.notes ?? "No notes")
//            """)
//        }
//
//        if unsentEntities.isEmpty {
//            print("⚠️ No unsent data to send.")
//            return
//        }
//
//        for entity in unsentEntities {
//            print("📤 Preparing to send data for entity ID: \(entity.id ?? "No ID")...")
//            sendAttendanceData(entity: entity) { success, statusCode, errorMessage in
//                if success {
//                    DispatchQueue.main.async {
//                        if let index = self.database.savedEntities.firstIndex(where: { $0.id == entity.id }) {
//                            self.database.savedEntities[index].state = 1 // تحديث الحالة مباشرةً
//                            self.database.saveData() // حفظ البيانات
//                            print("✅ Successfully updated state for entity ID: \(entity.id ?? "No ID") to sent.")
//                        }
//                    }
//                } else {
//                    let errorDescription = errorMessage ?? "Unknown error"
//                    let entityID = entity.id ?? "No ID"
//                    print("❌ Failed to send data for entity ID: \(entityID). Status code: \(statusCode), Error: \(errorDescription)")
//                }
//            }
//        }
//    }
//
//    private func sendAttendanceData(entity: AttendaceStatus, completion: @escaping (Bool, Int, String?) -> Void) {
//        guard let url = URL(string: "http://198.244.227.48:8082/attendance/send-attendance") else {
//            print("❌ Invalid URL")
//            completion(false, -1, "Invalid URL")
//            return
//        }
//
//        print("🌐 Sending data for entity ID: \(entity.id ?? "No ID") to URL: \(url)") // طباعة قبل بدء الإرسال
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let boundary = "Boundary-\(UUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        // إعداد بيانات الطلب
//        let numberOfStudents = entity.numberOfStudents ?? "0"
//        let notes = entity.notes ?? ""
//        let dateString = DateFormatter.localizedString(from: entity.date ?? Date(), dateStyle: .medium, timeStyle: .short)
//        let location = "{\"lng\":\(entity.longitude),\"lat\":\(entity.latitude)}"
//
//        var body = Data()
//        body.append(convertFormField(name: "teacher_id", value: "12345", using: boundary)) // Replace with actual teacher ID
//        body.append(convertFormField(name: "students_number", value: numberOfStudents, using: boundary))
//        body.append(convertFormField(name: "message", value: notes, using: boundary))
//        body.append(convertFormField(name: "register_location", value: location, using: boundary))
//        body.append(convertFormField(name: "register_date", value: dateString, using: boundary))
//        if let imageData = entity.image {
//            body.append(convertFileField(name: "image", fileName: "image.jpg", mimeType: "image/jpeg", fileData: imageData, using: boundary))
//        }
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        request.httpBody = body
//
//        print("📤 Request body created: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "No Body")")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ Error sending data for entity \(entity.id ?? "No ID"): \(error.localizedDescription)")
//                completion(false, -1, error.localizedDescription)
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                print("❌ Invalid response for entity \(entity.id ?? "No ID")")
//                completion(false, -1, "Invalid response")
//                return
//            }
//
//            if httpResponse.statusCode == 200 {
//                print("✅ Data sent successfully for entity ID: \(entity.id ?? "No ID") with status code: \(httpResponse.statusCode)")
//                completion(true, httpResponse.statusCode, nil)
//            } else {
//                let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
//                print("❌ Failed to send data for entity ID: \(entity.id ?? "No ID"). Status code: \(httpResponse.statusCode), Error: \(errorMessage)")
//                completion(false, httpResponse.statusCode, errorMessage)
//            }
//        }.resume()
//    }
//
//    private func convertFormField(name: String, value: String, using boundary: String) -> Data {
//        var fieldString = "--\(boundary)\r\n"
//        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
//        fieldString += "\(value)\r\n"
//        return fieldString.data(using: .utf8)!
//    }
//
//    private func convertFileField(name: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
//        var fieldString = "--\(boundary)\r\n"
//        fieldString += "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n"
//        fieldString += "Content-Type: \(mimeType)\r\n\r\n"
//        var data = fieldString.data(using: .utf8)!
//        data.append(fileData)
//        data.append("\r\n".data(using: .utf8)!)
//        return data
//    }
//}
//
//







//class AttendanceUploader {
//    private let monitor = NWPathMonitor()
//    private let queue = DispatchQueue(label: "InternetMonitor")
//    private let database: AttendaceStatusViewModel
//
//    init(database: AttendaceStatusViewModel) {
//        self.database = database
//        monitor.start(queue: queue)
//        monitor.pathUpdateHandler = { [weak self] path in
//            if path.status == .satisfied {
//                print("Internet available. Starting to send attendance data...")
//                self?.sendPendingAttendanceData()
//            } else {
//                print("No internet connection.")
//            }
//        }
//    }
//
//    private func sendPendingAttendanceData() {
//        // جلب الكيانات التي حالتها state = 0
//        let unsentEntities = database.savedEntities.filter { $0.state == 0 }
//
//        if unsentEntities.isEmpty {
//            print("⚠️ No unsent data to send.")
//            return
//        }
//
//        for entity in unsentEntities {
//            print("📤 Preparing to send data for entity ID: \(entity.id ?? "No ID")...")
//            sendAttendanceData(entity: entity) { success, statusCode, errorMessage in
//                if success {
//                    DispatchQueue.main.async {
//                        if let index = self.database.savedEntities.firstIndex(where: { $0.id == entity.id }) {
//                            self.database.savedEntities[index].state = 1 // تحديث الحالة مباشرةً
//                            self.database.saveData() // حفظ البيانات
//                            print("✅ Successfully updated state for entity ID: \(entity.id ?? "No ID") to sent.")
//                        }
//                    }
//                } else {
//                    print("❌ Failed to send data for entity ID: \(entity.id ?? "No ID"). Status code: \(statusCode), Error: \(errorMessage ?? "Unknown error")")
//                }
//            }
//        }
//    }
//
//    private func sendAttendanceData(entity: AttendaceStatus, completion: @escaping (Bool, Int, String?) -> Void) {
//        guard let url = URL(string: "http://198.244.227.48:8082/attendance/send-attendance") else {
//            print("Invalid URL")
//            completion(false, -1, "Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let boundary = "Boundary-\(UUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        // إعداد بيانات الطلب
//        let numberOfStudents = entity.numberOfStudents ?? "0"
//        let notes = entity.notes ?? ""
//        let dateString = DateFormatter.localizedString(from: entity.date ?? Date(), dateStyle: .medium, timeStyle: .short)
//        let location = "{\"lng\":\(entity.longitude),\"lat\":\(entity.latitude)}"
//
//        var body = Data()
//        body.append(convertFormField(name: "teacher_id", value: "12345", using: boundary)) // Replace with actual teacher ID
//        body.append(convertFormField(name: "students_number", value: numberOfStudents, using: boundary))
//        body.append(convertFormField(name: "message", value: notes, using: boundary))
//        body.append(convertFormField(name: "register_location", value: location, using: boundary))
//        body.append(convertFormField(name: "register_date", value: dateString, using: boundary))
//        
//        if let imageData = entity.image {
//            body.append(convertFileField(name: "image", fileName: "image.jpg", mimeType: "image/jpeg", fileData: imageData, using: boundary))
//        }
//        
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        request.httpBody = body
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(false, -1, error.localizedDescription)
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(false, -1, "Invalid response from server")
//                return
//            }
//
//            if httpResponse.statusCode == 200 {
//                completion(true, httpResponse.statusCode, nil)
//            } else {
//                let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
//                completion(false, httpResponse.statusCode, errorMessage)
//            }
//        }.resume()
//    }
//
//    private func convertFormField(name: String, value: String, using boundary: String) -> Data {
//        var fieldString = "--\(boundary)\r\n"
//        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
//        fieldString += "\(value)\r\n"
//        return fieldString.data(using: .utf8)!
//    }
//
//    private func convertFileField(name: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
//        var fieldString = "--\(boundary)\r\n"
//        fieldString += "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n"
//        fieldString += "Content-Type: \(mimeType)\r\n\r\n"
//        var data = fieldString.data(using: .utf8)!
//        data.append(fileData)
//        data.append("\r\n".data(using: .utf8)!)
//        return data
//    }
//}
