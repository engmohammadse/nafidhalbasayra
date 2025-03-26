//
//  registerPage.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/09/2024.
//


import SwiftUI

struct registerPage: View {
    
    @EnvironmentObject var teacherData: TeacherDataViewModel
    @Environment(\.dismiss) var dismiss
    
   // @State private var name: String = ""
   // @State private var phoneNumber: String = ""
    @State private var isNavigate: Bool = false
    //@State private var birthDay: Date = Date()
    @State private var isPickerVisible: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var activeField: Field?
    //@State private var academicLevel: String = ""
    //@State private var currentWork: String = ""
   // @State private var cityNumber: Int = 0

    enum Field {
        case academicLevel, currentWork, cityNumber
    }
    
    var body: some View {

        VStack {
            
            
            ScrollView {
                registerPageTextField(teacherData: teacherData) // Pass the view model here
            }
            
            
            .padding(UIScreen.main.bounds.width < 400 ? 16 : 0)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
            .overlay{
                LogoIUserInfo()
                    .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
            }
          //  .ignoresSafeArea(edges: .bottom)
            
        }
        .navigationBarBackButtonHidden(true)
            .hideKeyboard()
            .overlay{
                
                
                PreviousNextButtonRegisterPage( geoW: screenWidth, geoH: screenHeight, destination: registerPage1().environmentObject(teacherData), color: Color.white, imageName: "Group 9", shouldNavigate: teacherData.checkFieldEmptyRP(), notEmptyFields: true)
             
                    .offset(y: UIScreen.main.bounds.width < 400 ? screenHeight * 0.43 : screenHeight * 0.42)
                                    
            }
            .alert("يجب ان لاتبقى الحقول فارغة", isPresented: $teacherData.showRegisterPageFieldsEmpty, actions: {
                Button("تم", role: .cancel) { }
            })
        
        
        
       
            
      
    }

    
    // Function to format date to a readable string
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // Calculate offset based on keyboard height
    private func calculateOffset() -> CGFloat {
        if [.academicLevel, .currentWork, .cityNumber].contains(activeField) {
            return keyboardHeight > 0 ? -keyboardHeight + 40 : 0
        }
        return 0
    }
    
    // Add keyboard observers
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
            self.keyboardHeight = 300 // Adjust this value according to the keyboard height
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            self.keyboardHeight = 0
        }
    }
    

}

//#Preview {
//    registerPage().environmentObject(TeacherDataViewModel())
//}
//    



struct registerPageTextField: View {
    
    
    @ObservedObject var teacherData: TeacherDataViewModel // Use ObservedObject here

    
//    @State private var name: String = ""
// 
//    @State private var phoneNumber: String = ""
//    @State private var isNavigate: Bool = false
//    @State private var birthDay: Date = Date()
    @State private var isPickerVisible: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var activeField: Field?
//    @State private var academicLevel: String = ""
//    @State private var currentWork: String = ""
//    @State private var cityNumber: String = ""
    
   
    

    enum Field {
        case academicLevel, currentWork, cityNumber
    }
    
    
    
