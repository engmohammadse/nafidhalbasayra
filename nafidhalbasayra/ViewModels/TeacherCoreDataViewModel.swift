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
    let container: NSPersistentContainer
    @Published var savedEntitiesTeacher: [TeacherInfo] = []

    init() {
        container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        fetchTeacherInfo()
    }
    
    
    

    func fetchTeacherInfo() {
        let request = NSFetchRequest<TeacherInfo>(entityName: "TeacherInfo")
        do {
            savedEntitiesTeacher = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching. \(error)")
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
           
           do {
               try container.viewContext.execute(batchDeleteRequest)
               try container.viewContext.save()
               fetchTeacherInfo()
               print("All records in TeacherInfo have been deleted.")
           } catch let error {
               print("Error deleting all records in TeacherInfo: \(error)")
           }
       }
    
    
    

    func saveTeacherData() {
        do {
            try container.viewContext.save()
            fetchTeacherInfo()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    
    
    
    func addTeacherInfoToCoreData(from teacherData: TeacherDataViewModel, with faceImage: Data?, with frontId: Data?, with backId: Data?) {
        // Create a new entity in Core Data
        let newTeacherInfo = TeacherInfo(context: container.viewContext)
        
        // Map values from TeacherDataViewModel to TeacherInfo entity
        newTeacherInfo.name = teacherData.name
        newTeacherInfo.birthDay = teacherData.birthDay
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
        

        // Safely convert phonenumber to Int16
        if let phoneNumber = Int16(teacherData.phonenumber) {
            newTeacherInfo.phonenumber = phoneNumber
        } else {
            newTeacherInfo.phonenumber = 0 // Default value if conversion fails
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
    
   

    
    
    
    
    
    // دالة لطباعة البيانات المخزنة
    func printStoredData() {
        fetchTeacherInfo() // جلب البيانات
        for entity in savedEntitiesTeacher {
            
     

            
            
            print("اسم المعلم: \(entity.name ?? "غير معروف")")
            print("تاريخ الميلاد: \(entity.birthDay ?? Date())")
            print("رقم الهاتف: \(entity.phonenumber)")
            print("المحافظة: \(entity.province ?? "غير مدخلة")")
            print("المدينة: \(entity.city ?? "غير مدخلة")")
            print("رقم المدينة: \(entity.citynumber )")
            print("هل قام بالتدريس: \(entity.didyoutaught ? "نعم" : "لا")")
            print("اسم المسجد: \(entity.mosquname ?? "غير مدخل")")
            print("المستوى الأكاديمي: \(entity.academiclevel ?? "غير مدخل")")
            print("الوظيفة الحالية: \(entity.currentWork ?? "غير مدخلة")")
            print("id teacher: \(String(describing: entity.teacherID))")
            if let imageData = entity.profileimage,
               let image = UIImage(data: imageData) {
                print("الوظيفة الحالية: صورة بحجم \(image.size.width)x\(image.size.height) بكسل")
            } else {
                print("الوظيفة الحالية: غير مدخلة")
            }
 
            print("------------------------------------")
            
            if let imageDataf = entity.frontfaceidentity,
               let imagef = UIImage(data: imageDataf) {
                print("front id image : \(imagef.size.width)x\(imagef.size.height) ")
            } else {
                print("الوظيفة الحالية: غير مدخلة")
            }
            
            print("------------------------------------")
            
            if let imageDatab = entity.frontfaceidentity,
               let imageb = UIImage(data: imageDatab) {
                print("Back id image : \(imageb.size.width)x\(imageb.size.height) ")
            } else {
                print("الوظيفة الحالية: غير مدخلة")
            }
        }
    }
    
}

struct TeacherViewModel: View {
    @StateObject var vmTeacher = CoreDataViewModel()
    @State var textFieldText: String = ""
    @State var selectedTeacher: TeacherInfo?
    @State var updatedName: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Add name of teacher", text: $textFieldText)
                    .font(.headline)
                    .frame(height: 55)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    .padding()

                Button(action: {
                    
                    
                    guard !textFieldText.isEmpty else { return }
                    vmTeacher.addTeacherInfo(text: textFieldText)
                    textFieldText = ""
                    
                    
                }, label: {
                    Text("Add Teacher")
                })

                List {
                    ForEach(vmTeacher.savedEntitiesTeacher) { entity in
                        HStack {
                            if selectedTeacher == entity {
                                TextField("Update name", text: $updatedName, onCommit: {
                                    vmTeacher.updateTeacherInfo(entity: entity, with: updatedName)
                                    selectedTeacher = nil
                                })
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            else {
                                Text(entity.name ?? "no name")
                                    .onTapGesture {
                                        selectedTeacher = entity
                                        updatedName = entity.name ?? ""
                                    }
                            }
                        }
                    }
                    .onDelete(perform: vmTeacher.deleteTeacherInfo)
                }
            }
            .navigationTitle("Teachers")
        }
    }
}

#Preview {
    TeacherViewModel()
}
























// old
//import SwiftUI
//import CoreData
//
//
//
//
//class CoreDataViewModel: ObservableObject {
//    
//    let container: NSPersistentContainer
//    @Published var savedEntities: [TeacherInfo] = []
//    
//    init() {
//        container = NSPersistentContainer(name: "TeacherInfo")
//        container.loadPersistentStores { (description, error) in
//            
//            if let error = error {
//                print("ERROR LOADING CORE DATA. \(error)")
//            }
//            
//        }
//        fetchTeacherInfo()
//    }
//    
//    //
//    func fetchTeacherInfo() {
//        let request = NSFetchRequest<TeacherInfo>(entityName: "TeacherInfo")
//        
//        do {
//            savedEntities = try container.viewContext.fetch(request)
//        }
//        catch let error {
//            print("Error Fetching. \(error)")
//        }
//        
//    }
//    
//    //
//    func addTeacherInfo(text: String) {
//        let newTeacherInfo = TeacherInfo(context: container.viewContext)
//        newTeacherInfo.name = text
//        saveTeacherData()
//    }
//    
//    
//    func updateTeacherInfo(entity: TeacherInfo) {
//        
//        let currentName = entity.name ?? ""
//        let newName = currentName + "!"
//        entity.name = newName
//        saveTeacherData()
//        
//    }
//    
//    
//    
//    //
//    func deleteTeacherInfo(indexSet: IndexSet) {
//        
//        guard let index = indexSet.first else { return }
//        let entity = savedEntities[index]
//        container.viewContext.delete(entity)
//        saveTeacherData()
//        
//    }
//    
//    
//    
//    
//    
//    //
//    func saveTeacherData() {
//        do {
//             try  container.viewContext.save()
//             fetchTeacherInfo()
//            
//        } catch let error {
//            print("Error saving. \(error)")
//        }
//    }
//    
//    
//    
//    
//}
//
//
//
//
//struct ContentView: View {
//    //@Environment(\.managedObjectContext) private var viewContext
//    @StateObject var vm  = CoreDataViewModel()
//    @State var textFieldText: String = ""
//    
//    
//    //
//    @State var selectedTeacher: TeacherInfo?
//    @State var updatedName: String = ""
//
// 
//    var body: some View {
//        NavigationView {
//            
//            VStack{
//                TextField("Add name of teacher", text: $textFieldText)
//                    .font(.headline)
//                    .frame(height: 55)
//                    .background(.gray)
//                    .cornerRadius(5)
//                    .padding()
//                
//                
//                Button(action: {
//                    
//                    
//                    guard !textFieldText.isEmpty else {return}
//                    vm.addTeacherInfo(text: textFieldText)
//                    textFieldText = ""
//                    
//                }, label: {
//                    Text("Button")
//                })
//                
//                
//                List {
//                    ForEach(vm.savedEntities) { entity in
//                        
//                        Text(entity.name ?? "no name ")
//                            .onTapGesture {
//                                vm.updateTeacherInfo(entity: entity)
//                            }
//                    }
//                    .onDelete(perform: vm.deleteTeacherInfo)
//                }
//                
//            }
//            .navigationTitle("teacher")
//           
//        }
//        
//    }
//
//
//}
//
//
//#Preview {
//    ContentView()
//   
//}
