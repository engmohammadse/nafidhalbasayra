//
//  cityGet.swift
//  nafidhalbasayra
//
//  Created by muhammad on 02/12/2024.
//

import SwiftUI
import Foundation
import Combine
import Network

struct Governorate: Codable, Identifiable, Equatable {
    let id: String
    let governorateName: String
    let governorateCode: Int
    let regionID: String?
    let totalStudentsNumber: Int?
    let totalTeachersNumber: Int?
    let registeredStudents: Int?
    let registeredTeachers: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case governorateName = "governorate_name"
        case governorateCode = "governorate_code"
        case regionID = "region_id"
        case totalStudentsNumber = "total_students_number"
        case totalTeachersNumber = "total_teachers_number"
        case registeredStudents = "registered_students"
        case registeredTeachers = "registered_teachers"
        case createdAt
        case updatedAt
    }
}

typealias Governorates = [Governorate]

// تعريف ErrorMessage لتكون متوافقة مع Identifiable
struct ErrorMessage: Identifiable {
    let id = UUID()  // تأكيد التوافق مع Identifiable
    let message: String
}

// DataFetcherCity لمعالجة البيانات
class DataFetcherCity: ObservableObject {
    @Published var governorates: [Governorate] = []
    @Published var showProgress = false
    @Published var errorMessage: ErrorMessage?  // استخدام ErrorMessage بدلاً من String
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue.global(qos: .background)
    
    // بدء مراقبة الاتصال
    func startMonitoring() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                   // print("اتصال الإنترنت متاح.")
                } else {
                    self.errorMessage = ErrorMessage(message: "لا يوجد اتصال بالإنترنت")
                    self.showProgress = false
                }
            }
        }
        monitor?.start(queue: queue)
    }
    
    // إيقاف مراقبة الاتصال
    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }
    
    // فحص البيانات وفصل العناصر غير الصالحة
    private func validateGovernorateData(_ data: Data) -> [Governorate] {
        var validGovernorates = [Governorate]()
        if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
            for json in jsonArray {
                if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
                    do {
                        let governorate = try JSONDecoder().decode(Governorate.self, from: jsonData)
                        if !governorate.governorateName.isEmpty && governorate.governorateCode != 0 {
                            validGovernorates.append(governorate)
                        }
                    } catch {
                        //print("Error decoding governorate: \(error)")
                    }
                }
            }
        }
        return validGovernorates
    }
    
    // جلب البيانات من الخادم
    func fetchData() {
        DispatchQueue.main.async {
            self.showProgress = true
            self.errorMessage = nil
        }
        
        // تحقق من عنوان URL
        guard let url = URL(string: "http://198.244.227.48:8082/governorates/get-with-regions") else {
            DispatchQueue.main.async {
                self.errorMessage = ErrorMessage(message: "عنوان URL غير صالح")
                self.showProgress = false
            }
            return
        }
        
        // إعداد الجلسة
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60
        sessionConfig.timeoutIntervalForResource = 90
        let session = URLSession(configuration: sessionConfig)
        
        // بدء الطلب
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "خطأ: \(error.localizedDescription)")
                    self.showProgress = false
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "خطأ في الخادم")
                    self.showProgress = false
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = ErrorMessage(message: "لا توجد بيانات")
                    self.showProgress = false
                }
                return
            }
            
            // فك التشفير ومعالجة البيانات
            let validGovernorates = self.validateGovernorateData(data)
            DispatchQueue.main.async {
                self.governorates = validGovernorates
                self.showProgress = false
            }
        }.resume()
    }
    
}




