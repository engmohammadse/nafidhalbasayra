//
//  cityGet.swift
//  nafidhalbasayra
//
//  Created by muhammad on 02/12/2024.
//

struct Governorate: Codable, Identifiable {
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


import SwiftUI
import Combine

class DataFetcher: ObservableObject {
    @Published var governorates: [Governorate] = []
    
    func fetchData() {
        guard let url = URL(string: "http://198.244.227.48:8082/governorates/get-with-regions") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Governorate].self, from: data)
                DispatchQueue.main.async {
                    self.governorates = decodedData
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    
    
    
}
