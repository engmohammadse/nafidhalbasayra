//
//  cityGet.swift
//  nafidhalbasayra
//
//  Created by muhammad on 02/12/2024.
//



import SwiftUI
import Combine

struct Governorate: Codable, Identifiable, Equatable {
    let id: String
    let governorateName: String
    let governorateCode: Int
    let regionID: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case governorateName = "governorate_name"
        case governorateCode = "governorate_code"
        case regionID = "region_id"
    }
}


import Network

class DataFetcher: ObservableObject {
    @Published var governorates: [Governorate] = []
    @Published var showProgress = false
    @Published var errorMessage: String?
    private var internetTimer: Timer?
    private var fetchRequested = false
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue.global(qos: .background)

    func startMonitoring() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    if self.fetchRequested {
                        self.performDataFetch()
                    }
                } else {
                    self.errorMessage = "لا يوجد اتصال بالإنترنت"
                    self.showProgress = false
                }
            }
        }
        monitor?.start(queue: queue)
    }

    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }

    func fetchData() {
        fetchRequested = true
        DispatchQueue.main.async {
            self.showProgress = true
            self.errorMessage = nil
        }

        if monitor == nil {
            startMonitoring()
        }

        performDataFetch()
    }

    private func performDataFetch() {
        guard let url = URL(string: "http://198.244.227.48:8082/governorates/get-with-regions") else {
            DispatchQueue.main.async {
                self.errorMessage = "عنوان URL غير صالح"
                self.showProgress = false
            }
            return
        }

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30
        sessionConfig.timeoutIntervalForResource = 60
        let session = URLSession(configuration: sessionConfig)

        session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "خطأ: \(error.localizedDescription)"
                    self.showProgress = false
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.errorMessage = "خطأ في الخادم"
                    self.showProgress = false
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "لا توجد بيانات"
                    self.showProgress = false
                }
                return
            }

            do {
                let decodedData = try JSONDecoder().decode([Governorate].self, from: data)
                DispatchQueue.main.async {
                    self.governorates = decodedData
                    self.showProgress = false
                    self.fetchRequested = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "خطأ في فك التشفير: \(error.localizedDescription)"
                    self.showProgress = false
                }
            }
        }.resume()
    }
}



















//import SwiftUI
//import Combine
//
//struct Governorate: Codable, Identifiable, Equatable {
//    let id: String
//    let governorateName: String
//    let governorateCode: Int
//    let regionID: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case governorateName = "governorate_name"
//        case governorateCode = "governorate_code"
//        case regionID = "region_id"
//    }
//}
//
//class DataFetcher: ObservableObject {
//    @Published var governorates: [Governorate] = []
//    @Published var showProgress = false
//    @Published var errorMessage: String?
//    private var internetTimer: Timer?
//    private var fetchRequested = false // حالة مراقبة طلب الجلب
//
//    func checkInternetConnection(completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: "https://www.google.com") else {
//            completion(false)
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "HEAD"
//        URLSession.shared.dataTask(with: request) { (_, response, _) in
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }.resume()
//    }
//
//    func fetchData() {
//        fetchRequested = true
//        DispatchQueue.main.async {
//            self.showProgress = true
//            self.errorMessage = nil
//        }
//
//        checkInternetConnection { isConnected in
//            DispatchQueue.main.async {
//                if isConnected {
//                    self.performDataFetch()
//                } else {
//                    self.errorMessage = "تحقق من اتصالك بالإنترنت"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//            }
//        }
//    }
//
//    private func performDataFetch() {
//        guard let url = URL(string: "http://198.244.227.48:8082/governorates/get-with-regions") else {
//            DispatchQueue.main.async {
//                self.errorMessage = "عنوان URL غير صالح"
//                self.showProgress = false
//            }
//            return
//        }
//
//        let sessionConfig = URLSessionConfiguration.default
//        sessionConfig.timeoutIntervalForRequest = 30
//        sessionConfig.timeoutIntervalForResource = 60
//        let session = URLSession(configuration: sessionConfig)
//
//        session.dataTask(with: url) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ: \(error.localizedDescription)"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ في الخادم"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//                return
//            }
//
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "لا توجد بيانات"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//                return
//            }
//
//            do {
//                let decodedData = try JSONDecoder().decode([Governorate].self, from: data)
//                DispatchQueue.main.async {
//                    self.governorates = decodedData
//                    self.showProgress = false
//                    self.fetchRequested = false // إعادة ضبط حالة طلب الجلب
//                    self.stopInternetCheck()
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ في فك التشفير: \(error.localizedDescription)"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//            }
//        }.resume()
//    }
//
//    private func scheduleInternetCheck() {
//        internetTimer?.invalidate()
//        internetTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
//            self.checkInternetConnection { isConnected in
//                if isConnected && self.fetchRequested {
//                    self.performDataFetch() // استعادة جلب البيانات بعد عودة الاتصال
//                }
//            }
//        }
//    }
//
//    private func stopInternetCheck() {
//        internetTimer?.invalidate()
//        internetTimer = nil
//    }
//}















