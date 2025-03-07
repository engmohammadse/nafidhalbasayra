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
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        fetchStudentInfo()
    }
    
    
    
    

    func fetchStudentInfo() {
        let request = NSFetchRequest<StudentInfo>(entityName: "StudentInfo")
        do {
            savedEntitiesStudent = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching. \(error)")
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
            print("حذف البيانات لطالب: \(entity.name ?? "لا يوجد اسم")")
        } catch {
            print("خطأ أثناء الحذف: \(error)")
        }
    }


    

    
    

    func saveStudentData() {
        do {
            try container.viewContext.save()
            fetchStudentInfo()
        } catch let error {
            print("Error saving. \(error)")
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
            print("✅ تم مسح جميع بيانات الطلاب من CoreData.")
        } catch let error {
            print("❌ فشل في مسح بيانات الطلاب: \(error.localizedDescription)")
        }
    }

    
    
    
//    func clearAllStudentData() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "StudentInfo")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try container.viewContext.execute(deleteRequest)
//            try container.viewContext.save()
//            DispatchQueue.main.async {
//                self.savedEntitiesStudent.removeAll() // تحديث القائمة لتفريغ البيانات
//            }
//            print("✅ تم مسح جميع بيانات الطلاب من CoreData.")
//        } catch let error {
//            print("❌ فشل في مسح بيانات الطلاب: \(error.localizedDescription)")
//        }
//    }

    
    
}







// view ui
//
//struct StudentView: View {
//    @StateObject var vmStudent = StudentViewModel()
//    @State var textFieldText: String = ""
//    @State var selectedStudent: StudentInfo?
//    @State var updatedName: String = ""
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                TextField("Add name of teacher", text: $textFieldText)
//                    .font(.headline)
//                    .frame(height: 55)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(5)
//                    .padding()
//
//                Button(action: {
//                    
//                    
//                    guard !textFieldText.isEmpty else { return }
//                   // vmStudent.addStudentName(text: textFieldText)
//                    textFieldText = ""
//                    
//                    
//                }, label: {
//                    Text("Add Student")
//                })
//
//                List {
//                    ForEach(vmStudent.savedEntities) { entity in
//                        HStack {
//                            if selectedStudent == entity {
//                                TextField("Update name", text: $updatedName, onCommit: {
//                                    vmStudent.updateStudentInfo(entity: entity, with: updatedName)
//                                    selectedStudent = nil
//                                })
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                            }
//                            
//                            else {
//                                Text(entity.name ?? "no name")
//                                    .onTapGesture {
//                                        selectedStudent = entity
//                                        updatedName = entity.name ?? ""
//                                    }
//                            }
//                        }
//                    }
//                    .onDelete(perform: vmStudent.deleteStudentInfo)
//                }
//            }
//            .navigationTitle("Student")
//        }
//    }
//}
//
//#Preview {
//    StudentView()
//}
//
