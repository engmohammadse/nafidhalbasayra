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
//    @State private var city: String
    @State private var level: String
    @State private var size: String
    
    @State private var messageOfError = ""
    @State private var alertInternetMessage = ""

    
//    @State var  showAlert = false

    var isFormValid: Bool {
        return !name.isEmpty &&
               !phoneNumber.isEmpty &&
               !age.isEmpty &&
               level != "اختر" &&
               size != "اختر"
    }
    @State private var alertType2: AlertType2?  // نوع التنبيه

    @State private var itemsLectured = ["الابتدائية", "المتوسطة", "الإعدادية"]
    
    @State private var sizes = ["صغير (S)", "متوسط (M)", "كبير (L)"]

    // Initializer to assign values to state variables
    init(student: StudentInfo, teacherData: TeacherDataViewModel) {
        self.student = student
       // self.teacherData = teacherData
        _name = State(initialValue: student.name ?? "")
        _phoneNumber = State(initialValue: student.phoneNumber ?? "")
        _age = State(initialValue: student.age ?? "")
//        _city = State(initialValue: student.city ?? "اختر")
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
                    FormFieldNumber(label: "رقم الهاتف", text: $phoneNumber)
                    FormFieldNumber(label: "العمر", text: $age)

//                    DropdownField(label: "المحافظة", selectedOption: $city, options: itemsProvince)
                    DropdownField(label: "المرحلة", selectedOption: $level, options: itemsLectured)
                    DropdownField(label: "القياس", selectedOption: $size, options: sizes)
                }
                .padding(.horizontal, screenWidth * 0.09)
            }

            // زر الحفظ
            
            Button(action: {
                
                InternetChecker.isInternetAvailable { isAvailable in
                    
                    if isAvailable {
                        
                        if isFormValid {
                       
                            // استدعاء دالة التحديث في API
                            var updatedStudent = student
                            updatedStudent.name = name
                            updatedStudent.phoneNumber = phoneNumber
                            updatedStudent.age = age
                            updatedStudent.level = level
                            updatedStudent.size = size
                            
                            
                           
                          
                            
                            StudentUpdater.updateStudent(student: updatedStudent) { success, statusCode, message in
                                DispatchQueue.main.async {
                                    if success {
                                        // تحديث بيانات الطالب محليًا فقط إذا نجح التحديث في API
                                        DispatchQueue.main.async {
                                            vmStudent.updateStudentInfo(entity: student, with: name, with: phoneNumber, with: age, with: level, with: size)
                                            
                                            alertType2 = .success
                                        }
                                        
                                    } else {
                                        messageOfError = " \(statusCode) رمز الحالة\n  ❌ فشل التعديل: \(message ?? "خطأ غير معروف") "
                                        alertType2 = .typeError
                                    }
                                }
                            }

                            
                        } else {
                            alertType2 = .error
                            
                        }
                    }
                    else {
                        alertInternetMessage = "يجب توفر اتصال بالإنترنت لتنفيذ عملية التعديل."
                        alertType2 = .internetError
                    }
                    
                }
                
             

              
            }) {
                Text("حفظ بيانات الطالب")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                    .foregroundStyle(.white)
                    .frame(width: screenWidth * 0.85)
                    .frame(height: screenHeight * 0.05)
                    .background(Color(red: 27/255, green: 62/255, blue: 94/255))
                    .cornerRadius(5)
            }
            .alert(item: $alertType2) { type in
                           switch type {
                           case .success:
                               return Alert(
                                   title: Text("تم الحفظ"),
                                   message: Text("تم حفظ بيانات الطالب بنجاح!"),
                                   dismissButton: .default(Text("حسناً")) {
                                       
                                       dismiss()

                                   }
                               )
                           case .error:
                               return Alert(
                                   title: Text("خطأ"),
                                   message: Text("يرجى ملء جميع الحقول قبل الحفظ."),
                                   dismissButton: .default(Text("حسناً")) {
                                       
                                       dismiss()

                                   }
                               )
                           case .typeError:
                               return Alert(
                                   title: Text("خطأ"),
                                   message: Text("\(messageOfError)"),
                                   dismissButton: .default(Text("حسناً")) {
                                       
                                       dismiss()

                                   }
                               )
                           case .internetError:
                               return Alert(
                                   title: Text("خطأ"),
                                   message: Text("\(alertInternetMessage)"),
                                   dismissButton: .default(Text("حسناً")) {
                                       
                                       dismiss()

                                   }
                               )
                           }
                       }
            
            
            
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



// تعريف نوع التنبيه
enum AlertType2: Identifiable {
    case success
    case error
    case typeError
    case internetError
    
    var id: Int {
        switch self {
        case .success: return 1
        case .error: return 2
        case .typeError: return 3
        case .internetError: return 4
        }
    }
}




#Preview {
    EditStudentAtStudentDataSection(student: StudentInfo(), teacherData: TeacherDataViewModel())
}
