//
//  AttendanceHistorySection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 16/10/2024.
//

import SwiftUI

struct AttendanceHistorySection: View {
    var body: some View {
       
        VStack{
            
            ScrollView{
                
                VStack {
                    HStack{
                        
                        VStack{
                            Text("student name")
                            Spacer()
                                .frame(height: screenHeight * 0.02)
                            Text("ahmed name")
                            
                            
                        }
                        
                        VStack{
                            Text("student name")
                            Spacer()
                                .frame(height: screenHeight * 0.02)
                            Text("ahmed name")
                        }
                        
                        VStack{
                            Text("student name")
                            Spacer()
                                .frame(height: screenHeight * 0.02)
                            Text("ahmed name")
                        }
 
                    }
                    
                    HStack(spacing: 0) {
                               // First half with red background
                               ZStack {
                                   Color.red
                                   Text("Left Side")
                                       .foregroundColor(.white)
                               }
                               .frame(maxWidth: .infinity) // Takes up half of the HStack width
                               
                               // Second half with blue background
                               ZStack {
                                   Color.blue
                                   Text("Right Side")
                                       .foregroundColor(.white)
                               }
                               .frame(maxWidth: .infinity) // Takes up half of the HStack width
                           }
                           
                    
                    
                }.background(Color.white)
                    .cornerRadius(5)
                
            }
            
        }.padding()
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
            
        
    }
}

#Preview {
    AttendanceHistorySection()
}
