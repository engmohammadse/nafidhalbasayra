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
    @Published var savedEntitiesAttendace: [AttendaceStatus] = []

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
    
    
    func addAttendaceStatus(numberOfStudents: Int, imageData: Data?, notes: String, latitude: Double, longitude: Double, date: Date, state: Int16) {
        let newAttendaceStatus = AttendaceStatus(context: container.viewContext)
        newAttendaceStatus.id = UUID().uuidString
        newAttendaceStatus.numberOfStudents = String(numberOfStudents)
        newAttendaceStatus.image = imageData
        newAttendaceStatus.notes = notes + "\n(للتنويه: هذا مستخدم \(deviceModel))"
        newAttendaceStatus.latitude = latitude
        newAttendaceStatus.longitude = longitude
        newAttendaceStatus.date = date

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

    
//    func addAttendaceStatus(numberOfStudents: Int, imageData: Data?, notes: String, latitude: Double, longitude: Double, date: Date, state: Int16) {
//        let newAttendaceStatus = AttendaceStatus(context: container.viewContext)
//        newAttendaceStatus.id = UUID().uuidString // تأكد من إضافة خاصية id في النموذج إذا لم تكن موجودة
//        newAttendaceStatus.numberOfStudents = String(numberOfStudents)
//        newAttendaceStatus.image = imageData
//        newAttendaceStatus.notes = notes + "\n(للتنويه: هذا مستخدم \(deviceModel))"
//
//        //newAttendaceStatus.notes = notes + "\n(للتنوية هذا مستخدم ايفون)"
//        newAttendaceStatus.latitude = latitude
//        newAttendaceStatus.longitude = longitude
//        newAttendaceStatus.date = date
//       // newAttendaceStatus.state = 0
//        saveData()
//        fetchAttendaceStatus()
//        print("Successfully saved attendance status.")
//        
//        print("Added new entity:")
//          print("""
//          ID: \(newAttendaceStatus.id ?? "No ID")
//          State: \(newAttendaceStatus.state)
//          Latitude: \(newAttendaceStatus.latitude)
//          Longitude: \(newAttendaceStatus.longitude)
//          Notes: \(newAttendaceStatus.notes ?? "No notes")
//          """)
//    }

    
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
            // ✅ تنفيذ الحذف الفعلي للبيانات
            try container.viewContext.execute(deleteRequest)
            
            // ✅ حفظ التغييرات للتأكد من أنها تمت في قاعدة البيانات
            try container.viewContext.save()
            
            // ✅ مسح الكاش والتأكد من عدم وجود بيانات قديمة محملة في الذاكرة
            container.viewContext.refreshAllObjects()
            
            // ✅ إعادة تحميل البيانات للتأكد من أنها فارغة
            DispatchQueue.main.async {
                self.savedEntitiesAttendace.removeAll()
                self.fetchAttendaceStatus()
            }
            
            print("✅ تم مسح جميع بيانات الحضور من CoreData بنجاح.")
        } catch let error {
            print("❌ فشل في مسح بيانات الحضور: \(error.localizedDescription)")
        }
    }


    
}
