//
//  sendAttendanceData.swift
//  nafidhalbasayra
//
//  Created by muhammad on 23/12/2024.
//







import Foundation
import Network
import CoreData

class AttendanceUploader {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetMonitor")
    private let database: AttendaceStatusViewModel // مرجع لقاعدة البيانات
  //  private var vmTeacher = TeacherDataFromApiViewModel() // تعريف محلي لـ TeacherDataFromApiViewModel


    init(database: AttendaceStatusViewModel) {
        self.database = database
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
               // print("🌐 Internet connection is available.")
                self?.sendPendingAttendanceData()
            } else {
               // print("❌ No internet connection.")
            }
        }
    }

     func sendPendingAttendanceData() {
        // جلب الكيانات التي حالتها state = 0
         
         
//        let unsentEntities = database.savedEntitiesAttendace.filter { $0.state == 0 }
         
         let unsentEntities = database.savedEntitiesAttendace.filter { $0.state == 0 }

//         for entity in unsentEntities {
//             print("📤 Sending data for entity ID: \(entity.id ?? "No ID")")
//             print("📸 Image Data: \(entity.image != nil ? "✅ Available" : "❌ Not Available")")
//         }

        
       // print("✅ Successfully fetched \(unsentEntities.count) unsent entities.")
        
        if unsentEntities.isEmpty {
          //  print("⚠️ No unsent data to send.")
            return
        }

        for entity in unsentEntities {
           // print("📤 Preparing to send data for entity ID: \(entity.id ?? "No ID")...")
            sendAttendanceData(entity: entity) { success, statusCode, errorMessage in
                if success {
                    DispatchQueue.main.async {
                        if let index = self.database.savedEntitiesAttendace.firstIndex(where: { $0.id == entity.id }) {
                            self.database.savedEntitiesAttendace[index].state = 1 // تحديث الحالة إلى 1
                            self.database.saveData() // حفظ التعديلات
                            //print("✅ Successfully updated state for entity ID: \(entity.id ?? "No ID") to sent.")
                        }
                    }
                } else {
                    _ = errorMessage ?? "Unknown error"
                   // print("❌ Failed to send data for entity ID: \(entity.id ?? "No ID"). HTTP Status: \(statusCode), Server Response: \(errorDescription)")
                }
            }
        }
    }
    
    
    
    
    private func sendAttendanceData(entity: AttendaceStatus, completion: @escaping (Bool, Int, String?) -> Void) {
        guard let url = URL(string: "http://198.244.227.48:8082/attendance/send-attendance") else {
           // print("❌ Invalid URL")
            completion(false, -1, "Invalid URL")
            return
        }

       // print("📤 Sending data for entity ID: \(entity.id ?? "No ID") to URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a" // ✅ ضبط التنسيق
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // ✅ التأكد من استخدام تنسيق 12 ساعة
        let formattedDateString = dateFormatter.string(from: entity.date ?? Date()) // ✅ تحويل التاريخ للصيغة المطلوبة

        let location = "{\"lng\":\(entity.longitude),\"lat\":\(entity.latitude)}"

        body.append(convertFormField(name: "teacher_id", value: UserDefaults.standard.string(forKey: "teacherId") ?? "670a9990a8cd200cf7b0e8c7", using: boundary))
        body.append(convertFormField(name: "students_number", value: entity.numberOfStudents ?? "0", using: boundary))
        body.append(convertFormField(name: "message", value: entity.notes ?? " لا توجد ملاحظات", using: boundary))
        body.append(convertFormField(name: "register_location", value: location, using: boundary))
        body.append(convertFormField(name: "register_date", value: formattedDateString, using: boundary))

        if let imageData = entity.image {
            body.append(convertFileField(name: "image", fileName: "image.jpg", mimeType: "image/jpeg", fileData: imageData, using: boundary))
        } else {
           // print("⚠️ No image provided for entity ID: \(entity.id ?? "No ID")")
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        //print("📤 Request body created for entity ID: \(entity.id ?? "No ID").")

        // ✅ **إرسال الطلب**
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                //print("❌ Error sending data for entity \(entity.id ?? "No ID"): \(error.localizedDescription)")
                completion(false, -1, error.localizedDescription)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
              //  print("❌ Invalid response for entity \(entity.id ?? "No ID")")
                completion(false, -1, "Invalid response")
                return
            }
            
            
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201, let data = data {
                do {
                    // ✅ **تحليل JSON واستخراج `_id`**
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let attendanceId = jsonResponse?["_id"] as? String {
                      //  print("✅ Data sent successfully! Attendance ID: \(attendanceId)")

                        // ✅ **تحديث `idFromApi` في Core Data**
                        DispatchQueue.main.async {
                            if let context = entity.managedObjectContext {
                                entity.idFromApi = attendanceId
                                do {
                                    try context.save() // ✅ **حفظ التعديلات في Core Data**
                                   // print("✅ Successfully updated `idFromApi` in Core Data for entity \(entity.id ?? "No ID").")
                                } catch {
                                   // print("❌ Error saving `idFromApi` to Core Data: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                } catch {
                  //  print("❌ Error parsing JSON response: \(error.localizedDescription)")
                }

                completion(true, httpResponse.statusCode, nil)
            }


            else {
                let serverMessage = String(data: data ?? Data(), encoding: .utf8) ?? "No server message"
              //  print("❌ Failed to send data. HTTP Status: \(httpResponse.statusCode), Server Response: \(serverMessage)")
                completion(false, httpResponse.statusCode, serverMessage)
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















