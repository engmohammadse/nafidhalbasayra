//
//  InternetChecker.swift
//  nafidhalbasayra
//
//  Created by muhammad on 28/01/2025.
//


import Foundation
import Network

class InternetChecker {
    static func isInternetAvailable(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)

        monitor.pathUpdateHandler = { path in
            guard path.status == .satisfied else {
                DispatchQueue.main.async {
                    completion(false) // لا يوجد اتصال
                }
                monitor.cancel()
                return
            }

            // ✅ هناك اتصال بالشبكة، الآن تحقق عبر الإنترنت الحقيقي
            guard let url = URL(string: "https://www.google.com") else {
                DispatchQueue.main.async {
                    completion(false)
                }
                monitor.cancel()
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "HEAD" // ✅ استخدام HEAD بدلاً من GET لتوفير البيانات
            request.timeoutInterval = 5  // ⏳ تقليل المهلة الزمنية إلى 5 ثوانٍ فقط

            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                DispatchQueue.main.async {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        completion(true)  // ✅ الإنترنت متوفر
                    } else {
                        completion(false) // ❌ الإنترنت غير متوفر
                    }
                }
                monitor.cancel() // ⛔️ إيقاف المراقب بعد التحقق
            }

            task.resume()
        }

        monitor.start(queue: queue)
    }
}






//import Foundation
//import Network
//
//class InternetChecker {
//    static func isInternetAvailable(completion: @escaping (Bool) -> Void) {
//        let monitor = NWPathMonitor()
//        let queue = DispatchQueue.global(qos: .background)
//
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                // محاولة إرسال طلب HTTP للتحقق من اتصال الإنترنت الحقيقي
//                guard let url = URL(string: "https://www.google.com") else {
//                    completion(false)
//                    monitor.cancel()
//                    return
//                }
//
//                var request = URLRequest(url: url)
//                request.timeoutInterval = 5 // وقت انتهاء الطلب
//
//                URLSession.shared.dataTask(with: request) { _, response, error in
//                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                        completion(true) // الإنترنت متوفر بشكل حقيقي
//                    } else {
//                        completion(false) // الإنترنت غير متوفر
//                    }
//                    monitor.cancel() // إيقاف المراقب
//                }.resume()
//            } else {
//                completion(false) // الإنترنت غير متوفر
//                monitor.cancel() // إيقاف المراقب
//            }
//        }
//
//        monitor.start(queue: queue)
//    }
//}




//import SwiftUI
//
//struct ContentView: View {
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//
//    var body: some View {
//        VStack {
//            Button("تحقق من الإنترنت") {
//                InternetChecker.isInternetAvailable { isAvailable in
//                    DispatchQueue.main.async {
//                        if isAvailable {
//                            alertMessage = "✅ الإنترنت متوفر. يمكنك تنفيذ العملية."
//                        } else {
//                            alertMessage = "❌ يجب توفر الإنترنت لتنفيذ هذا الأمر."
//                        }
//                        showAlert = true
//                    }
//                }
//            }
//            .alert(isPresented: $showAlert) {
//                Alert(title: Text("حالة الإنترنت"), message: Text(alertMessage), dismissButton: .default(Text("حسنًا")))
//            }
//            .padding()
//        }
//    }
//}
