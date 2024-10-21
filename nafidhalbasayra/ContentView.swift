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
    @Published var savedEntities: [TeacherInfo] = []

    init() {
        container = NSPersistentContainer(name: "TeacherInfo")
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
            savedEntities = try container.viewContext.fetch(request)
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
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveTeacherData()
    }

    func saveTeacherData() {
        do {
            try container.viewContext.save()
            fetchTeacherInfo()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
}

struct ContentView: View {
    @StateObject var vm = CoreDataViewModel()
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
                    vm.addTeacherInfo(text: textFieldText)
                    textFieldText = ""
                    
                    
                }, label: {
                    Text("Add Teacher")
                })

                List {
                    ForEach(vm.savedEntities) { entity in
                        HStack {
                            if selectedTeacher == entity {
                                TextField("Update name", text: $updatedName, onCommit: {
                                    vm.updateTeacherInfo(entity: entity, with: updatedName)
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
                    .onDelete(perform: vm.deleteTeacherInfo)
                }
            }
            .navigationTitle("Teachers")
        }
    }
}

#Preview {
    ContentView()
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
