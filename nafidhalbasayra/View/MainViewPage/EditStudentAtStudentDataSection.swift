//
//  EditStudentAtStudentDataSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 06/11/2024.
//

import SwiftUI

struct EditStudentAtStudentDataSection: View {
    @EnvironmentObject var vmStudent: StudentViewModel
    @EnvironmentObject var teacherData: TeacherDataViewModel
    var student: StudentInfo // استلام الطالب المحدد

    @Environment(\.dismiss) var dismiss

    @State private var name: String
    @State private var phoneNumber: String
    @State private var age: String
    @State private var city: String
    @State private var level: String
    @State private var size: String
    
    @State var  showAlert = false

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

    // Initializer to assign values to state variables
    init(student: StudentInfo, teacherData: TeacherDataViewModel) {
        self.student = student
       // self.teacherData = teacherData
        _name = State(initialValue: student.name ?? "")
        _phoneNumber = State(initialValue: student.phoneNumber ?? "")
        _age = State(initialValue: student.age ?? "")
        _city = State(initialValue: student.city ?? "اختر")
        _level = State(initialValue: student.level ?? "اختر")
        _size = State(initialValue: student.size ?? "اختر")
    }

    var body: some View {
        VStack {
            Text("تعديل بيانات الطالب")
                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.045 : screenWidth * 0.023))
                .foregroundStyle(primaryColor)
                .offset(x: 0, y: screenHeight * 0.07)

            Spacer().frame(height: screenHeight * 0.07)

            ScrollView {
                VStack(spacing: 16) {
                    Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.05 : screenHeight * 0.10)

                    FormField(label: "الأسم الثلاثي", text: $name)
                    FormField(label: "رقم الهاتف", text: $phoneNumber, isPhoneNumber: true)
                    FormField(label: "العمر", text: $age)

                    DropdownField(label: "المحافظة", selectedOption: $city, options: itemsProvince)
                    DropdownField(label: "المرحلة", selectedOption: $level, options: itemsLectured)
                    DropdownField(label: "القياس", selectedOption: $size, options: sizes)
                }
                .padding(.horizontal, screenWidth * 0.09)
            }

            // زر الحفظ
            Button(action: {
                guard !name.isEmpty else { return }

                // تحديث بيانات الطالب المحدد
                vmStudent.updateStudentInfo(entity: student, with: name, with: phoneNumber, with: age, with: city, with: level, with: size)

                //dismiss() // اغلاق شاشة التعديل
                
                showAlert = true
                
            }) {
                Text("حفظ بيانات الطالب")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                    .foregroundStyle(.white)
                    .frame(width: screenWidth * 0.85)
                    .frame(height: screenHeight * 0.05)
                    .background(Color(red: 27/255, green: 62/255, blue: 94/255))
                    .cornerRadius(5)
            }
            .alert(isPresented: $showAlert) {
                Alert( title: Text("تم التعديل"),
                       message: Text("تم تعديب بيانات الطالب بنجاح!"),
                       dismissButton: .default(Text("موافق")) {
                    dismiss() // Dismiss the view after saving
                } ) }
            
            
            
            
            
            
        }
        .padding(.bottom)
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        .navigationBarBackButtonHidden(true)
        .overlay {
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
        }
        .overlay {
            ZStack {
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
    EditStudentAtStudentDataSection(student: StudentInfo(), teacherData: TeacherDataViewModel())
}
