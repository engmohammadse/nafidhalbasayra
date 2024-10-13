//
//  MainViewPage.swift
//  nafidhalbasayra
//
//  Created by muhammad on 10/10/2024.
//

import SwiftUI

struct MainViewPage: View {
    var body: some View {
        
        
  
        ZStack {
               
                      VStack(spacing: screenHeight * 0.02) {
                          
                          Spacer().frame(height: uiDevicePhone ? screenHeight * 0.42 :  screenHeight * 0.4 )
                          
                          
                          HStack(spacing: screenWidth * 0.04) {
                              VStackSection(imageName: "Group 20", text: "إرسال الحضور")
                              VStackSection(imageName: "Group 19", text: "قناة التبليغات")
                          }
                          
                        //  Spacer().frame(height: screenHeight * 0.0)
                          
                          HStack(spacing: screenWidth * 0.04) {
                              VStackSection(imageName: "Group 24", text: "سجل الحضور")
                              VStackSection(imageName: "Group 23", text: "بيانات الطلبة")
                          }
                          
                         // Spacer().frame(height: screenHeight * 0.02)
                          
                          HStack(spacing: screenWidth * 0.04) {
                              VStackSection(imageName: "Group 29", text: "دليل الاستخدام")
                              VStackSection(imageName: "folder-minus-solid 1", text: "الخطة الدراسية")
                          }
                          
                       
                          
                          
                              
                      }
                     // .background(Color(red: 236/255, green: 242/255, blue: 245/255))
                      .offset(y: screenHeight * -0.17)
                
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .background(Color(red: 236/255, green: 242/255, blue: 245/255))
            
            
               // button setting
                    VStack {
                        
                        ButtonSetting()
                        
                        Spacer()
                            .frame(height: screenHeight * 0.02)
                        HStack{
                            socialMediaButton(url: "https://www.alkafeelquran.com", image: "Group 36")
                            socialMediaButton(url: "https://www.alkafeelquran.com", image: "Group 36")
                            socialMediaButton(url: "https://www.alkafeelquran.com", image: "Group 36")
                            socialMediaButton(url: "https://www.alkafeelquran.com", image: "Group 36")
                            
                        }
                    }
                    .offset(y: screenHeight > 700 ?  screenHeight * 0.37 : screenHeight * 0.36)
            
            //HadeethSection
            
            VStack{
                Spacer().frame(height: uiDevicePhone ? screenHeight * 0.075 : screenHeight * 0.1)
                
                HadeethSection()
                  
                    .overlay(
                        LogoIUserInfo()
                            .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * -0.07 : screenHeight * -0.08)
                    )
            }
            
            
            
              }
   

    
        
            
    }
}

#Preview {
    MainViewPage()
}

//
//.frame(maxWidth: .infinity, maxHeight: .infinity)
//.background(Color(red: 236/255, green: 242/255, blue: 245/255))


//.background(Color(red: 236/255, green: 242/255, blue: 245/255))



struct VStackSection: View {
    let imageName: String
    let text: String
    
    var body: some View {
        VStack {
            
            
            Button(action: {
                
                
            }){
                
                VStack{
                    
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiDevicePhone ? screenWidth * 0.1 : screenWidth * 0.08)
                        .padding(.top, uiDevicePhone ? screenHeight * 0.03 : screenHeight * 0.02)
                    Spacer()
                        .frame(height: screenHeight * 0.02)
                    
                    Text(text)
                        .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03  : screenWidth * 0.025))
                       
                        .foregroundColor(.black)
                        .padding(.horizontal, screenWidth * 0.04)
                        .padding(.bottom, screenHeight * 0.02)
                        .frame(height:  uiDevicePhone ? screenHeight * 0.04 : screenHeight * 0.05)
                        .frame(width: uiDevicePhone ? screenWidth * 0.3 : screenWidth * 0.26)
                    
                }
                
            }
            
            
            
           
        }
        .background(Color.white)
        .cornerRadius(10)
    }
}


struct ButtonSetting: View {
    
    var body: some View {
        
        
        HStack{
            
            Button(action: {}){
                
                Text("الإعدادات")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ?  screenWidth * 0.03  : screenWidth * 0.025))
                    .foregroundStyle(Color.black)
                
                Image("VectorSetting")
            }
        }
        .frame(width: screenWidth * 0.63, height: screenHeight * 0.05)
        .background(Color.white)
        .cornerRadius(5)
        
    }
}




//"https://www.alkafeelquran.com"

import SwiftUI
import SafariServices

struct socialMediaButton: View {
    @State private var showingSafari = false
    @State  var url: String
    @State  var image: String
    
    var body: some View {
       // HStack {
            Button(action: {
                showingSafari = true // Show the Safari view when the button is tapped
            }) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                    .frame(width: screenWidth * 0.12, height: screenHeight * 0.05)
            }
        //}
        .padding(.all, screenWidth * 0.01)
        //.frame(width: screenWidth * 0.12, height: screenHeight * 0.05)
        .background(Color.white)
        .cornerRadius(5)
        .fullScreenCover(isPresented: $showingSafari) {
            SafariView(url: URL(string: url)!)
                .edgesIgnoringSafeArea(.all) // Make the Safari view take up the full screen
        }
    }
}



struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        return safariVC
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        // No updates needed here
    }
}