//import SwiftUI
//import Combine
//
//struct Governorate: Codable, Identifiable, Equatable { // إضافة Equatable
//    let id: String
//    let governorateName: String
//    let governorateCode: Int
//    let regionID: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case governorateName = "governorate_name"
//        case governorateCode = "governorate_code"
//        case regionID = "region_id"
//    }
//
//    static func == (lhs: Governorate, rhs: Governorate) -> Bool {
//        return lhs.id == rhs.id
//    }
//}
//
//
//
//class DataFetcher: ObservableObject {
//    @Published var governorates: [Governorate] = []
//    @Published var showProgress = false
//    @Published var errorMessage: String?
//    private var internetTimer: Timer?
//    private var dataFetched = false // حالة جلب البيانات
//    
//    private var cancellables = Set<AnyCancellable>()
//
//    func checkInternetConnection(completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: "https://www.google.com") else {
//            completion(false)
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "HEAD"
//        URLSession.shared.dataTask(with: request) { (_, response, _) in
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }.resume()
//    }
//
//    func fetchData() {
//        DispatchQueue.main.async {
//            self.showProgress = true
//            self.errorMessage = nil
//        }
//
//        checkInternetConnection { isConnected in
//            DispatchQueue.main.async {
//                if isConnected {
//                    self.performDataFetch()
//                } else {
//                    self.errorMessage = "تحقق من اتصالك بالإنترنت"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//            }
//        }
//    }
//
//    private func performDataFetch() {
//        guard let url = URL(string: "http://198.244.227.48:8082/governorates/get-with-regions") else {
//            DispatchQueue.main.async {
//                self.errorMessage = "عنوان URL غير صالح"
//                self.showProgress = false
//            }
//            return
//        }
//
//        let sessionConfig = URLSessionConfiguration.default
//        sessionConfig.timeoutIntervalForRequest = 30
//        sessionConfig.timeoutIntervalForResource = 60
//        let session = URLSession(configuration: sessionConfig)
//
//        session.dataTask(with: url) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ: \(error.localizedDescription)"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ في الخادم"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//                return
//            }
//
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "لا توجد بيانات"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//                return
//            }
//
//            do {
//                let decodedData = try JSONDecoder().decode([Governorate].self, from: data)
//                DispatchQueue.main.async {
//                    self.governorates = decodedData
//                    self.showProgress = false
//                    self.dataFetched = true // تعيين حالة جلب البيانات إلى true
//                    self.stopInternetCheck() // إيقاف التحقق من الإنترنت
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ في فك التشفير: \(error.localizedDescription)"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//            }
//        }.resume()
//    }
//
//    private func scheduleInternetCheck() {
//        internetTimer?.invalidate()
//        internetTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
//            if !self.dataFetched { // التحقق من حالة جلب البيانات قبل محاولة الجلب مرة أخرى
//                self.checkInternetConnection { isConnected in
//                    if isConnected {
//                        self.fetchData()
//                    }
//                }
//            } else {
//                self.stopInternetCheck() // إيقاف التحقق من الإنترنت إذا كانت البيانات قد تم جلبها بالفعل
//            }
//        }
//    }
//
//    private func stopInternetCheck() {
//        internetTimer?.invalidate()
//        internetTimer = nil
//    }
//}



















