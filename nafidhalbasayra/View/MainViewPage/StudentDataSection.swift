//
//  AttendanceHistorySection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 16/10/2024.
//

import SwiftUI

struct StudentDataSection: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vmStudent = StudentViewModel()
    
    var body: some View {
       
        VStack{
            HStack{
                
                Text("عدد طلاب الدورة: \(vmStudent.savedEntities.count)")
                    .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                    .padding(.all, screenWidth * 0.025)
            }
            .background(.white)
            .cornerRadius(5)
            .offset(x: screenWidth * 0.25 ,y: screenHeight * 0.05)
            
            Spacer()
                .frame(height: screenHeight * 0.07)
            
            ScrollView {
                ForEach(Array(vmStudent.savedEntities.enumerated()), id: \.element) { index, entity in
                    studentInfo(vmStudent: vmStudent, name: entity.name ?? "لا يوجد اسم", age: entity.age ?? "no", phoneNumber: entity.phoneNumber ?? "no number", student: entity, orderNumber: index + 1)
                }
                
                
                
            }
            .frame(maxWidth: .infinity)
            
            
            Button(action: {}){
                NavigationLink(destination: AddStudentToStudentDataSection().environmentObject(vmStudent)){
                    Text("تسجيل بيانات طالب جديد")
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                        .foregroundStyle(.white)
                        .frame(width: screenWidth * 0.85)
                        .frame(height: screenHeight * 0.05)
                        .background(Color(red: 27/255, green: 62/255, blue: 94/255))
                        .cornerRadius(5)
                    
                }
            }
           
            
            
            
        }
        .padding()
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        .overlay{
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.0 : screenHeight * 0)
             
        }
    
        
        
        
        .overlay{
            ZStack{
                Button(action: {
                    dismiss()
                }) {
                    Image("Group 56")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiDevicePhone ? screenWidth * 0.09 : screenWidth * 0.064)
                }
                .offset(x: screenWidth * 0.46, y: screenHeight * -0.03)
            }
        }
        
        .navigationBarBackButtonHidden(true)
        
            
        
    }
}

#Preview {
    StudentDataSection()
}












struct studentInfo :View {
    
    @ObservedObject var vmStudent = StudentViewModel()
  //  @State var selectedStudent: StudentInfo?
    @State var updatedName: String = ""
    
    var name: String
    var age: String
    var phoneNumber: String
    var student: StudentInfo // إضافة هذا المتغير للإشارة إلى الكائن الحالي
    var orderNumber: Int
    
    var body: some View {
        
        
        
          VStack {
              Color.clear
                 
              
              VStack {
                      
                      HStack{
                          
                          VStack{
                              Text("المرحلة")
                                  .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                              Spacer()
                                  
                                  .frame(height: screenHeight * 0.02)
                              Text("الاولى")
                                  .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023 ))
                              
                              
                          }
                          Spacer()
                              .frame(width: screenWidth * 0.2)
                          
                          VStack{
                              Text("العمر")
                                  .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                              Spacer()
                                  .frame(height: screenHeight * 0.02)
                              Text("١٢ سنة")
                                  .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023 ))
                          }
                          
                          
                          Spacer()
                              .frame(width: screenWidth * 0.1)
                          
                          VStack{
                              Text("اسم الطالب")
                                  .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                              Spacer()
                                  .frame(height: screenHeight * 0.02)
                              
                     
                           
                              
                              
                              Text(name)
                                  .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))

                              Text(phoneNumber)
                              Text(age)
                          }
   
                      }
                      
                      HStack(spacing: 0) {
                                 // First half with red background
                                 ZStack {
                                     Color(red: 228/255, green: 194/255, blue: 194/255)
                                     
                                     
                                     Button(action: {
                                         if let index = vmStudent.savedEntities.firstIndex(of: student) {
                                             vmStudent.deleteStudentInfo(indexSet: IndexSet(integer: index))
                                         }
                                     }) {
                                         Text("حذف بيانات الطالب")
                                             .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023))
                                             .foregroundColor(Color(red: 123/255, green: 42/255, blue: 42/255))
                                             .padding(.all, screenWidth * 0.02)
                                     }


                                     
                                 }
                                 
                                 .frame(maxWidth: .infinity) // Takes up half of the HStack width
                          
                                 
                                 // Second half with blue background
                                 ZStack {
                                     Color(red: 223/255, green: 239/255, blue: 242/255)
                                     
                                     Button(action: {}){
                                         Text("تعديل البيانات")
                                             .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.035 : screenWidth * 0.023 ))
                                             .foregroundColor(Color(red: 24/255, green: 82/255, blue: 100/255))
                                             .padding(.all, screenWidth * 0.02)
                                         
                                        
                                         
                                     }
                                     
                                 }
                               
                                 .frame(maxWidth: .infinity) // Takes up half of the HStack width
                             }
                             
                      
                      
                      
              }.padding(.top, screenHeight * 0.025)
                  
              
                  .background(Color.white)
              .cornerRadius(5)
            
          } 
          .frame(width: screenWidth * 0.85)
          .padding(.bottom, screenHeight * 0.01)
          
          
          .overlay{
            //  Image("Group 124")
              Text("\(orderNumber)")
                //  .resizable()
                 // .aspectRatio(contentMode: .fit)
                  .frame(width: screenWidth * 0.06)
                  .offset(y: screenHeight * -0.075)
             
          }
        
        
    }
}
