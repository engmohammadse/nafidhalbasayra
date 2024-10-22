//
//  nafidhalbasayraApp.swift
//  nafidhalbasayra
//
//  Created by muhammad on 23/09/2024.
//

import SwiftUI

@main
struct nafidhalbasayraApp: App {
  //  let persistenceController = PersistenceController.shared
    @StateObject var teacherData = TeacherDataViewModel()
    
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            
           
            
            NavigationStack{
                
                if showSplash {
                    
                    LoginPage0()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showSplash = false // Hide splash screen after 3 seconds
                                
                                
                                
                            }
                            
                        }
                    
                    
                } else{
                    
                    NavigationStack{
                        
                       
                            LoginPage1()
                        
                       // MainViewPage()
                       // sendAttendaceSection()
                        
                       
                    }
                }
                
                
            }
            
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
