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
    @State private var isContentShifted: Bool = false


    @Environment(\.dismiss) var dismiss
    
    @State var phoneNumber: String = ""
//    @State var city: String = "اختر"
    @State var name: String = ""
    @State var age: String = ""
    @State var level: String = "اختر"
    @State var size: String = "اختر"
    @State var gender: String = "اختر"
    @State var academic_level: String = "اختر"

    
    @State private var alertType: AlertType?  // نوع التنبيه
    @State private var itemsLectured = ["الابتدائية", "المتوسطة", "الإعدادية"]
    @State private var levelList = ["أولى", "ثانية", "ثالثة"]

    @State private var academic_levelList =  [
        "أول ابتدائي", "ثاني ابتدائي", "ثالث ابتدائي", "رابع ابتدائي",
        "خامس ابتدائي", "سادس ابتدائي", "أول متوسط", "ثاني متوسط", "ثالث متوسط"]

    @State private var sizes = ["صغير ", "متوسط ", "كبير "]
    @State private var genderList =  ["ذكر","انثى"]
    
    var isFormValid: Bool {
        return !name.isEmpty &&
               phoneNumber.count == 11 &&
               !age.isEmpty &&
               level != "اختر" &&
               //size != "اختر" &&
               academic_level != "اختر" &&
               gender != "اختر" 
        
    }
    private var shiftAmount: CGFloat {
          UIDevice.current.userInterfaceIdiom == .pad ? 250 : 230 // 🔹 تخصيص الارتفاع للأيباد والآيفون
      }
    
    var body: some View {
        VStack (spacing: 0) {
            
            
            if !isContentShifted {
                Text("اضافة طالب جديد")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.045 : screenWidth * 0.023 ))
                    .foregroundStyle(primaryColor)
                    .cornerRadius(5)
                    .offset(x: 0, y: screenHeight * 0.04)
            }
//            
//            Spacer()
//                .frame(height: screenHeight * 0.001)
            
            ScrollView {
                VStack(spacing: 12) {
                    Spacer()
                        .frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.05  : screenHeight * 0.04)

                    FormField(label: "الأسم الثلاثي", text: $name)
                    FormFieldNumber(label: "رقم الهاتف", text: $phoneNumber)
                    FormFieldAge(label: "العمر", text: $age)
                    DropdownField(label: "الجنس", selectedOption: $gender, options: genderList, isDropdownActive: $isContentShifted)
                    DropdownField(label: "المرحلة", selectedOption: $level, options: levelList, isDropdownActive: $isContentShifted)
                    
                    DropdownField(label: "المرحلة الدراسية", selectedOption: $academic_level, options: academic_levelList, isDropdownActive: $isContentShifted)
                   
                    //DropdownField(label: "القياس", selectedOption: $size, options: sizes, isDropdownActive: $isContentShifted)
                }
                .padding(.horizontal, screenWidth * 0.09)
                .offset(y: isContentShifted ? -shiftAmount : 0) // 🔹 تحريك جميع العناصر عند فتح أي قائمة

            }
            .animation(.easeInOut, value: isContentShifted)
            .scrollIndicators(.hidden) // ✅ إخفاء شريط التمرير

   
            
           
//            .ignoresSafeArea(edges: .bottom)
            .navigationBarBackButtonHidden(true)
          
            
            
            // button
            Button(action: {
                
                
                if phoneNumber.count != 11 {
                        alertType = .errorPhoneNumber // ✅ تنبيه خاص برقم الهاتف
                    } else if isFormValid {
                        // ✅ إذا كانت جميع الحقول صحيحة، احفظ البيانات
                        vmStudent.addStudentInfo(
                            name: name, phoneNumber: phoneNumber, age: age,
                            level: level, size: size, gender: gender,
                            academic_level: academic_level, state: 0, idFromApi: ""
                        )
                        
                        alertType = .success // ✅ تنبيه النجاح
                        // إعادة تعيين الحقول بعد الحفظ
                        name = ""
                        phoneNumber = ""
                        age = ""
                        level = "اختر"
                        size = "اختر"
                        academic_level = "اختر"
                        
                      
                    } else {
                        alertType = .error // ✅ تنبيه نقص البيانات
                    }
//
                

                
                
            }){
                Text("حفظ بيانات الطالب")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023 ))
                    .foregroundStyle(.white)
                    .frame(width: screenWidth * 0.85)
                    .frame(height: screenHeight * 0.04)
                    .background(Color(red: 27/255, green: 62/255, blue: 94/255))
                    .cornerRadius(5)
            }
            .alert(item: $alertType) { type in
                           switch type {
                           case .success:
                               return Alert(
                                   title: Text("تم الحفظ"),
                                   message: Text("تم حفظ بيانات الطالب بنجاح!"),
                                   dismissButton: .default(Text("موافق"))
                                   {
                                       dismiss()
                                   }
                                  
                               )
                           case .error:
                               return Alert(
                                   title: Text("خطأ"),
                                   message: Text("يرجى ملء جميع الحقول قبل الحفظ."),
                                   dismissButton: .default(Text("حسناً"))
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
        //.background(Color.clear)
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            hideKeyboardExplicitly()
        }

//        .onAppear {
//            self.addKeyboardObservers()
//        }
//        .onDisappear {
//            self.removeKeyboardObservers()
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
                .offset(x: uiDevicePhone ? screenWidth * 0.46 : screenWidth * 0.47, y: screenHeight * -0.03)
            }
        }
        
        
       
        
    }
    
    

}




// تعريف نوع التنبيه
enum AlertType: Identifiable {
    case success
    case error
    case errorPhoneNumber
    
    var id: Int {
        switch self {
        case .success: return 1
        case .error: return 2
        case .errorPhoneNumber: return 3
        }
    }
}



//#Preview {
//    AddStudentToStudentDataSection( )
//        .environmentObject(TeacherDataViewModel())
//}
