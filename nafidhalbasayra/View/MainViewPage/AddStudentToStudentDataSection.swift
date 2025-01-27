//
//  AddStudentToAttendaceHistory.swift
//  nafidhalbasayra
//
//  Created by muhammad on 17/10/2024.
//


import SwiftUI

struct AddStudentToStudentDataSection: View {
    
    @EnvironmentObject var vmStudent: StudentViewModel
    @State var selectedStudent: StudentInfo?
    @EnvironmentObject var teacherData: TeacherDataViewModel
    @State var updatedName: String = ""

    @Environment(\.dismiss) var dismiss
    
    @State var phoneNumber: String = ""
    @State var city: String = "اختر"
    @State var name: String = ""
    @State var age: String = ""
    @State var level: String = "اختر"
    @State var size: String = "اختر"
    
    @State var showAlert = false

    
    @State private var itemsProvince = [
        "بغداد",
        "النجف الأشرف",
        "ميسان",
        "ذي قار",
        "كربلاء المقدسة",
        "الديوانية",
        "كركوك",
        "بابل",
        "المثنى",
        "صلاح الدين",
        "واسط",
      ]
    @State private var itemsLectured = ["الابتدائية", "المتوسطة", "الإعدادية"]
    
    @State private var sizes = ["صغير جدًا (XS)", "صغير (S)", "متوسط (M)", "كبير (L)", "كبير جدًا (XL)", "ضخم (XXL)"]
    
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
                    
                    DropdownField(label: "المحافظة", selectedOption: $city, options: itemsProvince)
                    DropdownField(label: "المرحلة", selectedOption: $level, options: itemsLectured)
                   
                    DropdownField(label: "القياس", selectedOption: $size, options: sizes)
                }
                .padding(.horizontal, screenWidth * 0.09)
            }
          
   
            
           
            .ignoresSafeArea(edges: .bottom)
            .navigationBarBackButtonHidden(true)
          
            
            
            // button
            Button(action: {
                
                guard !name.isEmpty else { return }
                vmStudent.addStudentInfo(name: name, phoneNumber: phoneNumber, age: age, city: city, level: level, size: size)
                
                name = ""
                phoneNumber = ""
                age = ""
                city = ""
                level = ""
                size = ""
                
                showAlert = true
                
                
            }){
                Text("حفظ بيانات الطالب")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                    .foregroundStyle(.white)
                    .frame(width: screenWidth * 0.85)
                    .frame(height: screenHeight * 0.05)
                    .background(Color(red: 27/255, green: 62/255, blue: 94/255))
                    .cornerRadius(5)
            }
            .alert(isPresented: $showAlert) {
                Alert( title: Text("تم الحفظ"),
                       message: Text("تم حفظ بيانات الطالب بنجاح!"),
                       dismissButton: .default(Text("موافق")) {
                    //dismiss() // Dismiss the view after saving
                } ) }
            
            
            
    
            
          
            
            
            
            
            
        }
        .padding(.bottom)
         .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        //.background(Color.clear)
        .navigationBarBackButtonHidden(true)
//        .overlay {
//            LogoIUserInfo()
//                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
//        }
        
        
        .overlay{
            ZStack{
                Button(action: {
                    
                    dismiss()
                }) {
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
    AddStudentToStudentDataSection( )
        .environmentObject(TeacherDataViewModel())
}
