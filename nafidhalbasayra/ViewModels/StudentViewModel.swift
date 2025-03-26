//
//  StudentViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 31/10/2024.
//
//






//import SwiftUI
import CoreData

class StudentViewModel: ObservableObject {
    
    static let shared = StudentViewModel() // ✅ Singleton لتجنب تحميل النموذج أكثر من مرة

    
    let container: NSPersistentContainer
    @Published var savedEntitiesStudent: [StudentInfo] = []

    private init() { // ✅ جعل الـ initializer خاصًا لمنع إنشاء نسخ جديدة
        container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if error != nil {
               // print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        fetchStudentInfo()
    }
    
    
    
    

    func fetchStudentInfo() {
        let request = NSFetchRequest<StudentInfo>(entityName: "StudentInfo")
        do {
            savedEntitiesStudent = try container.viewContext.fetch(request)
        } catch _ {
           // print("Error Fetching. \(error)")
        }
    }
    
    
    

    
    
    
    
    
    
    
    
    func addStudentInfo(name: String, phoneNumber: String, age: String, level: String, size: String, gender: String, academic_level: String, state:Int16, idFromApi: String ) {
        let newStudentInfo = StudentInfo(context: container.viewContext)
        
        newStudentInfo.studentID = UUID().uuidString // توليد المعرف تلقائيًا
        newStudentInfo.name = name
        newStudentInfo.phoneNumber = phoneNumber
        newStudentInfo.age = age
//        newStudentInfo.city = city
        newStudentInfo.level = level
        newStudentInfo.size = size
        newStudentInfo.state = state
        newStudentInfo.isSending = false
        newStudentInfo.gender = gender
        newStudentInfo.academic_level = academic_level
        newStudentInfo.idFromApi = idFromApi
        
        
        saveStudentData()
        fetchStudentInfo() // استدعاء fetch بعد الحفظ للتأكد من تحديث البيانات

    }
    
    
    
   // تحديث الحالة
    func updateStudentState(entity: StudentInfo, newState: Int) {
         entity.state = Int16(newState) // تحديث حالة الطالب
         saveStudentData() // حفظ التغييرات
     }
    
    
    
    

    func updateStudentInfo(entity: StudentInfo, with newName: String, with newphoneNumber: String, with newAge: String, with newLevel: String, with newSize: String, with newGender: String, with newAcademic_level: String) {
        entity.name = newName
        entity.phoneNumber = newphoneNumber
        entity.age = newAge
//        entity.city = newCity
        entity.level = newLevel
        entity.size = newSize
        entity.gender = newGender
        entity.academic_level = newAcademic_level
        saveStudentData()
    }
    
    
    

    
    func deleteStudentInfo(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedEntitiesStudent[index]
        container.viewContext.delete(entity)
        
        do {
            try container.viewContext.save() // حفظ التغييرات
            fetchStudentInfo() // تحديث البيانات بعد الحذف
            //print("حذف البيانات لطالب: \(entity.name ?? "لا يوجد اسم")")
        } catch {
           // print("خطأ أثناء الحذف: \(error)")
        }
    }


    

    
    

    func saveStudentData() {
        do {
            try container.viewContext.save()
            fetchStudentInfo()
        } catch _ {
          //  print("Error saving. \(error)")
        }
    }
    
    
    
    
    func clearAllStudentData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "StudentInfo")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
            DispatchQueue.main.async {
                self.savedEntitiesStudent.removeAll()
            }
            //print("✅ تم مسح جميع بيانات الطلاب من CoreData.")
        } catch _ {
           // print("❌ فشل في مسح بيانات الطلاب: \(error.localizedDescription)")
        }
    }

    
    
    
}




