//
//  AddStudentToAttendaceHistory.swift
//  nafidhalbasayra
//
//  Created by muhammad on 17/10/2024.
//


import SwiftUI

struct AddStudentToAttendaceHistory: View {
    @State var phoneNumber: String = ""
    @State var province: String = "اختر"
    @State var name: String = ""
    @State var age: String = ""
    @State var level: String = ""
    @State var size: String = ""
    @State var isLectured: String = "اختر"
    
    @State private var itemsProvince = ["مركز المدينة", "النجف", "Option 3", "Option 4"]
    @State private var itemsLectured = ["لا","نعم"]
    
    var body: some View {
        VStack {
            
            
                
                Text("اضافة طالب جديد")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.045 : screenWidth * 0.023 ))
                    .foregroundStyle(primaryColor)
                   
          
         
            .cornerRadius(5)
            .offset(x: 0 ,y: screenHeight * 0.07)
            
            Spacer()
                .frame(height: screenHeight * 0.07)
            
            ScrollView {
                VStack(spacing: 16) {
                    Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.05  : screenHeight * 0.10)

                    FormField(label: "الأسم الثلاثي", text: $name)
                    FormField(label: "رقم الهاتف", text: $phoneNumber, isPhoneNumber: true)
                    FormField(label: "العمر", text: $age)
                    
                    DropdownField(label: "المحافظة", selectedOption: $province, options: itemsProvince)
                    DropdownField(label: "المحاضرة", selectedOption: $isLectured, options: itemsLectured)
                   
                    DropdownField(label: "القياس", selectedOption: $isLectured, options: itemsLectured)
                }
                .padding(.horizontal, screenWidth * 0.09)
            }
          
   
            
           
            .ignoresSafeArea(edges: .bottom)
            .navigationBarBackButtonHidden(true)
          
            
            
            // button
            Button(action: {}){
                Text("حفظ بيانات الطالب")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                    .foregroundStyle(.white)
                    .frame(width: screenWidth * 0.85)
                    .frame(height: screenHeight * 0.05)
                    .background(Color(red: 27/255, green: 62/255, blue: 94/255))
                    .cornerRadius(5)
            }
            
        }
        .padding(.bottom)
         .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        //.background(Color.clear)
        .navigationBarBackButtonHidden(true)
        .overlay {
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
        }
        
        
        .overlay{
            ZStack{
                Button(action: {}) {
                    Image("Group 56")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.064)
                }
                .offset(x: screenWidth * 0.46, y: screenHeight * -0.03)
            }
        }
        
        
        
    }
}


#Preview {
    AddStudentToAttendaceHistory()
}
