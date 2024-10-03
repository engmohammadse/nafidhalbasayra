//
//  registerPage.swift
//  nafidhalbasayra
//
//  Created by muhammad on 30/09/2024.
//




import SwiftUI

struct registerPage: View {
    
    @State private var name: String = ""
    @State private var birthDay: String = ""
    @State private var phoneNumber: String = ""
    @State private var isNavigate: Bool = false
    @State private var selectedDate: Date = Date() // The date the user selects
    @State private var isPickerVisible: Bool = false // Controls visibility of the picker
    
    
    var body: some View {
        
        ScrollView {
        VStack(spacing: 10) {
            
            
            
            
            Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.05 : screenHeight * 0.10)
            
            Text("الأسم الرباعي واللقب")
                .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                .frame(maxWidth: .infinity, alignment: .trailing) // Push
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            TextField("", text: $name)
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
            
            Spacer().frame(maxHeight: screenHeight * 0.01)
            
            Text("تاريخ الولادة")
                .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                .frame(maxWidth: .infinity, alignment: .trailing) // Push
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            //                HStack {
            // TextField to show selected date
            TextField("Select your birthday", text: Binding(
                get: { formattedDate(selectedDate) },
                set: { _ in }
            ))
            .disabled(true) // Disable typing in the TextField
            .frame(maxWidth: screenHeight * 0.4)
            .frame(height: screenHeight * 0.05)
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
                }.offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.3 : screenWidth * -0.2)
            }
            
            
            
            
            Spacer().frame(maxHeight: screenHeight * 0.01)
            
            Text("رقم الهاتف الخاص بالأستاذ")
                .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                .frame(maxWidth: .infinity, alignment: .trailing) // Push
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            TextField("", text: $phoneNumber)
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
            
            Spacer().frame(maxHeight: screenHeight * 0.01)
            
            Text("التحصيل الحوزوي او الدراسي ( مع التخصص الدقيق)")
                .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                .frame(maxWidth: .infinity, alignment: .trailing) // Push
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            TextField("", text: $phoneNumber)
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
            
            Spacer().frame(maxHeight: screenHeight * 0.01)
            
            Text("العمل الحالي")
                .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                .frame(maxWidth: .infinity, alignment: .trailing) // Push
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            TextField("", text: $phoneNumber)
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
            
            Spacer().frame(maxHeight: screenHeight * 0.01)
            
            
            
            
            Text("رمز المحافظة")
                .alignmentGuide(.leading) { d in d[.trailing] } // Custom alignment
                .frame(maxWidth: .infinity, alignment: .trailing) // Push
                .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
            
            TextField("", text: $phoneNumber)
                .frame(maxWidth: screenHeight * 0.4)
                .frame(height: screenHeight * 0.05)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(5)
            
            
            // bottom
           // Spacer().frame(height: screenHeight * 0.05)
            
        }
        .padding(.horizontal,UIScreen.main.bounds.width < 500 ? 16 : 0)
//        .ignoresSafeArea(.keyboard)
            
            
                
            
            
            VStack(spacing: 0){
                PreviousNextButton(previousAction: {}, nextAction: {}, geoW: screenWidth, geoH: screenHeight, isNextNavigating: true, isPreviosNavigating: true, destination: AnyView(EmptyView()), destinationBack: AnyView(LoginPageWelcom()) , color: Color.white, imageName: "Group 9")
            }.offset(y: screenHeight * 0.08)
                
    }
            
            .padding(UIScreen.main.bounds.width < 400 ? 16 : 0)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 236/255, green: 242/255, blue: 245/255))
            .overlay{
                LogoIUserInfo()
                    .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
            }
        
        
        
        
            .ignoresSafeArea(edges: .bottom)
         
//            ZStack {
//              
//                    LogoIUserInfo()
//                
//            }
            
            
   
        .navigationBarBackButtonHidden(true)
        
        
        
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

