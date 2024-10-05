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
    @State private var selectedDate: Date = Date()
    @State private var isPickerVisible: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var activeField: Field?
    @State private var academicLevel: String = ""
    @State private var currentWork: String = ""
    @State private var cityNumber: String = ""

    enum Field {
        case academicLevel, currentWork, cityNumber
    }
    
    var body: some View {

        VStack {
            
            
            ScrollView {
                VStack(spacing: 10) {
                    
                    Spacer().frame(height: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.03 : screenHeight * 0.10)
                    
                    // Field: Name
                    Text("الأسم الرباعي واللقب")
                        .alignmentGuide(.leading) { d in d[.trailing] }
                        .frame(maxWidth: .infinity, alignment: .trailing)
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
                    
                    // Field: Birth Day
                    Text("تاريخ الولادة")
                        .alignmentGuide(.leading) { d in d[.trailing] }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.035 : screenWidth * 0.02))
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
                    
                    TextField("Select your birthday", text: Binding(
                        get: { formattedDate(selectedDate) },
                        set: { _ in }
                    ))
                    .disabled(true)
                    .frame(maxWidth: screenHeight * 0.4)
                    .frame(height: screenHeight * 0.05)
                    .multilineTextAlignment(.trailing)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(5)
                    .overlay{
                        Button(action: {
                            isPickerVisible.toggle()
                        }) {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                                .padding(.trailing, 10)
                        }.offset(x: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * -0.3 : screenWidth * -0.2)
                    }
                    
                    Spacer().frame(maxHeight: screenHeight * 0.01)
                    
                    // Field: Phone Number
                    Text("رقم الهاتف الخاص بالأستاذ")
                        .alignmentGuide(.leading) { d in d[.trailing] }
                        .frame(maxWidth: .infinity, alignment: .trailing)
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
                    
                    // Field: Academic Level
                    Text("التحصيل الحوزوي او الدراسي ( مع التخصص الدقيق)")
                        .alignmentGuide(.leading) { d in d[.trailing] }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
                    
                    TextField("", text: $academicLevel)
                        .frame(maxWidth: screenHeight * 0.4)
                        .frame(height: screenHeight * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                        .focused($activeField, equals: .academicLevel)
                    
                    Spacer().frame(maxHeight: screenHeight * 0.01)
                    
                    // Field: Current Work
                    Text("العمل الحالي")
                        .alignmentGuide(.leading) { d in d[.trailing] }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
                    
                    TextField("", text: $currentWork)
                        .frame(maxWidth: screenHeight * 0.4)
                        .frame(height: screenHeight * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                        .focused($activeField, equals: .currentWork)
                    
                    Spacer().frame(maxHeight: screenHeight * 0.01)
                    
                    // Field: City Number
                    Text("رمز المحافظة")
                        .alignmentGuide(.leading) { d in d[.trailing] }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                        .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? screenWidth * 0.2 : screenWidth * 0.05)
                    
                    TextField("", text: $cityNumber)
                        .frame(maxWidth: screenHeight * 0.4)
                        .frame(height: screenHeight * 0.05)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(5)
                        .focused($activeField, equals: .cityNumber)
                    
                }
                
                .padding(.horizontal, UIScreen.main.bounds.width < 500 ? 16 : 0)
                .offset(y: calculateOffset()) // Apply offset only for the bottom fields
                .onAppear {
                    self.addKeyboardObservers()
                }
                .onDisappear {
                    self.removeKeyboardObservers()
                }
                
                
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
            
            
            
            
            
            .sheet(isPresented: $isPickerVisible) {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                isPickerVisible = false
                            }
                        }
                    }
            }
            
          
           
            
        }.navigationBarBackButtonHidden(true)
            .overlay{
                
                
                PreviousNextButton(previousAction: {}, nextAction: {}, geoW: screenWidth, geoH: screenHeight, isNextNavigating: true, isPreviosNavigating: true, destination: AnyView(ContentView1()), destinationBack: AnyView(LoginPageWelcom()) , color: Color.white, imageName: "Group 9")
             
                    .offset(y: UIScreen.main.bounds.width < 400 ? screenHeight * 0.43 : screenHeight * 0.4)
                
            }
        
        
        
       
            
      
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
    
    // Remove keyboard observers
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

#Preview {
    registerPage()
}
    











    
    
    
















