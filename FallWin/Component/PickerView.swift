//
//  PickerView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/7/23.
//

import SwiftUI

struct YearMonthPickerView: View {
    @State var selectedYear: Int = Date().year
    @State var selectedMonth: Int = Date().month
    @State var isCompleted: Bool = false
    
    var years: [Int]
    let months: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    
    init(yearRange: ClosedRange<Int>) {
        self.years = Array(yearRange)
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
            VStack {
                Text("날짜 변경하기")
                    .font(.pretendard(.semiBold, size: 18))
                    .foregroundColor(.textPrimary)
                HStack(spacing: 0) {
                    Spacer()
                    Picker("Year", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(describing: year) + "년").tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(months, id: \.self) { month in
                            Text(String(describing: month) + "월").tag(month)
                        }
                    }
                    .pickerStyle(.wheel)
                    Spacer()
                }
                Button {
                    isCompleted = true
                } label: {
                    ConfirmButtonLabelView(text: "확인", backgroundColor: .button, foregroundColor: .textOnButton)
                }
            }
        }
    }
}

#Preview {
    YearMonthPickerView(yearRange: 1990...2023)
}
