//
//  UIViewController.swift
//  nafidhalbasayra
//
//  Created by muhammad on 27/03/2025.
//

import Foundation

import SwiftUI

import UIKit


class PortraitOnlyViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}




struct PortraitOnlyView: View {
    var body: some View {
        PortraitOnlyViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all) // اجعل الـ View يغطي كامل الشاشة
    }
}

struct PortraitOnlyViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return PortraitOnlyViewController() // العودة إلى الـ UIViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


