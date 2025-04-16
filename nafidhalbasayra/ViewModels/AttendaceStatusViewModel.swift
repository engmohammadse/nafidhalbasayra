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

    
   // let container: NSPersistentContainer
    private let coreDataManager = CoreDataManager.shared

    
    @Published var savedEntitiesAttendace: [AttendaceStatus] = []

    private init() {
  
        fetchAttendaceStatus()
    }

    func fetchAttendaceStatus() {
        let request = NSFetchRequest<AttendaceStatus>(entityName: "AttendaceStatus")
        do {
            savedEntitiesAttendace = try coreDataManager.viewContext.fetch(request)
        } catch _ {
//            print("❌ Error Fetching AttendaceStatus: \(error.localizedDescription)")
        }
    }




    // استدعاء الدالة وتحديد نوع الجهاز
    let deviceModel = getDeviceModel()
    
    
    func addAttendaceStatus(numberOfStudents: Int, imageData: Data?, notes: String, latitude: Double, longitude: Double, date: Date, state: Int16, idFromApi: String? = nil) {
        let newAttendaceStatus = AttendaceStatus(context: coreDataManager.viewContext)
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

    }


    
    func saveData() {
        do {
            try coreDataManager.viewContext.save()
            DispatchQueue.main.async {
                self.fetchAttendaceStatus() // 🛑 تحديث البيانات بعد كل عملية حفظ
            }
        } catch _ {
           // print("❌ Error saving data: \(error)")
        }
    }

  
    
    func resetAllStates() {
        for entity in savedEntitiesAttendace {
            entity.state = 0
        }
        saveData()
       // print("✅ All states reset to 0.")
    }
    
    
    
    
    func clearAllAttendanceData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AttendaceStatus")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try coreDataManager.viewContext.execute(deleteRequest)
            try coreDataManager.viewContext.save()
            DispatchQueue.main.async {
                self.savedEntitiesAttendace.removeAll()
            }
           // print("✅ تم مسح جميع بيانات الحضور بنجاح.")
        } catch _ {
            //print("❌ فشل في مسح بيانات الحضور: \(error.localizedDescription)")
        }
    }
  
}
