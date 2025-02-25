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
               if let number = Int(newValue) {
                   if number > 35 {
                       numberOfStudents = "35" // إذا تجاوز الرقم الحد الأقصى، يتم التعيين إلى 35
                   } else if number < 15 {
                       numberOfStudents = "15" // إذا كان الرقم أقل من الحد الأدنى، يتم التعيين إلى 15
                   }
               } else {
                   // إزالة الأحرف غير الصالحة
                   numberOfStudents = String(newValue.filter { $0.isNumber })
               }
           }

           // تنفيذ المهمة بعد تأخير
           if let task = debounceTask {
               DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: task)
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
                        
                        TextField("يجب أن يكون الرقم بين 15 و 35", text: $numberOfStudents)
                            .keyboardType(.asciiCapableNumberPad) // لوحة مفاتيح الأرقام باللغة الإنجليزية فقط
                            .textInputAutocapitalization(.none) // لمنع الأحرف الكبيرة (اختياري)
                            .frame(width: uiDevicePhone ? screenWidth * 0.63 : screenWidth * 0.5)
                            .frame(height: screenHeight * 0.04)
                            .multilineTextAlignment(.trailing)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(5)
                            .onChange(of: numberOfStudents) { newValue in
                                              debounceValidation(newValue: newValue)
                                          }

                  

                        
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
                                ImagePicker(selectedImage: $imageData, sourceType: .camera)
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
                            
                            
                            if numberOfStudents.isEmpty || locationManager.location == nil || imageData == nil {
                                    // ❌ المدخلات غير مكتملة، إظهار التنبيه
                                    alertTitle = "خطأ في المدخلات"
                                    alertMessage = "يرجى التأكد من إدخال عدد الطلاب وتوفر الموقع والصورة الجماعية."
                                    showAlert = true
                                } else {
                                    // ✅ المدخلات صحيحة، حفظ البيانات
                                    if let numberOfStudentsInt = Int(numberOfStudents),
                                       let location = locationManager.location,
                                       let image = imageData,  // ✅ تأكد أن `imageData` ليست nil
                                       let imageDataCompressed = image.jpegData(compressionQuality: 0.5) { // ✅ تحويل `UIImage` إلى `Data`
                                        
                                        print("✅ Saving attendance status for \(numberOfStudentsInt) students at location: \(location.coordinate.latitude), \(location.coordinate.longitude).")

                                        vmAttendaceStatus.addAttendaceStatus(
                                            numberOfStudents: numberOfStudentsInt,
                                            imageData: imageDataCompressed, // ✅ تم التحقق من أن الصورة ليست nil
                                            notes: notes,
                                            latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude,
                                            date: Date(), // ✅ تخزين التاريخ والوقت بصيغة النص
                                            state: 0
                                        )

                                        // ✅ إظهار تنبيه النجاح
                                        alertTitle = "تم الحفظ"
                                        alertMessage = "تم حفظ موقف الحضور بنجاح!"
                                        showAlert = true

                                        // ✅ إعادة تعيين الحقول بعد الحفظ
                                        numberOfStudents = ""
                                        imageData = nil // ✅ إعادة تعيين `UIImage` إلى `nil`
                                        notes = ""
                                    }
                                    
                                   
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        
                                        dismiss()
                                    }
                                }

                            
                            
                         
//                            if let numberOfStudentsInt = Int(numberOfStudents), let location = locationManager.location {
//                                
//                                // Save attendance status
//                                
//                                print("Saving attendance status for \(numberOfStudentsInt) students at location: \(location.coordinate.latitude), \(location.coordinate.longitude).")
//                                
//
//                                
//                                if let imageData = imageData?.jpegData(compressionQuality: 0.5) {
//                                    vmAttendaceStatus.addAttendaceStatus(
//                                        numberOfStudents: numberOfStudentsInt,
//                                        imageData: imageData, // الصورة محولة إلى نوع Data
//                                        notes: notes,
//                                        latitude: location.coordinate.latitude,
//                                        longitude: location.coordinate.longitude,
//                                        date: Date(),
//                                        state: 0
//                                 
//                                    )
//                                }  else {
//                                    print("⚠️ Warning: No image was selected before saving attendance.")
//                                }
//                                
//                                
//                                showAlert = true
//                                
//                                
//                            } else { 
//                                print("Error: Invalid input or location not available.")
//                                showAlert = true
//                                // اظهر التنبيه حتى في حالة الخطأ لعرض رسالة مخصصة
//                            }
//                            
                            

                         
                            
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
                        NavigationLink(destination: DisplayAttendanceData().environmentObject(vmAttendaceStatus)) { Text("عرض البيانات المخزنة") .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025)) .frame(height: screenHeight * 0.04) .foregroundColor(.white) .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5) } .background(Color.blue) .cornerRadius(5) .padding(.top, 20) }
                    
                    
                 
                    
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
            
