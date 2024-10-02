//
//  PreviousNextBotton.swift
//  nafidhalbasayra
//
//  Created by muhammad on 02/10/2024.




import SwiftUI

struct PreviousNextButton: View {
    var previousAction: () -> Void
    var nextAction: () -> Void
    var geoW: CGFloat
    var geoH: CGFloat
    var isNextNavigating: Bool
    var isPreviosNavigating: Bool
    var destination: AnyView
    var destinationBack: AnyView
    var color : Color
    var imageName: String
    
    @State private var isNavigateNext: Bool = false
    @State private var isNavigatePrevious: Bool = false
    
    
    var body: some View {
        HStack {
            // Previous button icon
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
              //  .renderingMode(.template)  // Forces the image to be drawn as a template (grayscale)
                .frame(maxWidth: geoW * 0.05)
                .padding(.vertical, geoH * 0.01)
                .padding(.leading, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.02 : geoW * 0.001)
            
                .foregroundColor(color)

            
            // Previous button
            
            //
            Button(action: {
                previousAction()
                if isPreviosNavigating {
                    isNavigatePrevious = true
                }
                
            }) {
                Text("السابق")
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.04 : geoW * 0.03))
                    .foregroundColor(color)
//                    .foregroundStyle(Color(UIColor(red: 90 / 255, green: 97 / 255, blue: 103 / 255, alpha: 1.0)))
            }
            .padding(.horizontal, geoW * 0.002)
            .foregroundColor(.white)
            .cornerRadius(10)
            .navigationDestination(isPresented: $isNavigatePrevious) {
                destinationBack
            }
            
            // Divider line
            Image("Line 1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geoH * 0.01, height: geoH * 0.04)
                .padding(.vertical, geoH * 0.008)
            
            // Next button
            Button(action: {
                nextAction()
                if isNextNavigating {
                    isNavigateNext = true
                }
            }) {
                Text("التالي")
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.04 : geoW * 0.03))
            }
            .padding(.horizontal, geoW * 0.002)
            .foregroundColor(.white)
            .cornerRadius(10)
            .navigationDestination(isPresented: $isNavigateNext) {
                destination
            }
            
            // Next button icon
            Image("Group 16")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: geoW * 0.05)
                .padding(.vertical, geoH * 0.01)
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .phone ? geoW * 0.02 : geoW * 0.001)
        }
        .background(Color(UIColor(red: 20 / 255, green: 30 / 255, blue: 39 / 255, alpha: 1.0)))
        .cornerRadius(5)
        .padding()
        
    }
}

#Preview {
    PreviousNextButton(
        previousAction: {
            print("Previous tapped")
        },
        nextAction: {
            print("Next tapped")
        },
        geoW: 300, // Example width
        geoH: 600, // Example height
        isNextNavigating: true,
        isPreviosNavigating: true,
        destination: AnyView(Text("Next Page")), destinationBack: AnyView(Text("Previous Page")),
        color: Color.gray,
        imageName: "Group 9_5"
    )
}
