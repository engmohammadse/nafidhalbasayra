//
//  ContentView.swift
//  nafidhalbasayra
//
//  Created by muhammad on 23/09/2024.
//

// new


import SwiftUI
import CoreData

class CoreDataViewModel: ObservableObject {
    
    static let shared = CoreDataViewModel() //  Singleton

    
    
    let container: NSPersistentContainer
    @Published var savedEntitiesTeacher: [TeacherInfo] = []

    private init() {
        container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
//            if let error = error {
//               // print("ERROR LOADING CORE DATA. \(error)")
//            }
        }
        fetchTeacherInfo()
    }
    
    
    

    func fetchTeacherInfo() {
        let request = NSFetchRequest<TeacherInfo>(entityName: "TeacherInfo")
        do {
            savedEntitiesTeacher = try container.viewContext.fetch(request)
        } 
        catch _ {
            //print("Error Fetching. \(error)")
        }
    }
    
    
    
    
    
    
    
    

    func addTeacherInfo(text: String) {
        let newTeacherInfo = TeacherInfo(context: container.viewContext)
        newTeacherInfo.name = text
        saveTeacherData()
    }

    func updateTeacherInfo(entity: TeacherInfo, with newName: String) {
        entity.name = newName
        saveTeacherData()
    }

    func deleteTeacherInfo(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedEntitiesTeacher[index]
        container.viewContext.delete(entity)
        saveTeacherData()
    }
    
    
    
    
    
    
    func deleteAllTeacherInfo() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TeacherInfo")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        // الحصول على الـ objectIDs للكائنات المحذوفة
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let result = try container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                // دمج التغييرات في الـ context لتحديث الكاش وإزالة الكائنات المحذوفة
                let changes = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
            }
            // إعادة تعيين الـ context لتفريغ الكائنات القديمة
            container.viewContext.reset()
            fetchTeacherInfo()
           // print("All records in TeacherInfo have been deleted.")
        } catch _ {
           // print("Error deleting all records in TeacherInfo: \(error)")
        }
    }

//    func deleteAllTeacherInfo() {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TeacherInfo")
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        batchDeleteRequest.resultType = .resultTypeObjectIDs
//        
//        do {
//            let result = try container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
//            if let objectIDs = result?.result as? [NSManagedObjectID] {
//                // دمج التغييرات لتحديث الـ context
//                let changes = [NSDeletedObjectsKey: objectIDs]
//                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
//            }
//            // تحديث البيانات
//            fetchTeacherInfo()
//            print("All records in TeacherInfo have been deleted.")
//        } catch let error {
//            print("Error deleting all records in TeacherInfo: \(error)")
//        }
//    }


    
    

    func saveTeacherData() {
        do {
            try container.viewContext.save()
            fetchTeacherInfo()
        } 
        
        catch _ {
          //  print("Error saving. \(error)")
        }
    }
    
    
    
    
    func addTeacherInfoToCoreData(from teacherData: TeacherDataViewModel, with faceImage: Data?, with frontId: Data?, with backId: Data?) {
        // Create a new entity in Core Data
        let newTeacherInfo = TeacherInfo(context: container.viewContext)
        
        // Map values from TeacherDataViewModel to TeacherInfo entity
        newTeacherInfo.name = teacherData.name
        newTeacherInfo.birthDay = teacherData.birthDay
        // check error 0 phonenumber
        newTeacherInfo.phonenumber = teacherData.phonenumber
        newTeacherInfo.province = teacherData.province
        newTeacherInfo.city = teacherData.city
        newTeacherInfo.didyoutaught = teacherData.didyoutaught ?? false
        newTeacherInfo.mosquname = teacherData.mosquname
        newTeacherInfo.academiclevel = teacherData.academiclevel
        newTeacherInfo.currentWork = teacherData.currentWork
        newTeacherInfo.teacherID = UUID().uuidString // Generate a unique ID for the teacher
        newTeacherInfo.profileimage = faceImage // Store image data if provided
        newTeacherInfo.frontfaceidentity = frontId
        newTeacherInfo.backfaceidentity = backId
        
//        @Published var frontfaceidentity: UIImage?
//        @Published var backfaceidentity: UIImage?
        
        
        // Handle optional image data
        // هنا نعوض مكان الصورة في حال لا توجد صورة بي nill
        if let validImageData = faceImage {
            newTeacherInfo.profileimage = validImageData
        } else {
            newTeacherInfo.profileimage = nil // Set to nil if no image data is provided
        }
        
        
        if let validImageDataFront = frontId {
            newTeacherInfo.frontfaceidentity = validImageDataFront
        } else {
            newTeacherInfo.frontfaceidentity = nil // Set to nil if no image data is provided
        }
        
        if let validImageDataBack = backId {
            newTeacherInfo.backfaceidentity = validImageDataBack
        } else {
            newTeacherInfo.backfaceidentity = nil // Set to nil if no image data is provided
        }
        


        // Safely convert citynumber to Int16
        if let cityNumber = Int16(teacherData.citynumber) {
            newTeacherInfo.citynumber = cityNumber
        } else {
            newTeacherInfo.citynumber = 0 // Default value if conversion fails
        }

        // Save the data in Core Data
        saveTeacherData()
    }
    
   

    
    
    

    
}





