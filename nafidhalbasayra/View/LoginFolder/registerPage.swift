//
//  registerPage.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/09/2024.
//

//import SwiftUI
//
//struct registerPage: View {
//    
//    @State private var name : String = ""
//    @State private var birthDay : String = ""
//    @State private var phoneNumber : String = ""
//    
//    @State private var selectedDate: Date = Date() // The date the user selects
//      @State private var isPickerVisible: Bool = false // Controls visibility of the picker
//      
//    
//    
//    
//    var body: some View {
//        
//        GeometryReader { geometry in
//            
//            let geoH = geometry.size.height
//              let geoW = geometry.size.width
//            
//         
//            
//            VStack(spacing: 10) {
//                
//          
//                
//                    Text("الأسم الرباعي واللقب")
//                        .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
//                        .frame(maxWidth: .infinity, alignment: .trailing) // Push
//                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.035 : geoW * 0.02))
//                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
//
//                  
//                        TextField("user1          ", text: $name)
//                            .frame(maxWidth: geoH * 0.4)
//                            .frame(maxHeight: geoH * 0.05)
//                            .multilineTextAlignment(.trailing)
//                            .padding(.horizontal)
//                            .background(Color.white)
//                            .cornerRadius(5)
//                
//                Spacer()
//                    .frame(maxHeight: geoH * 0.01)
//                
//                //
//                
//                Text("تاريخ الولادة")
//                    .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
//                    .frame(maxWidth: .infinity, alignment: .trailing) // Push
//                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.035 : geoW * 0.02))
//                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
//                
//                
//            
//
//              
//                    TextField("user1          ", text: Binding(
//                        get: {formattedDate(selectedDate)},
//                        set: {_ in}
//                    
//                    ))
//                    .disabled(true) // Disable typing in the TextField
//
////                    .onTapGesture {
////                                    // Show the DatePicker when the TextField is tapped
////                                    isPickerVisible.toggle()
////                                }
//
//                        .frame(maxWidth: geoH * 0.4)
//                        .frame(maxHeight: geoH * 0.05)
//                        .multilineTextAlignment(.trailing)
//                        .padding(.horizontal)
//                        .background(Color.white)
//                        .cornerRadius(5)
//                
//                
//                
//                
//               
//                
//                
//                
//                
//                Spacer()
//                    .frame(maxHeight: geoH * 0.01)
//                
//                //
//                
//                Text("رقم الهاتف الخاص بالأستاذ")
//                    .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
//                    .frame(maxWidth: .infinity, alignment: .trailing) // Push
//                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.035 : geoW * 0.02))
//                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
//
//              
//                    TextField("user1          ", text: $phoneNumber)
//                        .frame(maxWidth: geoH * 0.4)
//                        .frame(maxHeight: geoH * 0.05)
//                        .multilineTextAlignment(.trailing)
//                        .padding(.horizontal)
//                        .background(Color.white)
//                        .cornerRadius(5)
//            
//                Spacer()
//                    .frame(maxHeight: geoH * 0.01)
//                
//                Text("التحصيل الحوزوي او الدراسي ( مع التخصص الدقيق)")
//                    .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
//                    .frame(maxWidth: .infinity, alignment: .trailing) // Push
//                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.032 : geoW * 0.02))
//                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
//
//              
//                    TextField("user1          ", text: $phoneNumber)
//                        .frame(maxWidth: geoH * 0.4)
//                        .frame(maxHeight: geoH * 0.05)
//                        .multilineTextAlignment(.trailing)
//                        .padding(.horizontal)
//                        .background(Color.white)
//                        .cornerRadius(5)
//                
//                Spacer()
//                    .frame(maxHeight: geoH * 0.01)
//                
//                Text("العمل الحالي")
//                    .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
//                    .frame(maxWidth: .infinity, alignment: .trailing) // Push
//                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.032 : geoW * 0.02))
//                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
//
//              
//                    TextField("user1          ", text: $phoneNumber)
//                        .frame(maxWidth: geoH * 0.4)
//                        .frame(maxHeight: geoH * 0.05)
//                        .multilineTextAlignment(.trailing)
//                        .padding(.horizontal)
//                        .background(Color.white)
//                        .cornerRadius(5)
//                
//                Spacer()
//                    .frame(maxHeight: geoH * 0.01)
//                
//                HStack{
//                    
//                    VStack (spacing: 10){
//                        Text("القضاء")
//                            .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
//                            .frame(maxWidth: .infinity, alignment: .trailing) // Push
//                            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.032 : geoW * 0.02))
//                            .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
//
//                      
//                            TextField("user1          ", text: $phoneNumber)
//                                .frame(maxWidth: geoH * 0.4)
//                                .frame(maxHeight: geoH * 0.05)
//                                .multilineTextAlignment(.trailing)
//                                .padding(.horizontal)
//                                .background(Color.white)
//                                .cornerRadius(5)                    }
//                    
//                    
//                    Spacer()
//                        .frame(maxWidth: geoW * 0.05)
//                    
//                    VStack(spacing: 10) {
//                        Text("المحافظة")
//                            .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
//                            .frame(maxWidth: .infinity, alignment: .trailing) // Push
//                            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.032 : geoW * 0.02))
//                            .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
//
//                      
//                            TextField("user1          ", text: $phoneNumber)
//                                .frame(maxWidth: geoH * 0.4)
//                                .frame(maxHeight: geoH * 0.05)
//                                .multilineTextAlignment(.trailing)
//                                .padding(.horizontal)
//                                .background(Color.white)
//                                .cornerRadius(5)
//                    }
//                }
//             
//
//                    
//                
//            } .padding(.horizontal, 40)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color(red: 236/255, green: 242/255, blue: 245/255))
//           
//            ZStack {
//                LogoIUserInfo()
//                    
//            }
//            
//              
//           
//        }
//        // Conditionally show the DatePicker
//                    if isPickerVisible {
//                        DatePicker("Select your birthday", selection: $selectedDate, displayedComponents: .date)
//                            .datePickerStyle(WheelDatePickerStyle()) // This makes it like a picker wheel
//                            .labelsHidden()
//                            .onChange(of: selectedDate) { _ in
//                                // Hide the picker after selection
//                                isPickerVisible = false
//                            }
//                            .padding()
//                    }
//        
//         
//    
//    }
//    
//}
//
//
//
//// A function to format the date
//   func formattedDate(_ date: Date) -> String {
//       let formatter = DateFormatter()
//       formatter.dateStyle = .medium
//       return formatter.string(from: date)
//   }
//
//
//#Preview {
//    registerPage()
//}








