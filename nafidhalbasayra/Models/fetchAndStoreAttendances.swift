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

class AttendanceViewModel: ObservableObject {
    @Published var attendances: [Attendance] = []
    private let database: AttendaceStatusViewModel
    
    init(database: AttendaceStatusViewModel) {
        self.database = database
    }
    
    func fetchAndStoreAttendances(teacherID: String) async {
        let urlString = "http://198.244.227.48:8082/attendance/teacher/\(teacherID)"
        guard let url = URL(string: urlString) else {
            print("❌ رابط غير صالح")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // طباعة البيانات المسترجعة من الـ API
            print("✅ تم جلب البيانات بنجاح من الـ API")
            let decodedData = try JSONDecoder().decode([Attendance].self, from: data)
            print("عدد الحضور المسترجع: \(decodedData.count)")
            for attendance in decodedData {
                print("التاريخ: \(attendance.register_date), عدد الطلاب: \(attendance.students_number), الرسالة: \(attendance.message)")
            }

            DispatchQueue.main.async {
                self.attendances = decodedData
                self.storeAttendancesInDatabase()
            }
        } catch {
            print("❌ فشل في جلب البيانات: \(error.localizedDescription)")
        }
    }
    
    private func storeAttendancesInDatabase() {
        for attendance in attendances {
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: attendance.register_date) ?? Date()
            
            // طباعة البيانات قبل تخزينها
            print("تخزين الحضور: \(attendance.register_date), عدد الطلاب: \(attendance.students_number), الرسالة: \(attendance.message)")
            
            database.addAttendaceStatus(
                numberOfStudents: attendance.students_number,
                imageData: nil, // لا يوجد بيانات صورة من الـ API
                notes: attendance.message,
                latitude: attendance.register_location.lat,
                longitude: attendance.register_location.lng,
                date: date,
                state: 1
            )
        }
    }
}



















//import Foundation
//import SwiftUI
//import CoreData
//
//
//struct Attendance: Codable {
//    struct Location: Codable {
//        let lat: Double
//        let lng: Double
//    }
//    
//    let register_location: Location
//    let _id: String
//    let teacher_id: String
//    let register_date: String
//    let students_number: Int
//    let image: String
//    let message: String
//    let createdAt: String
//    let updatedAt: String
//}
//
//
//
//
//class AttendanceViewModel: ObservableObject {
//    @Published var attendances: [Attendance] = []
//    private let database: AttendaceStatusViewModel
//    
//    init(database: AttendaceStatusViewModel) {
//        self.database = database
//    }
//    
//    func fetchAndStoreAttendances(teacherID: String) async {
//        let urlString = "http://198.244.227.48:8082/attendance/teacher/\(teacherID)"
//        guard let url = URL(string: urlString) else {
//            print("❌ رابط غير صالح")
//            return
//        }
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let decodedData = try JSONDecoder().decode([Attendance].self, from: data)
//            DispatchQueue.main.async {
//                self.attendances = decodedData
//                self.storeAttendancesInDatabase()
//            }
//        } catch {
//            print("❌ فشل في جلب البيانات: \(error.localizedDescription)")
//        }
//    }
//    
//    private func storeAttendancesInDatabase() {
//        for attendance in attendances {
//            let dateFormatter = ISO8601DateFormatter()
//            let date = dateFormatter.date(from: attendance.register_date) ?? Date()
//            
//            database.addAttendaceStatus(
//                numberOfStudents: attendance.students_number,
//                imageData: nil, // لا يوجد بيانات صورة من الـ API
//                notes: attendance.message,
//                latitude: attendance.register_location.lat,
//                longitude: attendance.register_location.lng,
//                date: date,
//                state: 1
//                
//            )
//        }
//    }
//}