    var body: some View {
        LazyVStack(spacing: 10) {
            
            if UIScreen.main.bounds.width > 400 {
                
                Spacer().frame(height:  screenHeight * 0.025 )
            }
            
            Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.025 : screenHeight * 0.10)
            
//            Button("Print Data") {
//              teacherData.printData() // استدعاء دالة الطباعة
//                }
            
            // Field: Name
            Text("الأسم الرباعي واللقب")
                .alignmentGuide(.leading) { d in d[.trailing] }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            TextField("", text: $teacherData.name)
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
                .onChange(of: teacherData.name) { newValue in
                    teacherData.name = newValue //update name temp save
                   // print("Updated name: \(newValue)")
                }
            
            Spacer().frame(maxHeight: screenHeight * 0.01)
            
            // Field: Birth Day
            Text("تاريخ الولادة")
                .alignmentGuide(.leading) { d in d[.trailing] }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            TextField("اختر تاريخ الميلاد", text: Binding(
                get: {
                    
                    teacherData.birthDay != nil ? formattedDate(teacherData.birthDay!) : "اختر تاريخ الميلاد" },
                set: { _ in }
            ))
            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.03 : screenWidth * 0.015))
            .disabled(true)
            .frame(maxWidth: screenHeight * 0.4)
            .frame(height: screenHeight * 0.05)
            .multilineTextAlignment(.trailing)
            .padding(.horizontal)
            .background(Color.white)
            .cornerRadius(5)
            .onTapGesture(perform: {isPickerVisible.toggle()})
            .onChange(of: teacherData.birthDay) { newValue in
                            // This will update the birthDay property in TeacherDataViewModel
                        teacherData.birthDay = newValue
                            //print("New birth date is: \(newValue)")
                        }
           

            .overlay{
                Button(action: {
                    isPickerVisible.toggle()
                }) {
                    Image(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: screenWidth * 0.04)
                        .foregroundColor(.blue)
                        .padding(.trailing, 10)
                }.offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.31 : screenWidth * -0.25)
            }
            
            
            Spacer().frame(maxHeight: screenHeight * 0.01)
            
            // Field: Phone Number
            Text("رقم الهاتف الخاص بالأستاذ")
                .alignmentGuide(.leading) { d in d[.trailing] }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            TextField("", text: $teacherData.phonenumber)
                .keyboardType(.asciiCapableNumberPad) //  يجبر لوحة المفاتيح على الأرقام الإنجليزية فقط
                .textContentType(.oneTimeCode) //  يساعد في تعطيل زر تغيير اللغة في بعض لوحات المفاتيح
                .disableAutocorrection(true) //  يمنع التصحيح التلقائي ويقلل من احتمال تبديل اللغة
                .keyboardType(.numberPad)
                .onChange(of: teacherData.phonenumber) { newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered.count > 11 {
                        teacherData.phonenumber = String(filtered.prefix(11))
                    } else {
                        teacherData.phonenumber = filtered
                    }
                }
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
            
            Spacer().frame(maxHeight: screenHeight * 0.01)
            
            // Field: Academic Level
            Text("التحصيل الحوزوي او الدراسي ( مع التخصص الدقيق)")
                .alignmentGuide(.leading) { d in d[.trailing] }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            TextField("", text: $teacherData.academiclevel)
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
                .focused($activeField, equals: .academicLevel)
                .onChange(of: teacherData.academiclevel) { newValue in
                    teacherData.academiclevel = newValue
                }
            
            Spacer().frame(maxHeight: screenHeight * 0.01)
            
            // Field: Current Work
            Text("العمل الحالي")
                .alignmentGuide(.leading) { d in d[.trailing] }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            TextField("", text: $teacherData.currentWork)
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
                .focused($activeField, equals: .currentWork)
                .onChange(of: teacherData.currentWork) { newValue in
                    teacherData.currentWork = newValue
                }
            
            Spacer().frame(maxHeight: screenHeight * 0.01)
            
            // Field: City Number
            Text("رمز المحافظة")
                .alignmentGuide(.leading) { d in d[.trailing] }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            TextField("", text: $teacherData.citynumber)
                .keyboardType(.asciiCapableNumberPad) //  يجبر لوحة المفاتيح على الأرقام الإنجليزية فقط
                .textContentType(.oneTimeCode) //  يساعد في تعطيل زر تغيير اللغة في بعض لوحات المفاتيح
                .disableAutocorrection(true) //  يمنع التصحيح التلقائي ويقلل من احتمال تبديل اللغة
                .keyboardType(.numberPad)
                .onChange(of: teacherData.citynumber) { newValue in
                        // السماح فقط بالأرقام الإنجليزية من 0 إلى 9
                        let filtered = newValue.filter { $0.isASCII && $0 >= "0" && $0 <= "9" }
                        // تقييد الإدخال إلى رقمين فقط
                        if filtered.count > 2 {
                            teacherData.citynumber = String(filtered.prefix(2))
                        } else {
                            teacherData.citynumber = filtered
                        }
                    }
//                .onChange(of: teacherData.citynumber) { newValue in
//                      // تصفية المدخلات للسماح فقط بالأرقام
//                      let filtered = newValue.filter { $0.isNumber }
//                      // تقيد العدد إلى 2 رقم
//                      if filtered.count > 2 {
//                          teacherData.citynumber = String(filtered.prefix(2))
//                      } else {
//                          teacherData.citynumber = filtered
//                      }
//                  }
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
                .focused($activeField, equals: .cityNumber)
            
        }
        //Spacer()
        .padding(.horizontal, UIScreen.main.bounds.width < 500 ? 16 : 0)
        .offset(y: calculateOffset()) // Apply offset only for the bottom fields
        .onAppear {
            self.addKeyboardObservers()
        }
        .onDisappear {
            self.removeKeyboardObservers()
        }
        
        .sheet(isPresented: $isPickerVisible) {
            VStack {
                HStack {
                    Spacer()
                    Button("تم") {
                        isPickerVisible = false
                    }
                    .padding(.trailing)
                }
                .padding(.top)
                
                DatePicker(
                    "اختر تاريخ الولادة",
                    selection: Binding(
                        get: { teacherData.birthDay ?? Date() },
                        set: { teacherData.birthDay = $0 }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle()) // Use Graphical style or another preferred one
                .labelsHidden() // Hides the "Select Date" label to make it cleaner
                .padding()
                
                Spacer() // Adds space to make the layout look more balanced
            }
        }



    }
    
    

    
    
    private func formattedDate(_ date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ar") // اللغة العربية
        if let validDate = date {
            return formatter.string(from: validDate)
        } else {
            return "اختر تاريخ الميلاد" // النص الافتراضي
        }
    }


    
    // Calculate offset based on keyboard height
    private func calculateOffset() -> CGFloat {
        if [.academicLevel, .currentWork, .cityNumber].contains(activeField) {
            return keyboardHeight > 0 ? -keyboardHeight + 40 : 0
        }
        return 0
    }
    
    // Add keyboard observers
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
            self.keyboardHeight = 300 // Adjust this value according to the keyboard height
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            self.keyboardHeight = 0
        }
    }
    
    // Remove keyboard observers
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}




