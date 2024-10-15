//
//  NotificationChannelSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 15/10/2024.
//

import SwiftUI

struct NotificationChannelSection: View {
    var body: some View {
        
        VStack{
            ScrollView{
                
                VStack {
                    HStack{
                        Spacer()
                        Text("عنوان الرسالة")
                        
                    }
                    Spacer()
                        .frame(height: screenHeight * 0.03)
                    
                   Text("وقد شهدت أروقة جامعة القادسيّة أولى هذه الجلسات التي انعقدت في الأقسام الداخلية بحضور عدد كبير من الطلبة، إذ قدّم المحاضرة الشيخ حيدر اليونسيّ، متناولًا فيها أهمّيّة التغيير الإيجابيّ، وضرورة اتّباع السلوك القويم المتوافق مع مبادئ الشريعة الإسلاميّة . وقد شهدت أروقة جامعة القادسيّة أولى هذه الجلسات التي انعقدت في الأقسام الداخلية بحضور عدد كبير من الطلبة، إذ قدّم المحاضرة الشيخ حيدر اليونسيّ، متناولًا فيها أهمّيّة التغيير الإيجابيّ، وضرورة اتّباع السلوك القويم المتوافق مع مبادئ الشريعة الإسلاميّة ." )
                        
                    
                }
                
                .padding(screenWidth * 0.09)
                    .multilineTextAlignment(.trailing)
                    .background(Color.white)
                    .cornerRadius(5)
                    
                
                
            }
        }
        .background(Color(red: 236 / 255, green: 242 / 255, blue: 245 / 255))
        
        
    }
}

#Preview {
    NotificationChannelSection()
}
