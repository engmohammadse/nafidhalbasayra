//
//  fetchAndStoreAttendances.swift
//  nafidhalbasayra
//
//  Created by muhammad on 15/02/2025.
//


import Foundation
import SwiftUI
import CoreData

struct Attendance: Codable {
    struct Location: Codable {
        let lat: Double
        let lng: Double
    }
    
    let register_location: Location
    let _id: String
    let teacher_id: String
    let register_date: String
    let students_number: Int
    let image: String
    let message: String
    let createdAt: String
    let updatedAt: String
}

class fetchAndStoreAttendancesFromBackEnd: ObservableObject {
    private let database: AttendaceStatusViewModel
    private let coreDataManager = CoreDataManager.shared

    init(database: AttendaceStatusViewModel) {
        self.database = database
    }
    
    func fetchAndStoreAttendances(teacherID: String) async {
        let urlString = "http://198.244.227.48:8082/attendance/teacher/\(teacherID)"
        guard let url = URL(string: urlString) else {
           // print("❌ رابط غير صالح")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // طباعة البيانات المسترجعة من الـ API
           // print("✅ تم جلب البيانات بنجاح من الـ API")
            let decodedData = try JSONDecoder().decode([Attendance].self, from: data)
          //  print("عدد الحضور المسترجع: \(decodedData.count)")
            for _ in decodedData {
             //   print("التاريخ: \(attendance.register_date), عدد الطلاب: \(attendance.students_number), الرسالة: \(attendance.message)")
            }

            DispatchQueue.main.async {
                self.storeAttendancesInDatabase(decodedData)
            }
        } catch {
         //   print("❌ فشل في جلب البيانات: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    private func storeAttendancesInDatabase(_ attendances: [Attendance]) {
        
//        let context = database.container.viewContext

        let context = coreDataManager.viewContext


        for attendance in attendances {
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // مطابق لـ register_date في API
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.calendar = Calendar(identifier: .gregorian)

            // 🔹 تعريف `date` أولًا كقيمة افتراضية قبل محاولة تعيينها من النص القادم من API
            var date: Date = Date()

            if let attendanceDate = dateFormatter.date(from: attendance.register_date) {
                date = attendanceDate
            } else {
              //  print("⚠️ خطأ في تحويل التاريخ: \(attendance.register_date)")
            }


            
//            let dateFormatter = ISO8601DateFormatter()
//            let date = dateFormatter.date(from: attendance.register_date) ?? Date()

            // ✅ استعلام في Core Data للتحقق من وجود السجل مسبقًا باستخدام `idFromApi`
            let fetchRequest: NSFetchRequest<AttendaceStatus> = AttendaceStatus.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "idFromApi == %@", attendance._id)

            do {
                let existingRecords = try context.fetch(fetchRequest)
                if !existingRecords.isEmpty {
                 //   print("🚫 الحضور موجود مسبقًا في Core Data، سيتم تجاهله: \(attendance.register_date)")
                    continue // ❌ تخطي الإضافة إذا كان موجودًا
                }
            } catch {
               // print("❌ خطأ في استعلام Core Data: \(error.localizedDescription)")
                continue
            }

          //  print("📝 تخزين الحضور الجديد: \(attendance.register_date), عدد الطلاب: \(attendance.students_number), الرسالة: \(attendance.message)")

            // ✅ إضافة الحضور الجديد مع `idFromApi` مباشرة
            database.addAttendaceStatus(
                numberOfStudents: attendance.students_number,
                imageData: nil, // 🔹 لا يوجد بيانات صورة من الـ API
                notes: attendance.message,
                latitude: attendance.register_location.lat,
                longitude: attendance.register_location.lng,
                date: date,
                state: 1, // ✅ تعيين `state = 1` للتأكد من أنه مخزن بشكل صحيح
                idFromApi: attendance._id // ✅ تخزين `idFromApi` مباشرة أثناء الإضافة
            )
        }

        // ✅ إعادة تحميل البيانات بعد التخزين
        DispatchQueue.main.async {
            self.database.fetchAttendaceStatus()
        }
    }

    
    

}



