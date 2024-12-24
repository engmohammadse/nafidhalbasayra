//
//  TeacherDataFromApiViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 24/12/2024.
//

import Foundation

import CoreData

class TeacherDataFromApiViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedEntities: [TeacherDataFromApi] = []

    init() {
        container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        fetchTeacherData()
    }
    
    
    
    

    func fetchTeacherData() {
        let request = NSFetchRequest<TeacherDataFromApi>(entityName: "TeacherDataFromApi")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching. \(error)")
        }
    }
    
    
    

    
    
    
    func addTeacherData(id: String) {
        
        
        // تحقق إذا كان المعلم موجودًا بالفعل
           if savedEntities.contains(where: { $0.idTeacherApi == id }) {
               print("⚠️ المعلم موجود بالفعل في قاعدة البيانات.")
               return
           }
        
        // إضافة معلم جديد
        
        let newTeacherData = TeacherDataFromApi(context: container.viewContext)
        
        newTeacherData.idTeacherApi = id
       
        
        saveTeacherData()
        fetchTeacherData() // استدعاء fetch بعد الحفظ للتأكد من تحديث البيانات

    }
    
    
    
    
//    func addStudentInfo(name: String, phoneNumber: String, age: String, city: String, level: String, size: String) {
//        let newStudentInfo = StudentInfo(context: container.viewContext)
//        
//        newStudentInfo.studentID = UUID().uuidString // توليد المعرف تلقائيًا
//        newStudentInfo.name = name
//        newStudentInfo.phoneNumber = phoneNumber
//        newStudentInfo.age = age
//        newStudentInfo.city = city
//        newStudentInfo.level = level
//        newStudentInfo.size = size
//        
//        saveTeacherData()
//        fetchTeacherData() // استدعاء fetch بعد الحفظ للتأكد من تحديث البيانات
//
//    }
    
    
    
   
    
    
    
    
    

//    func updateTeacherData(entity: StudentInfo, with newName: String, with newphoneNumber: String, with newAge: String, with newCity: String, with newLevel: String, with newSize: String) {
//        entity.name = newName
//        entity.phoneNumber = newphoneNumber
//        entity.age = newAge
//        entity.city = newCity
//        entity.level = newLevel
//        entity.size = newSize
//        saveTeacherData()
//    }
    
    
    

    
//    func deleteTeacherData(indexSet: IndexSet) {
//        guard let index = indexSet.first else { return }
//        let entity = savedEntities[index]
//        container.viewContext.delete(entity)
//        
//        do {
//            try container.viewContext.save() // حفظ التغييرات
//            fetchTeacherData() // تحديث البيانات بعد الحذف
//            print("حذف البيانات لطالب: \(entity.name ?? "لا يوجد اسم")")
//        } catch {
//            print("خطأ أثناء الحذف: \(error)")
//        }
//    }


    

    
    

    func saveTeacherData() {
        do {
            try container.viewContext.save()
            fetchTeacherData()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    
}
