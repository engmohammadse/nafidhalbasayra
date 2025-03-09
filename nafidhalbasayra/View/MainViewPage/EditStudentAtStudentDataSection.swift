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
    @State private var isContentShifted: Bool = false
    @Environment(\.dismiss) var dismiss

    @State private var name: String
    @State private var phoneNumber: String
    @State private var age: String
//    @State private var city: String
    @State private var level: String
    @State private var size: String
    @State private var gender: String
    @State private var academic_level: String
    
    @State private var messageOfError = ""
    @State private var alertInternetMessage = ""
    

    @State private var levelList = ["أولى", "ثانية", "ثالثة"]

    @State private var academic_levelList =  [
        "أول ابتدائي", "ثاني ابتدائي", "ثالث ابتدائي", "رابع ابتدائي",
        "خامس ابتدائي", "سادس ابتدائي", "أول متوسط", "ثاني متوسط", "ثالث متوسط"]

    @State private var sizes = ["صغير ", "متوسط ", "كبير "]
    @State private var genderList =  ["ذكر","انثى"]

    
//    @State var  showAlert = false

    var isFormValid: Bool {
        return !name.isEmpty &&
               phoneNumber.count == 11 &&
               !age.isEmpty &&
               level != "اختر" &&
               size != "اختر" &&
               academic_level != "اختر" &&
               gender != "اختر"
    }
    @State private var alertType2: AlertType2?  // نوع التنبيه

    @State private var itemsLectured = ["الابتدائية", "المتوسطة", "الإعدادية"]
    

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
        _gender = State(initialValue: student.gender ?? "اختر")
        _academic_level = State(initialValue: student.academic_level ?? "اختر")
    }
    
    private var shiftAmount: CGFloat {
          UIDevice.current.userInterfaceIdiom == .pad ? 250 : 230 // 🔹 تخصيص الارتفاع للأيباد والآيفون
      }

    var body: some View {
        VStack (spacing: 12) {
            
            if !isContentShifted {
                Text("تعديل بيانات الطالب")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.045 : screenWidth * 0.023))
                    .foregroundStyle(primaryColor)
                    .offset(x: 0, y: screenHeight * 0.04)

            }
            
           
           // Spacer().frame(height: screenHeight * 0.07)

            ScrollView {
                VStack(spacing: 12) {
                    Spacer()
                        .frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.05 : screenHeight * 0.04)

                    FormField(label: "الأسم الثلاثي", text: $name)
                    FormFieldNumber(label: "رقم الهاتف", text: $phoneNumber)
                    FormFieldAge(label: "العمر", text: $age)
                    DropdownField(label: "الجنس", selectedOption: $gender, options: genderList, isDropdownActive: $isContentShifted)
                    DropdownField(label: "المرحلة", selectedOption: $level, options: levelList, isDropdownActive: $isContentShifted)
                    
                    DropdownField(label: " المرحلة الدراسية", selectedOption: $academic_level, options: academic_levelList, isDropdownActive: $isContentShifted)
                   
                    DropdownField(label: "القياس", selectedOption: $size, options: sizes, isDropdownActive: $isContentShifted)
                }
                .padding(.horizontal, screenWidth * 0.09)
                .offset(y: isContentShifted ? -shiftAmount : 0)
            }
            .animation(.easeInOut, value: isContentShifted)

            // زر الحفظ
            
            Button(action: {
                
                
                
                
                InternetChecker.isInternetAvailable { isAvailable in
                       if isAvailable {
                           if phoneNumber.count != 11 {
                               alertType2 = .errorPhoneNumber // ✅ تنبيه خاص برقم الهاتف
                           } else if isFormValid {
                               // ✅ إذا كانت جميع الحقول صحيحة، نفذ التعديل
                               var updatedStudent = student
                               updatedStudent.name = name
                               updatedStudent.phoneNumber = phoneNumber
                               updatedStudent.age = age
                               updatedStudent.level = level
                               updatedStudent.size = size
                               updatedStudent.gender = gender
                               updatedStudent.academic_level = academic_level

                               StudentUpdater.updateStudent(student: updatedStudent) { success, statusCode, message in
                                   DispatchQueue.main.async {
                                       if success {
                                           vmStudent.updateStudentInfo(entity: student, with: name, with: phoneNumber, with: age, with: level, with: size, with: gender, with: academic_level)
                                           alertType2 = .success
                                       } else {
                                           messageOfError = " \(statusCode) رمز الحالة\n  ❌ فشل التعديل: \(message ?? "خطأ غير معروف") "
                                           alertType2 = .typeError
                                       }
                                   }
                               }
                           } else {
                               alertType2 = .error // ✅ تنبيه نقص البيانات
                           }
                       } else {
                           alertInternetMessage = "يجب توفر اتصال بالإنترنت لتنفيذ عملية التعديل."
                           alertType2 = .internetError
                       }
                   }
                
//                InternetChecker.isInternetAvailable { isAvailable in
//                    
//                    if isAvailable {
//                        
//                        if isFormValid {
//                       
//                            // استدعاء دالة التحديث في API
//                            var updatedStudent = student
//                            updatedStudent.name = name
//                            updatedStudent.phoneNumber = phoneNumber
//                            updatedStudent.age = age
//                            updatedStudent.level = level
//                            updatedStudent.size = size
//                            updatedStudent.gender = gender
//                            updatedStudent.academic_level = academic_level
//                            
//                            
//                           
//                          
//                            
//                            StudentUpdater.updateStudent(student: updatedStudent) { success, statusCode, message in
//                                DispatchQueue.main.async {
//                                    if success {
//                                        // تحديث بيانات الطالب محليًا فقط إذا نجح التحديث في API
//                                        DispatchQueue.main.async {
//                                            vmStudent.updateStudentInfo(entity: student, with: name, with: phoneNumber, with: age, with: level, with: size, with: gender, with: academic_level)
//                                            
//                                            alertType2 = .success
//                                        }
//                                        
//                                    } else {
//                                        messageOfError = " \(statusCode) رمز الحالة\n  ❌ فشل التعديل: \(message ?? "خطأ غير معروف") "
//                                        alertType2 = .typeError
//                                    }
//                                }
//                            }
//
//                            
//                        } else {
//                            alertType2 = .error
//                            
//                        }
//                    }
//                    else {
//                        alertInternetMessage = "يجب توفر اتصال بالإنترنت لتنفيذ عملية التعديل."
//                        alertType2 = .internetError
//                    }
//                    
//                }
                
             

              
            }) {
                Text("حفظ بيانات الطالب")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                    .foregroundStyle(.white)
                    .frame(width: screenWidth * 0.85)
                    .frame(height: screenHeight * 0.04)
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
                                     

                                   }
                               )
                           case .typeError:
                               return Alert(
                                   title: Text("خطأ"),
                                   message: Text("\(messageOfError)"),
                                   dismissButton: .default(Text("حسناً")) {
                                       
                                     

                                   }
                               )
                           case .internetError:
                               return Alert(
                                   title: Text("خطأ"),
                                   message: Text("\(alertInternetMessage)"),
                                   dismissButton: .default(Text("حسناً")) {
                                       
                                    

                                   }
                               )
                           case .errorPhoneNumber:
                                  return Alert(
                                      title: Text("خطأ في رقم الهاتف"),
                                      message: Text("يجب أن يتكون رقم الهاتف من 11 رقمًا."),
                                      dismissButton: .default(Text("حسنًا"))
                                  )
                              }
                
                       }
            
            
            
        }
        .padding(.bottom)
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        .navigationBarBackButtonHidden(true)
//        .overlay {
//            LogoIUserInfo()
//                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
//        }
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
                .offset(x: uiDevicePhone ? screenWidth * 0.46 : screenWidth * 0.47, y: screenHeight * -0.03)
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
    case errorPhoneNumber
    
    var id: Int {
        switch self {
        case .success: return 1
        case .error: return 2
        case .typeError: return 3
        case .internetError: return 4
        case .errorPhoneNumber: return 5
        }
    }
}




#Preview {
    EditStudentAtStudentDataSection(student: StudentInfo(), teacherData: TeacherDataViewModel())
}