//            .alert(isPresented: $showAlert) {
//                if numberOfStudents.isEmpty || locationManager.location == nil || imageData == nil {
//                    return Alert(
//                        title: Text("خطأ في المدخلات"),
//                        message: Text(" يرجى التأكد من إدخال عدد الطلاب وتوفر الموقع والصورة الجماعية ."), dismissButton: .default(Text("موافق"))
//                    )
//                    
//                } else {
//                    return Alert( title: Text("تم الحفظ"),
//                                  message: Text("تم حفظ موقف الحضور بنجاح!"),
//                                  dismissButton: .default(Text("موافق")) {
//                        // Reset fields
//                        numberOfStudents = ""
//                        imageData = nil
//                        notes = ""
//                    }
//                    )
//                }
//        }
        
                    
                    
        
//        .alert(isPresented: $showAlert) {
//            Alert(
//                title: Text("تم الحفظ"),
//                message: Text("تم حفظ موقف الحضور بنجاح!"),
//                dismissButton: .default(Text("موافق")) {
//                    // Reset fields
//                    numberOfStudents = ""
//                    imageData = nil
//                    notes = ""
//                }
//            )
//        }
    }
}




#Preview {
    sendAttendanceSection()
        .environmentObject(AttendaceStatusViewModel.shared)
        .environmentObject(TeacherDataViewModel()) // ضروري إذا كان LogoIUserInfo يحتاجه
}

//#Preview {
//    sendAttendanceSection()
//        .environmentObject(AttendaceStatusViewModel())
//    
//}

// Helper function to hide the keyboard
extension View {
private func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
}


















