//
//  StudyPlanSection.swift
//  nafidhalbasayra
//
//  Created by muhammad on 20/10/2024.
//



import SwiftUI

struct StudyPlanSection: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var lectureVM = LectureViewModel()  // تفعيل ViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                Spacer()
                    .frame(height: screenHeight * 0.13)
                
                VStack(spacing: 0) {
                    // تجميع المحاضرات حسب الأسبوع
                    let groupedLectures = Dictionary(grouping: lectureVM.lectures, by: { $0.week_order })
                    
                    ForEach(groupedLectures.keys.sorted(), id: \.self) { week in
                        if let lectures = groupedLectures[week] {
                            Weeks(weekOrder: week, lectures: lectures)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColorPage)
            .scrollIndicators(.hidden) // ✅ إخفاء شريط التمرير

        }
        .onAppear {
            lectureVM.fetchLectures() // جلب البيانات عند تحميل الصفحة
        }
        .overlay {
            ZStack {
                Button(action: {
                    dismiss()
                }) {
                    Image("Group 56")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiDevicePhone ? screenWidth * 0.09 : screenWidth * 0.064)
                }
                .offset(x: uiDevicePhone ? screenWidth * 0.46 : screenWidth * 0.47, y: screenHeight * -0.03)
            }
        }
        .overlay {
            LogoIUserInfo()
                .offset(y: UIDevice.current.userInterfaceIdiom == .phone ? screenHeight * 0.01 : screenHeight * 0.02)
        }
        .navigationBarBackButtonHidden(true)
    }
}



struct Weeks: View {
    var weekOrder: Int
    var lectures: [Lecture]  // قائمة المحاضرات للأسبوع

    @State private var isExpanded = false
    
    let weekNames: [Int: String] = {
        var weekNames: [Int: String] = [:]
        let baseNames = ["الأول", "الثاني", "الثالث", "الرابع", "الخامس",
                         "السادس", "السابع", "الثامن", "التاسع", "العاشر"]

        for week in 1...52 {
            if week <= 10 {
                weekNames[week] = "الأسبوع \(baseNames[week - 1])"
            } else {
                let suffix = week == 20 ? "العشرون" :
                             week == 30 ? "الثلاثون" :
                             week == 40 ? "الأربعون" :
                             week == 50 ? "الخمسون" :
                             (week % 10 == 1 ? "الحادي" :
                              week % 10 == 2 ? "الثاني" :
                              week % 10 == 3 ? "الثالث" :
                              week % 10 == 4 ? "الرابع" :
                              week % 10 == 5 ? "الخامس" :
                              week % 10 == 6 ? "السادس" :
                              week % 10 == 7 ? "السابع" :
                              week % 10 == 8 ? "الثامن" :
                              week % 10 == 9 ? "التاسع" : "العاشر")
                
                let prefix = week < 20 ? "عشر" :
                             week < 30 ? "عشرون" :
                             week < 40 ? "ثلاثون" :
                             week < 50 ? "أربعون" :
                             "خمسون"
                
                weekNames[week] = week % 10 == 0 ? "الأسبوع \(suffix)" : "الأسبوع \(suffix) \(prefix)"
            }
        }
        return weekNames
    }()

    var body: some View {
        ZStack {
            DisclosureGroup(isExpanded: $isExpanded) {
                VStack {
                    Image("Line 2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth * 0.8)
                        .frame(height: screenHeight * 0.05)
                    
                    VStack {
                        ForEach(Array(lectures.enumerated()), id: \.element.id) { index, lecture in
                            LectureView(number: index + 1, youtubeURL: lecture.youtube_url)  // إعطاء رقم ترتيب داخل كل أسبوع
                        }
                    }
                    .padding(.bottom)
                }
            } label: {
                HStack {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(primaryColor)
                    
                    Spacer()
                    
                    Text(weekNames[weekOrder] ?? "الأسبوع \(weekOrder)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)
                        .multilineTextAlignment(.trailing)
                }
                .padding()
            }
            .background(.white)
            .cornerRadius(5)
            .padding(.horizontal)
            .accentColor(.clear) // إخفاء السهم الافتراضي
            .frame(width: screenWidth * 0.95)

            Circle()
                .fill(primaryColor)
                .frame(width: screenWidth * 0.065)
                .overlay(Text("\(weekOrder)").foregroundColor(.white))
                .position(x: screenWidth * 0.5, y: screenHeight * -0.0)
        }
        .padding(.bottom, screenHeight * 0.03)
    }
}



//#Preview {
//    StudyPlanSection()
//        .environmentObject(TeacherDataViewModel())
//}







struct LectureView: View {
    var number: Int  // رقم المحاضرة داخل الأسبوع
    var youtubeURL: String  // رابط يوتيوب للمحاضرة
    
    var body: some View {
        HStack {
            Button(action: {
                if let url = URL(string: youtubeURL) {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("مشاهدة")
                    .font(.custom("BahijTheSansArabic-Bold", size: uiDevicePhone ? screenWidth * 0.04 : screenWidth * 0.023))
                    .foregroundColor(primaryColor)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .frame(minWidth: 80)
                    .background(buttonAccentColor)
                    .cornerRadius(10)
                    .underline()
            }
            
            Spacer(minLength: 10)
            
            Text("الدليل التوضيحي للمحاضرة #\(number)")
                .font(.custom("BahijTheSansArabic-Plain", size: uiDevicePhone ? screenWidth * 0.0385 : screenWidth * 0.023))
                .foregroundColor(primaryColor)
                .multilineTextAlignment(.trailing)
                .minimumScaleFactor(0.7)
            
            Spacer()
        }
        .padding(8)
        .background(buttonAccentColor)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}















