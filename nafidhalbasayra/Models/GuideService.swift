//
//  GuideService.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/01/2025.
//




import Foundation

class GuideService {
    static let shared = GuideService()
    private let baseURL = "http://198.244.227.48:8082/guides/"

    func fetchGuides(completion: @escaping ([Guide]?, String?) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(nil, "❌ رابط غير صالح")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, "❌ خطأ في الاتصال: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, "❌ لم يتم استلام أي بيانات")
                }
                return
            }

            do {
                let guides = try JSONDecoder().decode([Guide].self, from: data)
                DispatchQueue.main.async {
                    completion(guides, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, "❌ فشل تحليل البيانات: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}


import SwiftUI

class GuideViewModel: ObservableObject {
    @Published var guides: [Guide] = []
    
    func fetchGuides() {
        guard let url = URL(string: "http://198.244.227.48:8082/guides/") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedGuides = try JSONDecoder().decode([Guide].self, from: data)
                    DispatchQueue.main.async {
                        self.guides = decodedGuides
                    }
                } catch {
                   // print("❌ خطأ في فك التشفير: \(error.localizedDescription)")
                }
            } else if error != nil {
               // print("❌ خطأ في جلب البيانات: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct Guide: Identifiable, Decodable {
    var id: String { _id } // 🔹 استخدام _id كـ id
    let _id: String
    let title: String
    let youtube_url: String
    let description: String
}

