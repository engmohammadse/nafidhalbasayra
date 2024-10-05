//
//  testNavigationStackPop.swift
//  nafidhalbasayra
//
//  Created by muhammad on 05/10/2024.
//

//import SwiftUI
//
//struct ContentView1: View {
//    @State private var path = NavigationPath()
//
//    var body: some View {
//        NavigationStack(path: $path) {
//            VStack {
//                NavigationLink("Go to Next Page", value: "NextPage")
//            }
//            .navigationDestination(for: String.self) { value in
//                if value == "NextPage" {
//                    NextView(path: $path)
//                }
//            }
//        }
//    }
//}
//
//struct NextView: View {
//    @Binding var path: NavigationPath
//
//    var body: some View {
//        VStack {
//            Text("Next Page : path.removeLast")
//            Button("Pop to Previous: path.removeLast") {
//                path.removeLast() // Pops the last view
//            }
//        }
//        .navigationTitle("Next Page")
//    }
//}









import SwiftUI

struct ContentView1: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Go to Next Page", destination: NextView())
            }
        }
    }
}

struct NextView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("Next Page")
            Button("Pop to Previous") {
                dismiss() // Pops the view
            }
        }
        .navigationTitle("Next Page")
    }
}



#Preview {
    ContentView1()
}