import SwiftUI

struct registerPage: View {
    
    @State private var name: String = ""
    @State private var birthDay: String = ""
    @State private var phoneNumber: String = ""
    @State private var isNavigate: Bool = false
    @State private var selectedDate: Date = Date() // The date the user selects
    @State private var isPickerVisible: Bool = false // Controls visibility of the picker
    
    var body: some View {
        GeometryReader { geometry in
            let geoH = geometry.size.height
            let geoW = geometry.size.width
            
            VStack(spacing: 10) {
                
                Text("الأسم الرباعي واللقب")
                    .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                    .frame(maxWidth: .infinity, alignment: .trailing) // Push
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.035 : geoW * 0.02))
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
                
                TextField("", text: $name)
                    .frame(maxWidth: geoH * 0.4)
                    .frame(maxHeight: geoH * 0.05)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                
                Spacer().frame(maxHeight: geoH * 0.01)
                
                Text("تاريخ الولادة")
                    .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                    .frame(maxWidth: .infinity, alignment: .trailing) // Push
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.035 : geoW * 0.02))
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
                
//                HStack {
                    // TextField to show selected date
                    TextField("Select your birthday", text: Binding(
                        get: { formattedDate(selectedDate) },
                        set: { _ in }
                    ))
                    .disabled(true) // Disable typing in the TextField
                    .frame(maxWidth: geoH * 0.4)
                    .frame(maxHeight: geoH * 0.05)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay{
                        Button(action: {
                            isPickerVisible.toggle() // Toggle the DatePicker visibility
                        }) {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                                .padding(.trailing, 10)
                        }.offset(x: UIDevice.current.userInterfaceIdiom == .phone ? geoW * -0.3 : geoW * -0.2)
                    }
                      
                    
                    // Calendar icon button
                  
