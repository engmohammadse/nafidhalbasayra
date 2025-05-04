//
//  sendAttendaceSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 14/10/2024.
//
// new

import Foundation 
import SwiftUI
import CoreLocation





struct sendAttendanceSection: View {
    
    
    
    @StateObject private var locationManager = LocationManager()
    @State private var numberOfStudents: String = ""
    @State private var imageData: UIImage? = nil
    @State private var notes: String = ""
    @State private var showAlert = false
    @State private var showImagePicker = false
    @State private var isPressed: Bool = false
    @State private var isSendingLocation: Bool = false
    @State private var isSendingImageData: Bool = false
    
    
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vmAttendaceStatus: AttendaceStatusViewModel
    @EnvironmentObject var teacherData: TeacherDataViewModel
    @EnvironmentObject var studentViewModel: StudentViewModel // ✅ الوصول إلى بيانات الطلاب
    var maxStudentsAllowed = 60 // الحد الأقصى المسموح به للطلاب
    
    
    @State private var debounceTask: DispatchWorkItem?
    
    
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    
    // ✅ متغير للتحقق من صحة النموذج
    private var isFormValid: Bool {
        return !numberOfStudents.isEmpty &&
        Int(numberOfStudents) != nil &&
        imageData != nil &&
        locationManager.location != nil
    }
    
    
      
    
    private func debounceValidation(newValue: String) {
        // إلغاء أي عملية تحقق سابقة
        debounceTask?.cancel()
        
        // إنشاء مهمة جديدة
        debounceTask = DispatchWorkItem { [newValue] in
            // ✅ السماح فقط بالأرقام الإنجليزية
            let filteredNumber = newValue.filter { "0123456789".contains($0) }
            
            // ✅ تحديث القيمة بعد التصفية
            numberOfStudents = filteredNumber
        }
        
        // تنفيذ المهمة بعد تأخير (لتجنب التحديث مع كل حرف يتم إدخاله)
        if let task = debounceTask {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
        }
    }
    
    
    
    var body: some View {
        
        
        
        
        VStack {
            ScrollView {
                
                //                    Color.clear
                //                        .frame(height: 1)
                //                        .frame(maxWidth: screenWidth * 2)
                
                
                VStack {
                    Spacer().frame(height: uiDevicePhone ? screenHeight * 0.07 : screenHeight * 0.09 )
                    HStack {
                        VStack {
                            Image("Group 46")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
                            
                            Text("تثبيت الموقع الحالي")
                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
                        }
                        
                        Spacer().frame(width: uiDevicePhone ? screenWidth * 0.06 : screenWidth * 0.04)
                        
                        VStack {
                            HStack {
                                Spacer().frame(width: screenWidth * 0.2)
                                Image("Group 124")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.04)
                            }
                            
                            Text("يرجى الذهاب لمكان مفتوح\n قبل الضغط على زر تثبيت\n الموقع.")
                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025))
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    Button(action: {
                        
                        
                        locationManager.requestLocation()
                        
                        isSendingLocation = true
                        
                        
                    }) {
                        Text(isSendingLocation ? "تم تثبيت الموقع" : "تثبيت")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025))
                            .frame(height: screenHeight * 0.04)
                            .foregroundColor(.white)
                            .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
                    }
                    .background(isSendingLocation ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                    .cornerRadius(5)
                    
                    
                    
                }
                
                
                Spacer()
                    .frame(height: screenHeight * 0.035)
                
                
                if let locationError = locationManager.locationError {
                    Text(locationError)
                        .foregroundColor(.red)
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025))
                }
                
                
                
                VStack {
                    HStack {
                        VStack {
                            HStack {
                                Image("Group 125")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.04)
                                    .offset(x: uiDevicePhone ? 0 : screenWidth * 0.04)
                                Spacer().frame(width: screenWidth * 0.28)
                            }
                            
                            Text("يرجى ادخال عدد الطلبة\n الحاضرين بدقة، وقبل ذلك\n تأكد من تسجيل بيانات\n جميع طلبة الدورة في\n خانة بيانات الطلبة.")
                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025))
                                .multilineTextAlignment(.trailing)
                                .frame(width: screenWidth * 0.4)
                        }
                        
                        Spacer().frame(width: uiDevicePhone ? screenWidth * 0.045 : screenWidth * 0.04)
                        
                        VStack {
                            Image("Group 129")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
                            
                            Text("عدد الطلبة الحاضرين")
                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
                                .offset(x: uiDevicePhone ? 0 : screenWidth * -0.02)
                        }
                    }
                    
                    TextField("أدخل رقم الطلبة الحاضرين في الجلسة. يجب ألا يكون العدد أكثر من الطلبة المسجلين لديك، وألا يزيد عن 35.", text: $numberOfStudents)
                        .keyboardType(.asciiCapableNumberPad) // ✅ يجبر لوحة المفاتيح على الأرقام الإنجليزية فقط
                        .textContentType(.oneTimeCode) // ✅ يساعد في تعطيل زر تغيير اللغة في بعض لوحات المفاتيح
                        .disableAutocorrection(true) // ✅ يمنع التصحيح التلقائي ويقلل من احتمال تبديل اللغة
                        .foregroundStyle(primaryColor)
                        .frame(width: uiDevicePhone ? screenWidth * 0.63 : screenWidth * 0.5)
                        .frame(height: screenHeight * 0.04)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                        .onChange(of: numberOfStudents) { newValue in
                              // 🔹 السماح بالأرقام فقط ومنع الأحرف الأخرى
                              let filtered = newValue.filter { "0123456789".contains($0) }
                              if filtered != newValue {
                                  numberOfStudents = filtered // تحديث القيمة لحذف أي مدخلات غير رقمية
                              }
                              debounceValidation(newValue: numberOfStudents) // استدعاء الدالة بعد الفلترة
                          }