// work - re ritw











//import SwiftUI
//import Combine
//
//struct Governorate: Codable, Identifiable {
//    let id: String
//    let governorateName: String
//    let governorateCode: Int
//    let regionID: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case governorateName = "governorate_name"
//        case governorateCode = "governorate_code"
//        case regionID = "region_id"
//    }
//}
//
//class DataFetcher: ObservableObject {
//    @Published var governorates: [Governorate] = []
//    @Published var showProgress = false
//    @Published var errorMessage: String?
//    
//    private var internetTimer: Timer?
//
//    func checkInternetConnection(completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: "https://www.google.com") else {
//            completion(false)
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "HEAD"
//        URLSession.shared.dataTask(with: request) { (_, response, _) in
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }.resume()
//    }
//
//    func fetchData() {
//        DispatchQueue.main.async {
//            self.showProgress = true
//            self.errorMessage = nil
//        }
//
//        checkInternetConnection { isConnected in
//            DispatchQueue.main.async {
//                if isConnected {
//                    self.performDataFetch()
//                } else {
//                    self.errorMessage = "تحقق من اتصالك بالإنترنت"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//            }
//        }
//    }
//
//    private func performDataFetch() {
//        guard let url = URL(string: "http://198.244.227.48:8082/governorates/get-with-regions") else {
//            DispatchQueue.main.async {
//                self.errorMessage = "عنوان URL غير صالح"
//                self.showProgress = false
//            }
//            return
//        }
//
//        let sessionConfig = URLSessionConfiguration.default
//        sessionConfig.timeoutIntervalForRequest = 30
//        sessionConfig.timeoutIntervalForResource = 60
//        let session = URLSession(configuration: sessionConfig)
//
//        session.dataTask(with: url) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ: \(error.localizedDescription)"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ في الخادم"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//                return
//            }
//
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "لا توجد بيانات"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//                return
//            }
//
//            do {
//                let decodedData = try JSONDecoder().decode([Governorate].self, from: data)
//                DispatchQueue.main.async {
//                    self.governorates = decodedData
//                    self.showProgress = false
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ في فك التشفير: \(error.localizedDescription)"
//                    self.showProgress = false
//                    self.scheduleInternetCheck()
//                }
//            }
//        }.resume()
//    }
//    
//    private func scheduleInternetCheck() {
//        internetTimer?.invalidate()
//        internetTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
//            self.checkInternetConnection { isConnected in
//                if isConnected {
//                    self.fetchData()
//                }
//            }
//        }
//    }
//
//    private func stopInternetCheck() {
//        internetTimer?.invalidate()
//        internetTimer = nil
//    }
//}
























