//
//  LogicHistoryAttendanceUpdateState.swift
//  nafidhalbasayra
//
//  Created by muhammad on 13/11/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedGender: String? = nil // القيمة الافتراضية
    let genders = ["ذك","اختر"] // الخيارات

    var body: some View {
        VStack(spacing: 16) {
//            Text("اختر النوع:")
//                .font(.headline)

            Picker(selection: $selectedGender, label: Text(selectedGender ?? "اختر")
                .foregroundColor(selectedGender == nil ? .gray : .primary)
            ) {
                ForEach(genders, id: \.self) { gender in
                    Text(gender).tag(Optional(gender)) // نستخدم Optional لضمان دعم القيمة الافتراضية
                }
            }
            .pickerStyle(MenuPickerStyle()) // قائمة خفيفة منسدلة

//            if let selectedGender = selectedGender {
//                Text("لقد اخترت: \(selectedGender)")
//                    .font(.subheadline)
//            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