//                }
//                .frame(maxWidth: geoH * 0.4)
                
                Spacer().frame(maxHeight: geoH * 0.01)
                
                Text("رقم الهاتف الخاص بالأستاذ")
                    .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                    .frame(maxWidth: .infinity, alignment: .trailing) // Push
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.035 : geoW * 0.02))
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
                
                TextField("", text: $phoneNumber)
                    .frame(maxWidth: geoH * 0.4)
                    .frame(maxHeight: geoH * 0.05)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                
                Spacer().frame(maxHeight: geoH * 0.01)
                
                Text("التحصيل الحوزوي او الدراسي ( مع التخصص الدقيق)")
                    .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                    .frame(maxWidth: .infinity, alignment: .trailing) // Push
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.032 : geoW * 0.02))
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
                
                TextField("", text: $phoneNumber)
                    .frame(maxWidth: geoH * 0.4)
                    .frame(maxHeight: geoH * 0.05)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                
                Spacer().frame(maxHeight: geoH * 0.01)
                
                Text("العمل الحالي")
                    .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                    .frame(maxWidth: .infinity, alignment: .trailing) // Push
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.032 : geoW * 0.02))
                    .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
                
                TextField("", text: $phoneNumber)
                    .frame(maxWidth: geoH * 0.4)
                    .frame(maxHeight: geoH * 0.05)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                
                Spacer().frame(maxHeight: geoH * 0.01)
                
          
                    
                
                        Text("رمز المحافظة")
                            .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                            .frame(maxWidth: .infinity, alignment: .trailing) // Push
                            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.032 : geoW * 0.02))
                            .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? geoW * 0.2 : geoW * 0.05)
                        
                        TextField("", text: $phoneNumber)
                            .frame(maxWidth: geoH * 0.4)
                            .frame(maxHeight: geoH * 0.05)
                            .multilineTextAlignment(.trailing)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(5)
                
                
                
                HStack {
                    
                    Image("Group 9")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geoW * 0.05)
                        .padding(.vertical, geoH * 0.01)
                        .padding(.leading, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.05: geoW * 0.025)
                    
                    
                    
                    Button(action: {
                        // Action for previous button
                    }) {
                        Text("السابق")
                            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.04 : geoW * 0.03))
                            .foregroundStyle(Color(UIColor(red: 90 / 255, green: 97 / 255, blue: 103 / 255, alpha: 1.0))
)
                    }
                    .padding(.horizontal, geoW * 0.005)
                   // .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Image("Line 1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geoH * 0.01 ,height: geoH * 0.04)
                        .padding(.vertical, geoH * 0.01)
                    
                    Button(action: {
                        // Action for next button
                        
                        isNavigate = true
                    }) {
                        Text("التالي")
                            .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.04 : geoW * 0.03))
                    }
                    .padding(.horizontal, geoW * 0.005)
                   // .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .navigationDestination(isPresented: $isNavigate) {
                        registerPage()
                    }
                    
                    
                    Image("Group 16")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geoW * 0.05)
                        .padding(.vertical, geoH * 0.01)
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.05: geoW * 0.025 )
                    
                    
                    
                }.background(Color(UIColor(red: 20 / 255, green: 30 / 255, blue: 39 / 255, alpha: 1.0)))
                    .cornerRadius(5)
                    .padding()
                
            }
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
            
            ZStack {
                LogoIUserInfo()
            }
        }
        // Show the DatePicker as a sheet
        .sheet(isPresented: $isPickerVisible) {
            VStack {
                DatePicker("Select your birthday", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding()
                
                Button("Done") {
                    isPickerVisible = false
                }
                .font(.headline)
                .padding()
            }
            .presentationDetents([.medium])
        }
    }
    
    // A function to format the date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    registerPage()
}

