//
//  LoginPageWelcom.swift
//  nafidhalbasayra
//
//  Created by muhammad on 29/09/2024.
//

import SwiftUI

struct LoginPageWelcom: View {
    var body: some View {
        
        GeometryReader { geometry in
            
            let geoH = geometry.size.height
            let geoW = geometry.size.width
            
            VStack{
                
                HStack{
                    Text("اهلا وسهلا بكم في تطبيق نافذ البصيرة")
                    
                }
                
            }
        }
    }
}

#Preview {
    LoginPageWelcom()
}
