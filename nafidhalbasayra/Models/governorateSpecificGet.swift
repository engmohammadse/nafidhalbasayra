//
//  governorateSpecificGet.swift
//  nafidhalbasayra
//
//  Created by muhammad on 08/12/2024.
//


var globalCityIdFromApi: String = ""




import SwiftUI
import Combine
import Network

struct Province: Codable, Identifiable, Equatable {
    let id: String
    let governorateID: String
    let regionName: String
    let governorateCode: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case governorateID = "governorate_id"
        case regionName = "region_name"
        case governorateCode = "governorate_code"
    }
}

class ProvinceSpecificGet: ObservableObject {
    @Published var province: [Province] = [] // Renamed to `provinces`
    @Published var showProgress = false
    @Published var errorMessage: String?
    private var internetTimer: Timer?
    private var fetchRequested = false
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue.global(qos: .background)

    func startMonitoring() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
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
        guard let url = URL(string: "http://198.244.227.48:8082/regions/get-for-governorate/\(globalCityIdFromApi)/") else {
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

        session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

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
                let decodedData = try JSONDecoder().decode([Province].self, from: data)
                DispatchQueue.main.async {
                    self.province = decodedData // Updated to `provinces`
                    self.showProgress = false
                    self.fetchRequested = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "خطأ في فك التشفير: \(error.localizedDescription)"
                    self.showProgress = false
                }
            }
        }
        .resume()
    }
}
















//import Network
//
//class ProvinceSpecificGet: ObservableObject {
//
//
//    @Published var province: [Province] = []
//    @Published var showProgress = false
//    @Published var errorMessage: String?
//    private var internetTimer: Timer?
//    private var fetchRequested = false
//    private var monitor: NWPathMonitor?
//    private let queue = DispatchQueue.global(qos: .background)
//    
//    
//
//    func startMonitoring() {
//        monitor = NWPathMonitor()
//        monitor?.pathUpdateHandler = { path in
//            DispatchQueue.main.async {
//                if path.status == .satisfied {
//                    if self.fetchRequested {
//                        self.performDataFetch()
//                    }
//                } else {
//                    self.errorMessage = "لا يوجد اتصال بالإنترنت"
//                    self.showProgress = false
//                }
//            }
//        }
//        monitor?.start(queue: queue)
//    }
//
//    func stopMonitoring() {
//        monitor?.cancel()
//        monitor = nil
//    }
//
//    func fetchData() {
//        fetchRequested = true
//        DispatchQueue.main.async {
//            self.showProgress = true
//            self.errorMessage = nil
//        }
//
//        if monitor == nil {
//            startMonitoring()
//        }
//
//        performDataFetch()
//    }
//
//    private func performDataFetch() {
//        guard let url = URL(string: "http://198.244.227.48:8082/regions/get-for-governorate/\(globalCityIdFromApi)/") else {
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
//                }
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ في الخادم"
//                    self.showProgress = false
//                }
//                return
//            }
//
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "لا توجد بيانات"
//                    self.showProgress = false
//                }
//                return
//            }
//
//            do {
//                let decodedData = try JSONDecoder().decode([Province].self, from: data)
//                DispatchQueue.main.async {
//                    self.province = decodedData
//                    self.showProgress = false
//                    self.fetchRequested = false
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = "خطأ في فك التشفير: \(error.localizedDescription)"
//                    self.showProgress = false
//                }
//            }
//        }.resume()
//    }
//    
//    
//    // دالة لطباعة المحتويات
//      func printProvinces() {
//          for province in province {
//              print("ID: \(province.id), Governorate ID: \(province.governorateID), Region Name: \(province.regionName), Governorate Code: \(province.governorateCode)")
//          }
//      }
//    
//    
//}
