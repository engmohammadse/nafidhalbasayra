//
//  ContentView.swift
//  nafidhalbasayra
//
//  Created by muhammad on 23/09/2024.
//

import SwiftUI
import CoreData




class CoreDataViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var savedEntities: [TeacherInfo] = []
    
    init() {
        container = NSPersistentContainer(name: "TeacherInfo")
        container.loadPersistentStores { (description, error) in
            
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
            
        }
        fetchTeacherInfo()
    }
    
    //
    func fetchTeacherInfo() {
        let request = NSFetchRequest<TeacherInfo>(entityName: "TeacherInfo")
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        }
        catch let error {
            print("Error Fetching. \(error)")
        }
        
    }
    
    //
    func addTeacherInfo(text: String) {
        let newTeacherInfo = TeacherInfo(context: container.viewContext)
        newTeacherInfo.name = text
        saveData()
    }
    
    //
    func saveData() {
        do {
             try  container.viewContext.save()
             fetchTeacherInfo()
            
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    
}




struct ContentView: View {
    //@Environment(\.managedObjectContext) private var viewContext
    @StateObject var vm  = CoreDataViewModel()
    @State var textFieldText: String = ""

 
    var body: some View {
        NavigationView {
            
            VStack{
                TextField("Add name of teacher", text: $textFieldText)
                    .font(.headline)
                    .frame(height: 55)
                    .background(.gray)
                    .cornerRadius(5)
                    .padding()
                
                
                Button(action: {
                    
                    
                    guard !textFieldText.isEmpty else {return}
                    vm.addTeacherInfo(text: textFieldText)
                    textFieldText = ""
                    
                }, label: {
                    Text("Button")
                })
                
                
                List {
                    ForEach(vm.savedEntities) { entity in
                        
                        Text(entity.name ?? "no name ")
                    }
                }
                
            }
            .navigationTitle("teacher")
           
        }
        
    }


}


#Preview {
    ContentView()
   
}
