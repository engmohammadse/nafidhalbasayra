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
        } catch let error {
            print("Error Fetching. \(error)")
        }
    }

    func addAttendaceStatus(numberOfStudents: Int, imageData: Data?, notes: String, latitude: Double, longitude: Double, date: Date) {
        let newAttendaceStatus = AttendaceStatus(context: container.viewContext)
        newAttendaceStatus.id = UUID().uuidString // تأكد من إضافة خاصية id في النموذج إذا لم تكن موجودة
        newAttendaceStatus.numberOfStudents = String(numberOfStudents)
        newAttendaceStatus.image = imageData
        newAttendaceStatus.notes = notes
        newAttendaceStatus.latitude = latitude
        newAttendaceStatus.longitude = longitude
        newAttendaceStatus.date = date
        saveData()
        fetchAttendaceStatus()
        print("Successfully saved attendance status for \(numberOfStudents) students.")
    }

    func saveData() {
        do {
            try container.viewContext.save()
            fetchAttendaceStatus()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
}
