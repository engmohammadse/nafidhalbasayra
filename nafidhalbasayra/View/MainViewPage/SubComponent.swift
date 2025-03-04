//
//  SubComponent.swift
//  nafidhalbasayra
//
//  Created by muhammad on 17/10/2024.
//



import SwiftUI

struct FormField: View {
    var label: String
    @Binding var text: String
   // var isPhoneNumber: Bool = false
    
    var body: some View {
        
        
        VStack( alignment: .trailing,  spacing: 3) {
            if UIDevice.current.userInterfaceIdiom == .phone {
                Text(label)
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                    .foregroundStyle(primaryColor)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)

                TextField("", text: $text)
                   // .keyboardType(isPhoneNumber ? .phonePad : .default)
                    .foregroundStyle(primaryColor)
                    .frame(maxWidth: screenHeight * 0.4)
                    .frame(height: screenHeight * 0.05)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                
            } else {
                
                VStack (spacing: 8) {
                    Text(label)
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                        .foregroundStyle(primaryColor)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.05 : screenWidth * 0.05)
                    
                    TextField("", text: $text)
                    // .keyboardType(isPhoneNumber ? .phonePad : .default)
                        .foregroundStyle(primaryColor)
                        .frame(height: screenHeight * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                }
                .padding(.horizontal, screenWidth * 0.1)
            }
        }
        
        
    }
}


struct FormFieldNumber: View {
    var label: String
    @Binding var text: String
    var isPhoneNumber: Bool = false

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            if UIDevice.current.userInterfaceIdiom == .phone {
                Text(label)
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                    .foregroundStyle(primaryColor)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)


                TextField("", text: $text)
                    .keyboardType(.asciiCapableNumberPad) // ✅ يجبر لوحة المفاتيح على الأرقام الإنجليزية فقط
                    .textContentType(.oneTimeCode) // ✅ يساعد في تعطيل زر تغيير اللغة في بعض لوحات المفاتيح
                    .disableAutocorrection(true) // ✅ يمنع التصحيح التلقائي ويقلل من احتمال تبديل اللغة
                    .foregroundStyle(primaryColor)
                    .frame(maxWidth: screenHeight * 0.4)
                    .frame(height: screenHeight * 0.05)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                   .onChange(of: text) { newValue in
                       text = String(newValue.filter { char in
                           char.isASCII && "0123456789".contains(char) // ✅ يقبل فقط الأرقام الإنجليزية ASCII
                       }.prefix(11)) // ✅ تحويل Substring إلى String
                   }

//                    // فلترة الإدخال ليكون أرقامًا فقط
//                    .onChange(of: text) { newValue in
//                        text = newValue.filter { "0123456789".contains($0) } // إبقاء الأرقام فقط
//                    }
            } else {
                
                VStack (spacing: 8) {
                    Text(label)
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                        .foregroundStyle(primaryColor)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.05 : screenWidth * 0.05)
                    
                    
                    TextField("", text: $text)
                        .keyboardType(.asciiCapableNumberPad) // ✅ يجبر لوحة المفاتيح على الأرقام الإنجليزية فقط
                        .textContentType(.oneTimeCode) // ✅ يساعد في تعطيل زر تغيير اللغة في بعض لوحات المفاتيح
                        .disableAutocorrection(true) // ✅ يمنع التصحيح التلقائي ويقلل من احتمال تبديل اللغة
                        .foregroundStyle(primaryColor)
                        .keyboardType(.asciiCapableNumberPad) // ✅ يجبر لوحة المفاتيح على الأرقام الإنجليزية فقط
                    //                    .frame(maxWidth: screenHeight * 0.4)
                        .frame(height: screenHeight * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                        .onChange(of: text) { newValue in
                            text = String(newValue.filter { char in
                                char.isASCII && "0123456789".contains(char) // ✅ يقبل فقط الأرقام الإنجليزية ASCII
                            }.prefix(11)) // ✅ تحويل Substring إلى String
                        }
                    // فلترة الإدخال ليكون أرقامًا فقط
//                        .onChange(of: text) { newValue in
//                            text = newValue.filter { "0123456789".contains($0) } // إبقاء الأرقام فقط
//                        }
                }
                .padding(.horizontal, screenWidth * 0.1)
            }
            
        }
    }
}




struct DropdownField: View {
    var label: String
    @Binding var selectedOption: String
    var options: [String]
    @State private var showDropdown: Bool = false
    @Binding var isDropdownActive: Bool
    