//                        .onChange(of: numberOfStudents) { newValue in
//                            debounceValidation(newValue: newValue)
//                        }
                    
                    
                    
                    
                    Spacer().frame(height: screenHeight * 0.035)
                    
                    VStack {
                        HStack {
                            VStack {
                                Image("Group 130")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
                                
                                Text("صورة جماعية للحضور")
                                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023))
                            }
                            
                            Spacer().frame(width: uiDevicePhone ? screenWidth * 0.06 : screenWidth * 0.04)
                            
                            VStack {
                                HStack {
                                    Spacer().frame(width: screenWidth * 0.2)
                                    Image("Group 127")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.04)
                                }
                                
                                Text("يرجى اخذ صورة واحدة بشكل\n واضح يظهر فيها جميع\n الطلبة.")
                                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025))
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        
                        Button(action: {
                            showImagePicker.toggle()
                            
                            isSendingImageData = true
                            
                        }) {
                            Text(isSendingImageData ? "تم تحميل الصورة" : "تحميل الصورة")
                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025))
                                .frame(height: screenHeight * 0.04)
                                .foregroundColor(.white)
                                .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
                        }
                        .background(isSendingImageData ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                        .cornerRadius(5)
                        //                            .sheet(isPresented: $showImagePicker) {
                        //                                ImagePicker2(imageData: $imageData)
                        //                            }
                        
                        
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker3(selectedImage: $imageData, sourceType: .camera)
                        }
                        
                    }
                }
                
                Spacer().frame(height: screenHeight * 0.035)
                
                VStack {
                    Text("في حال كانت هنالك ملاحظات يرجى كتابتها هنا")
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025))
                        .frame(height: screenHeight * 0.04)
                        .foregroundColor(.black)
                        .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
                    
                    TextEditor(text: $notes)
                        .frame(width: uiDevicePhone ? screenWidth * 0.63 : screenWidth * 0.5)
                        .frame(height: screenHeight * 0.15)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .multilineTextAlignment(.trailing)
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in }
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                Button("تم، اخفاء الكيبورد") {
                                    hideKeyboardExplicitly()
                                }
                            }
                        }
                    
                    Spacer().frame(height: screenHeight * 0.035)
                    
                    Button(action: {
                        
                        
                        
                        
                        validateAndSendAttendance()
                        
                        
                        
                        
                    }) {
                        Text("ارسال موقف الحضور")
                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025))
                            .frame(height: screenHeight * 0.04)
                            .foregroundColor(.white)
                            .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
                        
                    }
                    .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
                    .cornerRadius(5)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("موافق")))
                    }
                    
                    
                    
                    
                    //
