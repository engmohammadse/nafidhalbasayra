//
//  NotificationViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/01/2025.
//


struct NotificationModel: Identifiable, Codable {
    var id: String { _id }
    let _id: String
    let title: String
    let body: String
    let sender: String
    let createdAt: String
}




import Foundation

class FetchAndStoreNotificationsFromAPI: ObservableObject {
    private let database: CoreDataNotificationViewModel

    init(database: CoreDataNotificationViewModel) {
        self.database = database
    }

    func fetchAndStoreNotifications() async {
        let governorateKey = "governorate_id"
        guard let governorate_id = UserDefaults.standard.string(forKey: governorateKey) else {
            return
        }

        guard let url = URL(string: "http://198.244.227.48:8082/messages/governorate/\(governorate_id)") else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([NotificationModel].self, from: data)
            
            await MainActor.run {
                self.storeNotifications(decodedData)
            }
        } catch {
           // print("❌ Error fetching notifications: \(error.localizedDescription)")
        }
    }

    private func storeNotifications(_ notifications: [NotificationModel]) {
        for notif in notifications {
            let alreadyExists = database.savedEntitiesNotification.contains(where: { $0.idFromServer == notif._id })

            if !alreadyExists {
              //  print("🟢 Saving new notification: \(notif.title)")
                database.addNotification(from: notif)
            } else {
               // print("⚠️ Notification already exists, skipping: \(notif._id)")
            }
        }
    }
}








//import SwiftUI
//
//class NotificationViewModel: ObservableObject {
//    @Published var notifications: [NotificationModel] = []
//    
//    
//    
//    func fetchNotifications() {
//        
//        // Declare the key as a string
//            let governorateKey = "governorate_id"
//            
//            // Retrieve the value from UserDefaults
//            guard let governorate_id = UserDefaults.standard.string(forKey: governorateKey) else {
//                //print("Error: governorate_id not found in UserDefaults")
//                return
//            }
//        
//
//        guard let url = URL(string: "http://198.244.227.48:8082/messages/governorate/\(governorate_id)") else { return }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                do {
//                    let decodedData = try JSONDecoder().decode([NotificationModel].self, from: data)
//                    DispatchQueue.main.async {
//                        self.notifications = decodedData.reversed() // ✅ عكس الترتيب هنا
//                    }
//                } catch {
//                  //  print("Error decoding notifications: \(error)")
//                }
//            }
//        }.resume()
//    }
//}
