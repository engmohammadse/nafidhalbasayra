//
//  AdaptiveTextFieldView.swift
//  nafidhalbasayra
//
//  Created by Muhammad Alaraji on 29/09/2024.
//

import SwiftUI

struct AdaptiveTextFieldView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Adaptive TextField
                TextField("Enter text", text: .constant(""))
                    .padding()
                    .font(.system(size: getFontSize(for: geometry.size)))
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding()

                // Adaptive Text
                Text("Adaptive Text")
                    .font(.system(size: getFontSize(for: geometry.size)))
                    .padding()
            }
            .padding()
        }
    }

    // Helper function to adjust the font size based on device type
    func getFontSize(for size: CGSize) -> CGFloat {
        if horizontalSizeClass == .regular {
            // Regular size class (iPads)
            return size.width * 0.05 // Scaled for iPads
        } else {
            // Compact size class (iPhones)
            return size.width * 0.04 // Scaled for iPhones
        }
    }
}

struct AdaptiveTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AdaptiveTextFieldView()
                .previewDevice("iPhone 14 Pro")
            AdaptiveTextFieldView()
                .previewDevice("iPad Pro (11-inch)")
        }
    }
}


// v , h
//
//import SwiftUI
//
//struct AdaptiveTextFieldView: View {
//    @Environment(\.horizontalSizeClass) var horizontalSizeClass
//    @Environment(\.verticalSizeClass) var verticalSizeClass
//
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                // Adaptive TextField
//                TextField("Enter text", text: .constant(""))
//                    .padding()
//                    .font(.system(size: getFontSize(for: geometry.size)))
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .padding()
//
//                // Adaptive Text
//                Text("Adaptive Text")
//                    .font(.system(size: getFontSize(for: geometry.size)))
//                    .padding()
//            }
//            .padding()
//        }
//    }
//
//    // Helper function to adjust font size based on device type and orientation
//    func getFontSize(for size: CGSize) -> CGFloat {
//        if horizontalSizeClass == .regular {
//            // For iPads
//            return verticalSizeClass == .compact ? size.width * 0.04 : size.width * 0.05
//        } else {
//            // For iPhones
//            return verticalSizeClass == .compact ? size.width * 0.035 : size.width * 0.04
//        }
//    }
//}
//
//struct AdaptiveTextFieldView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            AdaptiveTextFieldView()
//                .previewDevice("iPhone 14 Pro")
//            AdaptiveTextFieldView()
//                .previewDevice("iPad Pro (11-inch)")
//        }
//    }
//}
//
