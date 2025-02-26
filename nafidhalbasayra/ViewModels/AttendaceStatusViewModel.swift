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
    
    static let shared = AttendaceStatusViewModel() // ✅ Singleton لتجنب تحميل النموذج أكثر من مرة

    
    let container: NSPersistentContainer
    @Published var savedEntitiesAttendace: [AttendaceStatus] = []

    private init() {
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
            savedEntitiesAttendace = try container.viewContext.fetch(request)
            print("✅ Successfully fetched \(savedEntitiesAttendace.count) entities.")
            for entity in savedEntitiesAttendace {
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
            print("❌ Error Fetching AttendaceStatus: \(error.localizedDescription)")
        }
    }




    // استدعاء الدالة وتحديد نوع الجهاز
    let deviceModel = getDeviceModel()
    
    
    func addAttendaceStatus(numberOfStudents: Int, imageData: Data?, notes: String, latitude: Double, longitude: Double, date: Date, state: Int16, idFromApi: String? = nil) {
        let newAttendaceStatus = AttendaceStatus(context: container.viewContext)
        newAttendaceStatus.id = UUID().uuidString
        newAttendaceStatus.numberOfStudents = String(numberOfStudents)
        newAttendaceStatus.image = imageData
        newAttendaceStatus.notes = notes + "\n(للتنويه: هذا مستخدم \(deviceModel))"
        newAttendaceStatus.latitude = latitude
        newAttendaceStatus.longitude = longitude
        newAttendaceStatus.date = date
        newAttendaceStatus.idFromApi = idFromApi // ✅ حفظ `idFromApi`


        // ✅ التأكد من تعيين قيمة `state` بناءً على المصدر (API أو إدخال يدوي)
        newAttendaceStatus.state = state

        saveData()
        fetchAttendaceStatus()
        
        print("✅ Successfully saved attendance status.")
        print("""
        ID: \(newAttendaceStatus.id ?? "No ID")
        State: \(newAttendaceStatus.state) ✅
        Latitude: \(newAttendaceStatus.latitude)
        Longitude: \(newAttendaceStatus.longitude)
        Notes: \(newAttendaceStatus.notes ?? "No notes")
        """)
    }


    
    func saveData() {
        do {
            try container.viewContext.save()
            DispatchQueue.main.async {
                self.fetchAttendaceStatus() // 🛑 تحديث البيانات بعد كل عملية حفظ
            }
        } catch let error {
            print("❌ Error saving data: \(error)")
        }
    }

  
    
    func resetAllStates() {
        for entity in savedEntitiesAttendace {
            entity.state = 0
        }
        saveData()
        print("✅ All states reset to 0.")
    }
    
    
    
    
    func clearAllAttendanceData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AttendaceStatus")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
            DispatchQueue.main.async {
                self.savedEntitiesAttendace.removeAll()
            }
            print("✅ تم مسح جميع بيانات الحضور بنجاح.")
        } catch let error {
            print("❌ فشل في مسح بيانات الحضور: \(error.localizedDescription)")
        }
    }



    
}