import SwiftUI
import CoreData

extension CoreDataViewModel {
    
    /// دالة لحفظ بيانات الأستاذ فقط إذا كانت حقيقية
    func saveTeacherInfo(from response: LoginResponse) {
        let context = container.viewContext

        // ✅ التأكد من وجود بيانات في `LoginResponse`
        guard let teacherData = response.data else {
            //print("❌ لا توجد بيانات متاحة لحفظ الأستاذ في Core Data.")
            return
        }

        // ✅ التحقق مما إذا كانت البيانات حقيقية وليست ديمو
        guard !response.id.isEmpty,
              let fullName = teacherData.full_name, !fullName.isEmpty,
              let phoneNumber = teacherData.phone_number, !phoneNumber.isEmpty,
              let profileImage = teacherData.image_1, !profileImage.isEmpty else {
          //  print("🚫 تم اكتشاف بيانات غير صحيحة أو ديمو، لن يتم حفظها.")
            return
        }

        // ✅ 🔥 حذف أي بيانات قديمة للأستاذ قبل حفظ البيانات الجديدة
        deleteAllTeacherInfo()

        // ✅ إضافة أستاذ جديد
       // print("📝 إضافة أستاذ جديد: \(fullName) إلى Core Data")
        let newTeacherInfo = TeacherInfo(context: context)
        updateTeacherEntity(newTeacherInfo, with: response)

        // ✅ حفظ البيانات في Core Data
        do {
            try context.save()
            fetchTeacherInfo() // تحديث القائمة بعد الحفظ
           // print("✅ تم حفظ بيانات الأستاذ بنجاح في Core Data.")
        } catch {
          //  print("❌ خطأ أثناء حفظ بيانات الأستاذ: \(error.localizedDescription)")
        }
    }
    
    /// دالة لتحديث بيانات `TeacherInfo` مباشرةً من `LoginResponse`
    private func updateTeacherEntity(_ teacherEntity: TeacherInfo, with response: LoginResponse) {
        teacherEntity.teacherID = response.id
        teacherEntity.name = response.data?.full_name
        teacherEntity.birthDay = convertToDate(response.data?.birth_date)
        teacherEntity.phonenumber = response.data?.phone_number
        teacherEntity.province = response.data?.region_id
        teacherEntity.city = response.data?.governorate_id
        teacherEntity.mosquname = response.data?.mosque_name
        teacherEntity.academiclevel = response.data?.degree
        teacherEntity.currentWork = response.data?.work
        teacherEntity.didyoutaught = response.data?.previous_teacher ?? false
        teacherEntity.gender = response.data?.gender

        // ✅ طباعة التحقق من الهاتف
       // print("📞 رقم الهاتف المحفوظ: \(teacherEntity.phonenumber ?? "غير مدخل")")

        // ✅ تنزيل الصور الثلاثة وتخزينها في Core Data
        let baseURL = "http://198.244.227.48:8082"

        if let image1 = response.data?.image_1, !image1.isEmpty {
            let fullImageUrl = baseURL + image1
            downloadAndSaveImage(imageUrl: fullImageUrl) { imageData in
                teacherEntity.profileimage = imageData
                self.saveTeacherData()
            }
        }
        
        if let image2 = response.data?.image_2, !image2.isEmpty {
            let fullImageUrl = baseURL + image2
            downloadAndSaveImage(imageUrl: fullImageUrl) { imageData in
                teacherEntity.frontfaceidentity = imageData
                self.saveTeacherData()
            }
        }
        
        if let image3 = response.data?.image_3, !image3.isEmpty {
            let fullImageUrl = baseURL + image3
            downloadAndSaveImage(imageUrl: fullImageUrl) { imageData in
                teacherEntity.backfaceidentity = imageData
                self.saveTeacherData()
            }
        }
    }
    
    /// 🔹 دالة لتحويل `String` إلى `Date`
    private func convertToDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString, !dateString.isEmpty else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}








import UIKit

/// دالة لتنزيل الصورة من السيرفر وحفظها كـ `Data`
func downloadAndSaveImage(imageUrl: String, completion: @escaping (Data?) -> Void) {
    guard let url = URL(string: imageUrl) else {
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
           // print("❌ فشل تحميل الصورة: \(error.localizedDescription)")
            completion(nil)
            return
        }

        DispatchQueue.main.async {
            completion(data) // إرجاع بيانات الصورة عند النجاح
        }
    }
    task.resume()
}


