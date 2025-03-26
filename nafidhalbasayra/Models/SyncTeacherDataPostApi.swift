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



        // URL
//    http://192.168.15.160:8082/teachers/register-teacher
//    http://198.244.227.48:8082/teachers/register-teacher
        
        
        guard let url = URL(string: "http://198.244.227.48:8082/teachers/register-teacher") else {
           // print("❌ Invalid URL")
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
        
        // قراءة deviceToken من UserDefaults
        let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") ?? ""


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
            "type": String(1),
            "deviceToken":deviceToken
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
            var compressionQuality: CGFloat = 0.6
            var imageData = image.jpegData(compressionQuality: compressionQuality)
            
            // التحقق من حجم الصورة وضغطها حتى تصبح أقل من 900KB
            while let data = imageData, data.count > 900_000, compressionQuality > 0.3 {
                compressionQuality -= 0.1
                imageData = image.jpegData(compressionQuality: compressionQuality)
            }

            guard let finalImageData = imageData else { continue }

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(finalImageData)
            body.append("\r\n".data(using: .utf8)!)
        }



        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        // إرسال الطلب
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
          
           
            
            if error != nil {
               // print("❌ Failed to send data: \(error.localizedDescription)")
               
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
               // print("🟡 HTTP Status Code: \(httpResponse.statusCode)")
                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
//                    print("🟡 Response Body: \(responseBody)")
                }
                
                
                
                if let data = data {
                         // محاولة تحليل الـ response body واستخراج رسالة الخطأ
                         do {
                             // محاولة تحويل البيانات إلى JSON
                             if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                let message = jsonResponse["message"] as? String {
                                 // تخزين رسالة الخطأ في UserDefaults
                                 UserDefaults.standard.set(message, forKey: "serverErrorMessage")
                                 
                             
                               //  print("⚠️ Error Message from server: \(message)")
                             }
                         } catch {
                            // print("❌ Failed to parse response body: \(error.localizedDescription)")
                         }
                     }
                

                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
//                    print("✅ Data sent successfully for teacher: \(viewModel.name)")
               
                    let defaults = UserDefaults.standard
                    let loginState = 1
                    defaults.set(loginState, forKey: "loginState")
                    defaults.synchronize()
                    
                    defaults.set(viewModel.cityIdfromApi, forKey: "governorate_id")
                    
                
                    
                    // التحقق فورًا بعد التخزين
//                    let retrievedState = defaults.integer(forKey: "loginState")
//                    print("🔍 Retrieved loginState: \(retrievedState)")  // يجب أن يطبع 1

       
                    UserDefaults.standard.removeObject(forKey: "serverErrorMessage")
                   
                    
                } else {
                  //  print("❌ Failed to send data. Status code: \(httpResponse.statusCode)")
                    //UserDefaults.standard.set(error?.localizedDescription, forKey: "serverErrorMessage")
                   

                }
                
                
                
                
                DispatchQueue.main.async {
                       
                       if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                           
                           viewModel.isLoadingRP2 = false
                           viewModel.sendTeacherDataToBackEndState = 1
                           
                          //   **تنزيل الصورة الجديدة بعد نجاح الإرسال**
                           if let data = data,
                              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                              let imageUrl = json["image_1"] as? String {
                               
//                               let fullImageUrl = "http://198.244.227.48:8082\(imageUrl)"
//                               
//                               downloadAndSaveImage(imageUrl: fullImageUrl) { imageData in
//                                   if let imageData = imageData {
//                                       print("✅ تم تحميل الصورة بنجاح وحجمها: \(imageData.count) بايت")
//                                   } else {
//                                       print("❌ فشل تحميل الصورة")
//                                   }
//                               }
                           }

//                           //
//                         }
                       } else {
                           viewModel.sendTeacherDataToBackEndState = 2

                           viewModel.isLoadingRP2 = false
                           viewModel.showToastِErrorRP2 = true
                       }
                   }
                
                
            }
            
            
         
            
        }
        task.resume()
    }


}



        
        