    var body: some View {
        
        //alignment: .trailing,
        VStack(spacing: 8) {
            
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                
                // عنوان الحقل
                Text(label)
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                    .foregroundStyle(primaryColor)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)

                // الحقل النصي
                TextField(selectedOption, text: $selectedOption)
    //                .onTapGesture {
    //                    showDropdown.toggle()
    //                }
                    .foregroundStyle(primaryColor)
                    .frame(maxWidth: screenHeight * 0.4)
                    .frame(height: screenHeight * 0.05)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                    .disabled(true)
                    .overlay(
                           Color.clear
                               .contentShape(Rectangle()) // يجعل الطبقة قابلة للنقر
                               .onTapGesture {
                                   hideKeyboardExplicitly()
                                   withAnimation {
                                         showDropdown.toggle()
                                         isDropdownActive = showDropdown
                                         }
                               }
                       )

                    .overlay {
                        Image(showDropdown ? "Vector1" : "Vector")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: screenWidth * 0.03)
                            .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.25)
                    }
                
               
                    

                // قائمة الخيارات
                if showDropdown {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(options, id: \.self) { option in
                                Text(option)
                                    .multilineTextAlignment(.trailing)
                                    .padding(8)
                                    .font(.custom("BahijTheSansArabic-Plain", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.03 : screenWidth * 0.023))
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(primaryColor)
                                    .background(buttonAccentColor)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        selectedOption = option
                                        
                                        withAnimation {
                                            showDropdown = false
                                            isDropdownActive = false 
                                         }
                                    }
                            }
                        }
                        .padding(.all)
                    }
                    .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.78 : screenWidth * 0.6)
                   // .frame(height: 200)
                    .background(Color.white)
                    .cornerRadius(5)
                }
                
            } else {
                VStack (spacing: 16) {
                    // عنوان الحقل
                    Text(label)
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                        .foregroundStyle(primaryColor)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.05 : screenWidth * 0.05)

                    // الحقل النصي
                    TextField(selectedOption, text: $selectedOption)
        //                .onTapGesture {
        //                    showDropdown.toggle()
        //                }
                        .foregroundStyle(primaryColor)
                        .frame(height: screenHeight * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                        .disabled(true)
                        .overlay(
                               Color.clear
                                   .contentShape(Rectangle()) // يجعل الطبقة قابلة للنقر
                                .onTapGesture {
                                    hideKeyboardExplicitly()
                                    withAnimation {
                                          showDropdown.toggle()
                                          isDropdownActive = showDropdown
                                          }
                                }
                           )

                        .overlay {
                            Image(showDropdown ? "Vector1" : "Vector")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: screenWidth * 0.02)
                                .offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.35 : screenWidth * -0.2)
                        }

                    // قائمة الخيارات
                    if showDropdown {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(options, id: \.self) { option in
                                    Text(option)
                                        .multilineTextAlignment(.trailing)
                                        .padding(8)
                                        .font(.custom("BahijTheSansArabic-Plain", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.03 : screenWidth * 0.023))
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(primaryColor)
                                        .background(buttonAccentColor)
                                        .cornerRadius(5)
                                        .onTapGesture {
                                            selectedOption = option
                                            
                                            withAnimation {
                                                showDropdown = false
                                                isDropdownActive = false
                                             }
                                        }
                                }
                            }
                            .padding(.all)
                        }
                        .frame(width: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.78 : screenWidth * 0.6)
                       // .frame(height: 200)
                        .background(Color.white)
                        .cornerRadius(5)
                    }
                }
                .padding(.horizontal, screenWidth * 0.1)
            }
            
            
        }
//        .position(x: screenWidth * 0.54, y: screenHeight * 0.04) // تعديل الإحداثيات
    }
}


struct FormFieldAge: View {
    var label: String
    @Binding var text: String
    var isPhoneNumber: Bool = false

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            if UIDevice.current.userInterfaceIdiom == .phone {
                Text(label)
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                    .foregroundStyle(primaryColor)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)


                TextField("", text: $text)
                    .keyboardType(.asciiCapableNumberPad) // ✅ يجبر لوحة المفاتيح على الأرقام الإنجليزية فقط
                    .textContentType(.oneTimeCode) // ✅ يساعد في تعطيل زر تغيير اللغة في بعض لوحات المفاتيح
                    .disableAutocorrection(true) // ✅ يمنع التصحيح التلقائي ويقلل من احتمال تبديل اللغة
                    .foregroundStyle(primaryColor)
                    .frame(maxWidth: screenHeight * 0.4)
                    .frame(height: screenHeight * 0.05)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                    .onChange(of: text) { newValue in
                           text = String(newValue.filter { "0123456789".contains($0) }.prefix(2)) // ✅ تحويل Substring إلى String
                       }

//                    // فلترة الإدخال ليكون أرقامًا فقط
//                    .onChange(of: text) { newValue in
//                        text = newValue.filter { "0123456789".contains($0) } // إبقاء الأرقام فقط
//                    }
            } else {
                
                VStack (spacing: 8) {
                    Text(label)
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                        .foregroundStyle(primaryColor)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.05 : screenWidth * 0.05)
                    
                    
                    TextField("", text: $text)
                        .keyboardType(.asciiCapableNumberPad) // ✅ يجبر لوحة المفاتيح على الأرقام الإنجليزية فقط
                        .textContentType(.oneTimeCode) // ✅ يساعد في تعطيل زر تغيير اللغة في بعض لوحات المفاتيح
                        .disableAutocorrection(true) // ✅ يمنع التصحيح التلقائي ويقلل من احتمال تبديل اللغة
                        .foregroundStyle(primaryColor)
                        .frame(height: screenHeight * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                    
                    // فلترة الإدخال ليكون أرقامًا فقط
                        .onChange(of: text) { newValue in
                               text = String(newValue.filter { "0123456789".contains($0) }.prefix(2)) // ✅ تحويل Substring إلى String
                           }
                }
                .padding(.horizontal, screenWidth * 0.1)
            }
            
        }
    }
}












//
//#Preview {
//    DropdownField
//}




#Preview {
    AddStudentToStudentDataSection( )
        .environmentObject(TeacherDataViewModel())
}




import SwiftUI

struct ToastView: View {
    var title: String
    var message: String
    var backgroundColor: Color
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // ✅ أيقونة تعطي الطابع الرسمي للتنبيه
            Image(systemName: title.contains("✅") ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.9))
                .padding(.top, 10)
            
            // ✅ عنوان التنبيه
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.95))
            
            // ✅ نص الرسالة
            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 25)
            
            // ✅ زر الإغلاق بتصميم عصري
            Button(action: {
                onDismiss()
            }) {
                Text("تم")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding(.bottom, 15)
        }
        .frame(width: 320)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor.opacity(0.9))
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .padding()
        .transition(.scale)
        .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.3))
    }
}