//                    NavigationLink(destination: DisplayAttendanceData().environmentObject(vmAttendaceStatus)) { Text("عرض البيانات المخزنة") .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025)) .frame(height: screenHeight * 0.04) .foregroundColor(.white) .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5) }
//                    
//                    
                    
                        .background(Color.blue) .cornerRadius(5) .padding(.top, 20)
                    
                }
                
                
                
                
            }
            .scrollIndicators(.hidden) // ✅ إخفاء شريط التمرير
            
        }
        .onTapGesture {
            hideKeyboardExplicitly()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        
        .overlay(
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.0 : screenHeight * 0)
        )
        .overlay {
            ZStack {
                Button(action: {
                    dismiss()
                }) {
                    Image("Group 56")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiDevicePhone ? screenWidth * 0.09 : screenWidth * 0.064)
                }
                .offset(x: uiDevicePhone ? screenWidth * 0.46 : screenWidth * 0.47, y: screenHeight * -0.03)
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    // ✅ **التحقق من عدد الطلاب المدخل**
    private func validateStudentNumber(newValue: String) {
        if let enteredNumber = Int(newValue) {
            let registeredStudentsCount = studentViewModel.savedEntitiesStudent.count
            
            if registeredStudentsCount < 1 {
                // ❌ لا يمكن الإرسال لأن العدد أقل من 15
                numberOfStudents = ""
                alertTitle = "عدد غير كافٍ"
                alertMessage = "يجب أن يكون لديك على الأقل 15 طالبًا مسجلًا في قاعدة البيانات لكي تستطيع إرسال الحضور."
                showAlert = true
            } else if enteredNumber > registeredStudentsCount {
                // ❌ لا يمكن إدخال عدد أكبر من المسجلين
                numberOfStudents = "\(registeredStudentsCount)"
                alertTitle = "عدد أكبر من المسجل"
                alertMessage = "لديك \(registeredStudentsCount) طالبًا مسجلًا، لا يمكنك تسجيل عدد أكبر من ذلك."
                showAlert = true
            } else if enteredNumber > 60 {
                // ❌ لا يمكن إدخال أكثر من 35 في جميع الحالات
                numberOfStudents = "35"
                alertTitle = "عدد زائد"
                alertMessage = "لا يمكنك تسجيل أكثر من 35 طالبًا في الحضور."
                showAlert = true
            }
        } else {
            numberOfStudents = newValue.filter { $0.isNumber } // ❌ السماح فقط بالأرقام
        }
    }
    
    // ✅ **التحقق من البيانات قبل الإرسال**
    private func validateAndSendAttendance() {
        let registeredStudentsCount = studentViewModel.savedEntitiesStudent.count
        
        if registeredStudentsCount < 1 {
            // ❌ منع الإرسال بالكامل إذا كان العدد المسجل أقل من 15
            alertTitle = "عدد غير كافٍ"
            alertMessage = "يجب أن يكون لديك على الأقل طالب واحد مسجل لكي تستطيع إرسال الحضور."
            showAlert = true
            return
        }
        
        if numberOfStudents.isEmpty || locationManager.location == nil || imageData == nil {
            // ❌ التحقق من إدخال جميع البيانات المطلوبة
            alertTitle = "خطأ في المدخلات"
            alertMessage = "يرجى التأكد من إدخال عدد الطلاب وتوفر الموقع والصورة الجماعية."
            showAlert = true
            return
        }
        
        if let numberOfStudentsInt = Int(numberOfStudents) {
            if numberOfStudentsInt > 60 {
                // ❌ عدد الطلاب أكثر من 35 غير مسموح
                alertTitle = "عدد زائد"
                alertMessage = "لا يمكنك تسجيل أكثر من 60 طالبًا."
                showAlert = true
                return
            } else if numberOfStudentsInt > registeredStudentsCount {
                // ❌ عدد الطلاب أكبر من المسجلين
                alertTitle = "عدد أكبر من المسجل"
                alertMessage = "لديك \(registeredStudentsCount) طالبًا مسجلًا، لا يمكنك تسجيل عدد أكبر من ذلك."
                showAlert = true
                return
            }
        }
        
        // ✅ **إرسال الحضور بعد التحقق**
        if let numberOfStudentsInt = Int(numberOfStudents),
           let location = locationManager.location,
           let image = imageData,
           let imageDataCompressed = image.jpegData(compressionQuality: 0.5) {
            
            vmAttendaceStatus.addAttendaceStatus(
                numberOfStudents: numberOfStudentsInt,
                imageData: imageDataCompressed,
                notes: notes,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                date: Date(),
                state: 0
            )
            
            
            alertTitle = "تم الحفظ"
            alertMessage = "تم حفظ موقف الحضور بنجاح!"
            showAlert = true
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let attendanceUploader = AttendanceUploader(database: vmAttendaceStatus)
                attendanceUploader.sendPendingAttendanceData()
            }
            
            //  **إعادة تعيين القيم بعد الحفظ**
            numberOfStudents = ""
            imageData = nil
            notes = ""
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                dismiss()
            }
        }
    }
}
    
  
















//#Preview {
//    sendAttendanceSection()
//        .environmentObject(AttendaceStatusViewModel.shared)
//        .environmentObject(TeacherDataViewModel()) // ضروري إذا كان LogoIUserInfo يحتاجه
//}



// Helper function to hide the keyboard
extension View {
private func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
}














