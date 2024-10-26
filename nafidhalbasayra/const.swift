//
//  const.swift
//  nafidhalbasayra
//
//  Created by muhammad on 25/09/2024.
//

import Foundation
import UIKit


func dynamicFontSize1() -> CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    if screenWidth > 1000 { // Large screens like iPads
        return 60
    } else if screenWidth > 600 { // Medium screens like large phones or small tablets
        return 40
        
    }else if screenWidth > 250  {
            return 30
        
    } else { // Small screens like phones
        return 25
    }
}



func dynamicFontSize2() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth > 1000 { // Large screens like iPads
            return 30
        } else if screenWidth > 600 { // Medium screens like large phones
            return 20
        } else { // Small screens like iPhones
            return 15
        }
    }



import SwiftUI

// Extension to create a custom modifier for hiding the keyboard
extension View {
    func hideKeyboard() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
