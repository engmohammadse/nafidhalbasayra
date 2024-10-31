//
//  StudentViewModel.swift
//  nafidhalbasayra
//
//  Created by muhammad on 31/10/2024.
//


import SwiftUI
import CoreData

class StudentViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedEntities: [StudentInfo] = []

    init() {
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
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching. \(error)")
        }
    }

    func addStudentInfo(text: String) {
        let newStudentInfo = StudentInfo(context: container.viewContext)
        newStudentInfo.name = text
        saveStudentData()
    }

    func updateStudentInfo(entity: StudentInfo, with newName: String) {
        entity.name = newName
        saveStudentData()
    }

    func deleteStudentInfo(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveStudentData()
    }

    func saveStudentData() {
        do {
            try container.viewContext.save()
            fetchStudentInfo()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
}

struct StudentView: View {
    @StateObject var vmStudent = StudentViewModel()
    @State var textFieldText: String = ""
    @State var selectedStudent: StudentInfo?
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
                    vmStudent.addStudentInfo(text: textFieldText)
                    textFieldText = ""
                    
                    
                }, label: {
                    Text("Add Student")
                })

                List {
                    ForEach(vmStudent.savedEntities) { entity in
                        HStack {
                            if selectedStudent == entity {
                                TextField("Update name", text: $updatedName, onCommit: {
                                    vmStudent.updateStudentInfo(entity: entity, with: updatedName)
                                    selectedStudent = nil
                                })
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            else {
                                Text(entity.name ?? "no name")
                                    .onTapGesture {
                                        selectedStudent = entity
                                        updatedName = entity.name ?? ""
                                    }
                            }
                        }
                    }
                    .onDelete(perform: vmStudent.deleteStudentInfo)
                }
            }
            .navigationTitle("Student")
        }
    }
}

#Preview {
    StudentView()
}

