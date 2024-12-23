//
//  AttendaceStatus.swift
//  nafidhalbasayra
//
//  Created by muhammad on 07/11/2024.
//

import Foundation
import SwiftUI
import CoreData

class AttendaceStatusViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedEntities: [AttendaceStatus] = []

    init() {
        container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("ERROR LOADING CORE DATالA. \(error)")
            }
        }
        fetchAttendaceStatus()
    }

    func fetchAttendaceStatus() {
        let request = NSFetchRequest<AttendaceStatus>(entityName: "AttendaceStatus")
        do {
            savedEntities = try container.viewContext.fetch(request)
            print("✅ Successfully fetched \(savedEntities.count) entities.")
            for entity in savedEntities {
                print("""
                Entity:
                ID: \(entity.id ?? "No ID")
                State: \(entity.state)
                Latitude: \(entity.latitude)
                Longitude: \(entity.longitude)
                Notes: \(entity.notes ?? "No notes")
                """)
            }
        } catch let error {
            print("❌ Error Fetching. \(error)")
        }
    }

    
//    func fetchAttendaceStatus() {
//        let request = NSFetchRequest<AttendaceStatus>(entityName: "AttendaceStatus")
//        do {
//            savedEntities = try container.viewContext.fetch(request)
//        } catch let error {
//            print("Error Fetching. \(error)")
//        }
//    }

    func addAttendaceStatus(numberOfStudents: Int, imageData: Data?, notes: String, latitude: Double, longitude: Double, date: Date) {
        let newAttendaceStatus = AttendaceStatus(context: container.viewContext)
        newAttendaceStatus.id = UUID().uuidString // تأكد من إضافة خاصية id في النموذج إذا لم تكن موجودة
        newAttendaceStatus.numberOfStudents = String(numberOfStudents)
        newAttendaceStatus.image = imageData
        newAttendaceStatus.notes = notes
        newAttendaceStatus.latitude = latitude
        newAttendaceStatus.longitude = longitude
        newAttendaceStatus.date = date
        newAttendaceStatus.state = 0
        saveData()
        fetchAttendaceStatus()
        print("Successfully saved attendance status.")
        
        print("Added new entity:")
          print("""
          ID: \(newAttendaceStatus.id ?? "No ID")
          State: \(newAttendaceStatus.state)
          Latitude: \(newAttendaceStatus.latitude)
          Longitude: \(newAttendaceStatus.longitude)
          Notes: \(newAttendaceStatus.notes ?? "No notes")
          """)
    }

    func saveData() {
        do {
            try container.viewContext.save()
            fetchAttendaceStatus()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    
    
    
    func resetAllStates() {
        for entity in savedEntities {
            entity.state = 0
        }
        saveData()
        print("✅ All states reset to 0.")
    }

    
}
