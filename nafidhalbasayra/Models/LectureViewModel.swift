//
//  LectureViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/01/2025.
//


import Foundation

struct Lecture: Identifiable, Decodable {
    let _id: String
    let week_order: Int
    let youtube_url: String
    var id: String { _id } // استخدام _id كـ id
}




class LectureViewModel: ObservableObject {
    @Published var lectures: [Lecture] = []
    
    func fetchLectures() {
        guard let url = URL(string: "http://198.244.227.48:8082/lectures/") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Lecture].self, from: data)
                    DispatchQueue.main.async {
                        self.lectures = decodedData
                    }
                } catch {
                    print("❌ خطأ في فك التشفير: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("❌ خطأ في جلب البيانات: \(error.localizedDescription)")
            }
        }.resume()
    }
}