//
import SwiftUI

struct PreviousNextButtonRegisterPage<Destination: View>: View {
    var geoW: CGFloat
    var geoH: CGFloat
    var destination: Destination // الوجهة التي ننتقل إليها
    var color: Color
    var imageName: String
    var shouldNavigate: Bool // شرط الانتقال
    var notEmptyFields: Bool
    @EnvironmentObject var teacherData: TeacherDataViewModel
    
    @Environment(\.dismiss) var dismiss // العودة للصفحة السابقة
    
    var body: some View {
        //NavigationStack {
            HStack {
                // Previous button icon
            

                // Previous button (Button to dismiss and go back)
                Button(action: {
                    dismiss() // العودة إلى الصفحة السابقة
                }) {
                    
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geoW * 0.04)
                        .padding(.vertical, geoH * 0.01)
                        .padding(.leading, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.02 : geoW * 0.001)
                        .foregroundColor(color)
                    
                    Text("السابق")
                        .font(.custom("BahijTheSansArabic-Bold", size: geoW * 0.03))
                        .foregroundColor(color)
                }
                .padding(.horizontal, geoW * 0.001)
                .foregroundColor(.white)
                .cornerRadius(10)

                // Divider line
                Image("Line 1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geoH * 0.01, height: geoH * 0.03)
                    .padding(.vertical, geoH * 0.008)
                
                
             

                // Next button with conditional navigation
                if shouldNavigate && notEmptyFields { // شرط الانتقال
                    NavigationLink(destination: destination) {
                        Text("التالي")
                            .font(.custom("BahijTheSansArabic-Bold", size: geoW * 0.03))
                            .padding(.horizontal, geoW * 0.001)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        
                        
                        Image("Group 16")
                                      .resizable()
                                      .aspectRatio(contentMode: .fit)
                                      .frame(maxWidth: geoW * 0.04)
                                      .padding(.vertical, geoH * 0.01)
                                      .padding(.trailing, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.02 : geoW * 0.001)
                        
                    }
                } else {
                    // حالة غير مفعلّة عند عدم تحقق الشرط
                    
                       
                    
                    Button(action: {
                        
                        // تحقق من رقم الهاتف أولاً
                          if teacherData.phonenumber.count != 11 {
                              teacherData.checkNumberRP = true
                              teacherData.showRegisterPageFieldsEmpty = false // تأكد من عدم تفعيل التنبيه الآخر
                              return // توقف هنا حتى لا يتم تنفيذ `checkFieldEmpty`
                          }
                          
                          // تحقق من الحقول الفارغة إذا كان الرقم صحيحًا
                          if !teacherData.checkFieldEmpty() {
                              teacherData.showRegisterPageFieldsEmpty = true
                              teacherData.checkNumberRP = false // تأكد من عدم تفعيل تنبيه الرقم
                          }
                        
                       
                     
                        
                            
                        
                        
                    }) {
                        Text("التالي")
                            .font(.custom("BahijTheSansArabic-Bold", size: geoW * 0.03))
                            .foregroundColor(color)
                            .padding(.horizontal, geoW * 0.001)
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .padding(.vertical, geoH * 0.01)
                    }
                    .padding(.horizontal, geoW * 0.001)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .alert("يجب أن يحتوي حقل رقم الهاتف على 11 رقمًا", isPresented: $teacherData.showAlertCheckNumber, actions: {
                        Button("تم", role: .cancel) {
                            teacherData.checkNumberRP = false
                        }
                    })

                    
                    
                    Image("Group 16")
                                  .resizable()
                                  .aspectRatio(contentMode: .fit)
                                  .frame(maxWidth: geoW * 0.04)
                                  .padding(.vertical, geoH * 0.01)
                                  .padding(.trailing, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.02 : geoW * 0.001)
                    
                    
                    
                }
                
                
                
                
                
            }
         
            .background(Color(UIColor(red: 20 / 255, green: 30 / 255, blue: 39 / 255, alpha: 1.0)))
            .cornerRadius(5)
            .padding()
       // }
    }
}


    
    
    
