//old
//import SwiftUI
//
//struct sendAttendanceSection: View {
//    @State private var isPressed :Bool = false
//    @State private var name: String = ""
//    @Environment(\.dismiss) var dismiss
//    
//    
//    
//    @StateObject private var locationManager = LocationManager()
//    @State private var numberOfStudents: String = ""
//    @State private var imageData: Data? = nil
//    @State private var notes: String = ""
//    @State private var showAlert = false
//    @State private var showImagePicker = false
//
//    
//    var body: some View {
//     
//    
//    
//        VStack {
//            ScrollView {
//            VStack  {
//                Spacer()
//                    .frame(height: screenHeight * 0.07)
//                HStack {
//                
//                    VStack{
//                        Image("Group 46")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
//
//                        
//                        Text("تثبيت الموقع الحالي")
//                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
//                    }
//                    
//                    Spacer()
//                        .frame(width: uiDevicePhone ? screenWidth * 0.06 : screenWidth * 0.04 )
//                    
//                    VStack {
//                        HStack {
//                            Spacer()
//                                .frame(width: screenWidth * 0.2)
//                            Image("Group 124")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                            .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.04)
//                        }
//                        
//                        Text("يرجى الذهاب لمكان مفتوح\n قبل الضغط على زر تثبيت\n الموقع .")
//                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025 ))
//                        .multilineTextAlignment(.trailing)
//                    }
//                }
//                
//                Button(action: {
//    //                    isPressed.toggle()
//    //                    withAnimation(.easeInOut(duration: 0.5)) {
//    //                        showError.toggle()
//    //                    }
//    //                    // Navigate to the next screen upon successful login
//    //                    isNavigate = true
//                }) {
//                    Text("تثبيت")
//                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
//                        .frame(height: screenHeight * 0.04)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
//                }
//                .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
//                .cornerRadius(5)
//            }
//            
//            // 
//            
//            
//            Spacer()
//                .frame(height: screenHeight * 0.035)
//            
//            VStack{
//                HStack {
//                    
//                    
//                    VStack {
//                        HStack {
//                           
//                            Image("Group 125")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.04)
//                                .offset(x: uiDevicePhone ? 0 : screenWidth * 0.04)
//                            Spacer()
//                                .frame(width: screenWidth * 0.28)
//                        }
//                        
//                        Text("يرجى ادخال عدد الطلبة\n الحاضرين بدقة، وقبل ذلك\n تأكد من تسجيل بيانات\n جميع طلبة الدورة في\n خانة بيانات الطلبة .")
//                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025 ))
//                        .multilineTextAlignment(.trailing)
//                        .frame(width: screenWidth * 0.4)
//                    }
//                    
//                    Spacer()
//                        .frame(width: uiDevicePhone ? screenWidth * 0.045 : screenWidth * 0.04 )
//                
//                    VStack{
//                        Image("Group 129")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
//                        
//                        Text("عدد الطلبة الحاضرين")
//                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
//                            .offset(x: uiDevicePhone ? 0 : screenWidth * -0.02)
//                    }
//                    
//                    
//                    
//                   
//                }
//                
//                // Field:
//             
//                
//                TextField("مثال: 20", text: $name)
//                    .frame(width: uiDevicePhone ? screenWidth * 0.63 : screenWidth * 0.5)
//                    .frame(height: screenHeight * 0.04)
//                    .multilineTextAlignment(.trailing)
//                    .padding(.horizontal)
//                    .background(Color.white)
//                    .cornerRadius(5)
//                
//                // Field: End
//                
//                Spacer()
//                    .frame(height: screenHeight * 0.035)
//                
//                VStack  {
//                   
//                    HStack {
//                    
//                        VStack{
//                            Image("Group 130")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: screenWidth > 400 ? (uiDevicePhone ? screenWidth * 0.2 : screenWidth * 0.14) : screenWidth * 0.2)
//
//                            
//                            Text("صورة جماعية للحضور")
//                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.023 ))
//                        }
//                        
//                        Spacer()
//                            .frame(width: uiDevicePhone ? screenWidth * 0.06 : screenWidth * 0.04 )
//                        
//                        VStack {
//                            HStack {
//                                Spacer()
//                                    .frame(width: screenWidth * 0.2)
//                                Image("Group 127")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                .frame(width: uiDevicePhone ? screenWidth * 0.065 : screenWidth * 0.04)
//                            }
//                            
//                            Text("يرجى اخذ صورة واحدة بشكل\n واضح يظهر فيها جميع\n الطلبة .")
//                                .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.03 : screenWidth * 0.025 ))
//                            .multilineTextAlignment(.trailing)
//                        }
//                    }
//                    
//                    Button(action: {
//        //                    isPressed.toggle()
//        //                    withAnimation(.easeInOut(duration: 0.5)) {
//        //                        showError.toggle()
//        //                    }
//        //                    // Navigate to the next screen upon successful login
//        //                    isNavigate = true
//                    }) {
//                        Text("تحميل الصورة")
//                            .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
//                            .frame(height: screenHeight * 0.04)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
//                    }
//                    .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
//                    .cornerRadius(5)
//                }
//                
//                
//        
//            }
//            
//            // note section
//            Spacer()
//                .frame(height: screenHeight * 0.035)
//
//            VStack{
//               
//                
//                Text("في حال كانت هنالك ملاحظات يرجى كتابتها هنا")
//                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
//                    .frame(height: screenHeight * 0.04)
//                    .foregroundColor(.black)
//                    .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
//                
//                TextEditor(text: $name)
//                           .frame(width: uiDevicePhone ? screenWidth * 0.63 : screenWidth * 0.5)
//                           .frame(height: screenHeight * 0.15)
//                           .padding(.horizontal)
//                           .background(Color.white)
//                           .cornerRadius(5)
//                           .overlay(
//                               RoundedRectangle(cornerRadius: 5)
//                                   .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                           )
//                           .multilineTextAlignment(.trailing) // Ensures text is aligned to the right (Arabic)
//                           .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
//                                               // This is called when the keyboard is dismissed
//                                           }
//                           .toolbar {
//                                       ToolbarItem(placement: .keyboard) {
//                                           Button("تم، اخفاء الكيبورد") {
//                                               hideKeyboard() // Hide the keyboard when 'Done' is pressed
//                                           }
//                                       }
//                                   }
//
//                
//                Spacer()
//                    .frame(height: screenHeight * 0.035)
//                
//                Button(action: {
//    //                    isPressed.toggle()
//    //                    withAnimation(.easeInOut(duration: 0.5)) {
//    //                        showError.toggle()
//    //                    }
//    //                    // Navigate to the next screen upon successful login
//    //                    isNavigate = true
//                }) {
//                    Text("ارسال موقف الحضور")
//                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03 : screenWidth * 0.025 ))
//                        .frame(height: screenHeight * 0.04)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: uiDevicePhone ? screenWidth * 0.7 : screenWidth * 0.5)
//                }
//                .background(isPressed ? Color.black : Color(red: 27 / 255, green: 62 / 255, blue: 93 / 255))
//                .cornerRadius(5)
//                
//                
//            }
//            
//            
//            
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color(red: 236/255, green: 242/255, blue: 245/255))
//              
//        }  .overlay(
//            LogoIUserInfo()
//                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.0 : screenHeight * 0)
//    )
//        
//        .overlay{
//            ZStack{
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image("Group 56")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: uiDevicePhone ? screenWidth * 0.08 : screenWidth * 0.064)
//                }
//                .offset(x: screenWidth * 0.46, y: screenHeight * -0.15)
//            }
//        }
//        
//        .navigationBarBackButtonHidden(true)
//        
//        
//    }
//}
//
//#Preview {
//    sendAttendanceSection()
//}
//
//
//
//// Helper function to hide the keyboard
//extension View {
//    func hideKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}



