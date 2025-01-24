//
//  test.swift
//  nafidhalbasayra
//
//  Created by muhammad on 23/01/2025.
//



import SwiftUI

struct ContentViewCity: View {
    @StateObject private var dataFetcher = DataFetcherCity()

    var body: some View {
        NavigationView {
            List(dataFetcher.governorates) { governorate in
                VStack(alignment: .leading) {
                    Text("المحافظة: \(governorate.governorateName)")
                        .font(.headline)
                    Text("الكود: \(governorate.governorateCode)")
                    Text("عدد الطلاب: \(governorate.totalStudentsNumber ?? 0)")
                    Text("عدد المدرسين: \(governorate.totalTeachersNumber ?? 0)")
                }
            }
            .navigationTitle("المحافظات")
            .overlay {
                if dataFetcher.showProgress {
                    ProgressView("جاري التحميل...")
                }
            }
            .alert(item: $dataFetcher.errorMessage) { error in
                Alert(
                    title: Text("خطأ"),
                    message: Text(error.message),
                    dismissButton: .default(Text("حسنًا"))
                )
            }
            .onAppear {
                dataFetcher.startMonitoring()
                dataFetcher.fetchData()
            }
            .onDisappear {
                dataFetcher.stopMonitoring()
            }
        }
    }
}















//import SwiftUI
//
//struct ContentViewCity: View {
//    @StateObject private var dataFetcher = DataFetcherCity() // استخدام الفئة DataFetcherCity لجلب البيانات
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if dataFetcher.showProgress {
//                    ProgressView("جاري تحميل البيانات...")
//                } else if let errorMessage = dataFetcher.errorMessage {
//                    Text("خطأ: \(errorMessage)")
//                        .foregroundColor(.red)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                } else {
//                    List(dataFetcher.governorates) { governorate in
//                        VStack(alignment: .leading) {
//                            Text(governorate.governorateName)
//                                .font(.headline)
//                            Text("الكود: \(governorate.governorateCode)")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                            Text("رقم المنطقة: \(governorate.regionID)")
//                                .font(.footnote)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                    .listStyle(PlainListStyle())
//                }
//
//                Button(action: {
//                    dataFetcher.fetchData()
//                }) {
//                    Text("إعادة تحميل البيانات")
//                        .font(.headline)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .padding(.top, 10)
//            }
//            .navigationTitle("المحافظات")
//            .padding()
//            .onAppear {
//                dataFetcher.fetchData()
//            }
//            .onDisappear {
//                dataFetcher.stopMonitoring()
//            }
//        }
//    }
//}
