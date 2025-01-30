//
//  NotificationViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/01/2025.
//


import Foundation

struct NotificationModel: Identifiable, Codable {
    var id: String { _id }
    let _id: String
    let title: String
    let body: String
    let sender: String
    let createdAt: String
}



import SwiftUI

class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    
    func fetchNotifications() {
        guard let url = URL(string: "http://198.244.227.48:8082/messages/get/") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([NotificationModel].self, from: data)
                    DispatchQueue.main.async {
                        self.notifications = decodedData
                    }
                } catch {
                    print("Error decoding notifications: \(error)")
                }
            }
        }.resume()
    }
}
