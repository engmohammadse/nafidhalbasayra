//
//  fetchAndStoreStudentsFromBackEnd.swift
//  nafidhalbasayra
//
//  Created by muhammad on 20/02/2025.
//

import Foundation
import SwiftUI

// 🔹 تحديث `struct Student` لتتوافق مع الـ JSON
struct Student: Codable {
    let _id: String
    let teacher_id: String
    let name: String
    let phone_number: String
    let age: Int
    let degree: String
    let size: String
    let gender: String
    let academic_level: String
    let to_delete: Bool // ✅ جديد: التعامل مع حذف الطلاب
}

class fetchAndStoreStudentsFromBackEnd: ObservableObject {
    private let database: StudentViewModel

    init(database: StudentViewModel) {
        self.database = database
    }

    func fetchAndStoreStudents(teacherID: String) async {
        let urlString = "http://198.244.227.48:8082/students/get-all/\(teacherID)"
        guard let url = URL(string: urlString) else {
            print("❌ رابط غير صالح")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // ✅ طباعة البيانات المسترجعة من الـ API
            print("✅ تم جلب بيانات الطلاب بنجاح من الـ API")
            let decodedData = try JSONDecoder().decode([Student].self, from: data)
            print("📚 عدد الطلاب المسترجع: \(decodedData.count)")

            DispatchQueue.main.async {
                self.storeStudentsInDatabase(decodedData)
            }
        } catch {
            print("❌ فشل في جلب بيانات الطلاب: \(error.localizedDescription)")
        }
    }

    private func storeStudentsInDatabase(_ students: [Student]) {
        for student in students {
            // ✅ تجاهل الطلاب الذين لديهم `to_delete = true`
            guard !student.to_delete else {
                print("🚫 تجاهل الطالب: \(student.name) لأنه محذوف.")
                continue
            }

            // ✅ التحقق مما إذا كان الطالب موجودًا بالفعل في CoreData
            if let existingStudent = database.savedEntitiesStudent.first(where: { $0.studentID == student._id }) {
                // ✅ تحديث البيانات بدلًا من إضافة الطالب مرة أخرى
                print("🔄 تحديث بيانات الطالب: \(student.name)")
                database.updateStudentInfo(
                    entity: existingStudent,
                    with: student.name,
                    with: student.phone_number,
                    with: String(student.age),
                    with: student.degree,
                    with: student.size,
                    with: student.gender,
                    with: student.academic_level
                )
                database.updateStudentState(entity: existingStudent, newState: 1) // ✅ تحديث الحالة

            } else {
                // ✅ إضافة الطالب إذا لم يكن موجودًا
                print("📝 إضافة طالب جديد: \(student.name) إلى CoreData")
                database.addStudentInfo(
                    name: student.name,
                    phoneNumber: student.phone_number,
                    age: String(student.age),
                    level: student.degree,
                    size: student.size,
                    gender: student.gender,
                    academic_level: student.academic_level,
                    state: 1 // ✅ تعيين `state = 1` لأنه مرسل مسبقًا
                )
            }
        }

        // ✅ إعادة تحميل البيانات بعد التخزين أو التحديث
        DispatchQueue.main.async {
            self.database.fetchStudentInfo()
        }
    }
}