//import SwiftUI
//import Combine
//
//struct Governorate: Codable, Identifiable {
//    let id: String
//    let governorateName: String
//    let governorateCode: Int
//    let regionID: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case governorateName = "governorate_name"
//        case governorateCode = "governorate_code"
//        case regionID = "region_id"
//    }
//}
//
//class DataFetcher: ObservableObject {
//    @Published var governorates: [Governorate] = []
//    @Published var showProgress = true
//    @Published var errorMessage: String?
//    
//    private var internetTimer: Timer?
//    private let dispatchGroup = DispatchGroup()
//
//    func checkInternetConnection(completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: "https://www.google.com") else {
//            completion(false)
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "HEAD"
//        URLSession.shared.dataTask(with: request) { (_, response, _) in
//            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }.resume()
//    }
//
//    func fetchData() {
//        showProgress = true
//        checkInternetConnection { isConnected in
//            DispatchQueue.main.async {
//                if isConnected {
//                    self.performDataFetch()
//                } else {
//                    self.errorMessage = "تحقق من اتصالك بالإنترنت"
//                    self.showProgress = true
//                    self.scheduleInternetCheck()
//                }
//            }
//        }
//    }
//
//    private func performDataFetch() {
//        dispatchGroup.enter()
//        
//        guard let url = URL(string: "http://198.244.227.48:8082/governorates/get-with-regions") else {
//            DispatchQueue.main.async {
//                self.errorMessage = "عنوان URL غير صالح"
//                self.showProgress = true
//                self.dispatchGroup.leave()
//            }
//            return
//        }
//        
//        let sessionConfig = URLSessionConfiguration.default
//        sessionConfig.timeoutIntervalForRequest = 30
//        sessionConfig.timeoutIntervalForResource = 60
//        let session = URLSession(configuration: sessionConfig)
//
//        session.dataTask(with: url) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ: \(error.localizedDescription)"
//                    self.showProgress = true
//                    self.scheduleInternetCheck()
//                }
//                self.dispatchGroup.leave()
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ في الخادم"
//                    self.showProgress = true
//                    self.scheduleInternetCheck()
//                }
//                self.dispatchGroup.leave()
//                return
//            }
//
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "لا توجد بيانات"
//                    self.showProgress = true
//                    self.scheduleInternetCheck()
//                }
//                self.dispatchGroup.leave()
//                return
//            }
//
//            do {
//                let decodedData = try JSONDecoder().decode([Governorate].self, from: data)
//                DispatchQueue.main.async {
//                    self.governorates = decodedData
//                    self.showProgress = false
//                    self.stopInternetCheck()
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ في فك التشفير: \(error.localizedDescription)"
//                    self.showProgress = true
//                    self.scheduleInternetCheck()
//                }
//            }
//            self.dispatchGroup.leave()
//        }.resume()
//
//        dispatchGroup.notify(queue: .main) {
//            self.showProgress = false
//        }
//    }
//    
//    private func scheduleInternetCheck() {
//        internetTimer?.invalidate()
//        internetTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
//            self.checkInternetConnection { isConnected in
//                if isConnected {
//                    self.fetchData()
//                }
//            }
//        }
//    }
//    
//    private func stopInternetCheck() {
//        internetTimer?.invalidate()
//        internetTimer = nil
//    }
//}
//










//struct Governorate: Codable, Identifiable {
//    let id: String
//    let governorateName: String
//    let governorateCode: Int
//    let regionID: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case governorateName = "governorate_name"
//        case governorateCode = "governorate_code"
//        case regionID = "region_id"
//    }
//}
//
//
//import SwiftUI
//import Combine
//
//class DataFetcher: ObservableObject {
//    @Published var governorates: [Governorate] = []
//    @Published var showProgress = false
//    
//    func fetchData() {
//        guard let url = URL(string: "http://198.244.227.48:8082/governorates/get-with-regions") else {
//            print("Invalid URL")
//            
//            DispatchQueue.main.async {
//                self.showProgress = true
//            }
//            
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//
//                DispatchQueue.main.async {
//                    self.showProgress = true
//                }
//                
//                return
//            }
//            
//            guard let data = data else {
//                print("No data")
//                DispatchQueue.main.async {
//                    self.showProgress = true
//                }
//                return
//            }
//            
//            do {
//                let decodedData = try JSONDecoder().decode([Governorate].self, from: data)
//                DispatchQueue.main.async {
//                    self.governorates = decodedData
//                    self.showProgress = false
//                }
//            } catch {
//                print("Decoding error: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.showProgress = true
//                }
//            }
//        }.resume()
//    }
//    
//    
//    
//    
//    
//}
