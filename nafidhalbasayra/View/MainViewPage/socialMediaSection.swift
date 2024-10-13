//
//  socialMediaSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 13/10/2024.
//




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
                
                    .frame(height: screenWidth * 0.065)
                
                
               
               
            }
        //}
        .padding(.all, screenWidth * 0.015)
        .padding(.horizontal,screenWidth < 400 ? screenWidth * 0.01 : screenWidth * 0.015)
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


#Preview {
    HStack{
        socialMediaButton(url: "https://www.alkafeelquran.com", image: "Group 36")
        socialMediaButton(url: "https://www.alkafeelquran.com", image: "Group 39")
        socialMediaButton(url: "https://www.alkafeelquran.com", image: "Group 40")
        socialMediaButton(url: "https://www.alkafeelquran.com", image: "globe-solid")
        
    }
    .frame(width: 200 ,height: 200 )
    .background(Color.cyan)
}
