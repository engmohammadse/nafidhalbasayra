//
//  register.swift
//  nafidhalbasayra
//
//  Created by muhammad on 09/10/2024.
//

import SwiftUI

struct registerPage3: View {
    var body: some View {
        VStack {
            
            Image("Group 3")
            Spacer()
                .frame(height: screenHeight * 0.05)
            
            VStack{
                Text("تجري مراجعة بياناتك، يرجى الانتظار قد يستغرق الامر بضع ساعات سيصلك اشعار بمجرد انتهاء مراجعة بياناتك")
                    .font(.custom("BahijTheSansArabic-Bold", size: UIDevice.current.userInterfaceIdiom == .phone ? screenWidth * 0.032 : screenWidth * 0.02))
                    .multilineTextAlignment(.center)
                   
            }
            .padding()
            .background(Color(red: 17/255, green: 75/255, blue: 63/255).opacity(0.15))
            .cornerRadius(5)
        }
        .padding(UIScreen.main.bounds.width < 400 ? 16 : 0)
            .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 236/255, green: 242/255, blue: 245/255))
        .overlay {
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
        }
        .navigationBarBackButtonHidden(true)
        .overlay {
            PreviousNextButton(previousAction: {}, nextAction: {}, geoW: screenWidth, geoH: screenHeight, isNextNavigating: true, isPreviosNavigating: true, destination: AnyView(registerPage2()), destinationBack: AnyView(LoginPageWelcom()), color: Color.white, imageName: "Group 9")
                .offset(y: UIScreen.main.bounds.width < 400 ? screenHeight * 0.43 : screenHeight * 0.42)

        }
    }
}

#Preview {
    registerPage3()
}
