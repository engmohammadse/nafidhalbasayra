//
//  StudyPlanSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 20/10/2024.
//

import SwiftUI

struct StudyPlanSection: View {
    @Environment(\.dismiss) var dismiss
  
    
    var body: some View {
        VStack {
            ScrollView {
                
                Spacer()
                    .frame(height: screenHeight * 0.13)
                
                
                VStack(spacing: 0) {
                    
                    
                    
                  Weeks()
                  Weeks()
                  Weeks()
                    // Overlay for Week 1
                 
                    
                    // Week 2
                    // Add similar structure for Week 2 and Week 3
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColorPage)
            
            
        }
        
        .overlay{
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.0 : screenHeight * 0)
             
        }
    
        
        
        
        .overlay{
            ZStack{
                Button(action: {
                    dismiss()
                }) {
                    Image("Group 56")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiDevicePhone ? screenWidth * 0.09 : screenWidth * 0.064)
                }
                .offset(x: screenWidth * 0.46, y: screenHeight * -0.03)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    StudyPlanSection()
        .environmentObject(TeacherDataViewModel())
}


struct LectureView: View {
    var number: Int
    var body: some View {
        HStack {
            
            
            Button(action: {}) {
                Text("مشاهدة")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                    .foregroundColor(primaryColor)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .frame(minWidth: 80)
                    .background(buttonAccentColor)
                    .cornerRadius(10)
                    .underline()
                   
            }
            
            
            
            Spacer(minLength: 10)
            
            Text("الدليل التوضيحي للمحاضرة #\(number)")
                .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.trailing)
            Spacer()
        }
        .padding(8)
        .background(buttonAccentColor)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}



struct Weeks: View {
    @State private var isWeek1Expanded = false
    @State private var isWeek2Expanded = false
    @State private var isWeek3Expanded = false
    
    var body: some View {
        
        // Week 1
        ZStack {
            
            DisclosureGroup(isExpanded: $isWeek1Expanded) {
                VStack {
                    Image("Line 2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth * 0.8)
                        .frame(height: screenHeight * 0.05)
                    VStack{
                        LectureView(number: 1)
                        LectureView(number: 2)
                        LectureView(number: 3)
                        LectureView(number: 4)
                        LectureView(number: 5)
                    } .padding(.bottom)
                    
                }
               
            } label: {
                HStack {
                    // Custom arrow icon on the left
                    Image(systemName: isWeek1Expanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(primaryColor)
                    
                    Spacer() // Pushes the text to the right
                    
                    Text("الأسبوع الأول")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)
                        .multilineTextAlignment(.trailing)
                    
                   
                }
                .padding()
            }
            .background(.white)
            .cornerRadius(5)
            .padding(.horizontal)
            .accentColor(.clear) // Hide the default disclosure arrow
            .frame(width: screenWidth * 0.95)
            
            
            
            Circle()
                .fill(primaryColor)
                .frame(width: screenWidth * 0.065)
                .overlay(Text("1").foregroundColor(.white))
                .position(x: screenWidth * 0.5, y: screenHeight * -0.0) // Fixed position
        }
        .padding(.bottom, screenHeight * 0.03) // Add padding to the bottom for the circle
    }
}
