//
//  PickerView.swift
//  FallWin
//
//  Created by HAN GIBAEK on 11/7/23.
//

import SwiftUI

enum DateElementInPicker {
    case year
    case month
    case day
}

struct YearMonthPickerView: View {
    @State var pickedYear: Int = Date().year
    @State var pickedMonth: Int = Date().month
    @Binding var isPickerShown: Bool
    @Binding var pickedDateTagValue: DateTagValue
    
    var years: [Int]
    
    init(yearRange: ClosedRange<Int>, isPickerShown: Binding<Bool>, pickedDateTagValue: Binding<DateTagValue>) {
        self.years = Array(yearRange)
        self._isPickerShown = isPickerShown
        self._pickedDateTagValue = pickedDateTagValue
        
        self.pickedYear = pickedDateTagValue.wrappedValue.year
        self.pickedMonth = pickedDateTagValue.wrappedValue.month
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
                    Picker("Year", selection: $pickedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(describing: year) + "년").tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    Picker("Month", selection: $pickedMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text(String(describing: month) + "월").tag(month)
                        }
                    }
                    .pickerStyle(.wheel)
                    Spacer()
                }
                Button {
                    pickedDateTagValue.year = pickedYear
                    pickedDateTagValue.month = pickedMonth
                    isPickerShown = false
                } label: {
                    ConfirmButtonLabelView(text: "확인", backgroundColor: .button, foregroundColor: .textOnButton)
                }
            }
        }
        .onAppear {
            pickedYear = $pickedDateTagValue.wrappedValue.year
            pickedMonth = $pickedDateTagValue.wrappedValue.month
        }
    }
}

struct MonthDayYearPickerView: View {
    
    var years: [Int]
    let months: [String] = ["January", "February", "March", "April", "May", "June",
                            "July", "August", "September", "October", "November", "December"]
    
    @State var selectedYear: Int = Date().year
    @State var selectedMonth: Int = Date().month
    @State var selectedDay: Int = Date().day
    
    @State var isCompleted: Bool = false
    
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
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text("\(months[month-1])").tag(month)
                        }
                    }
                    .pickerStyle(.wheel)
                    Picker("Year", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(describing: year) + "년").tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    Picker("Day", selection: $selectedDay) {
                        ForEach(1...(maxDaysInMonth(year: selectedYear, month: selectedMonth) ?? 0), id: \.self) { day in
                            Text(String(describing: day) + "일").tag(day)
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
    
    func maxDaysInMonth(year: Int, month: Int) -> Int? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1 // Set to the 1st day of the selected month
        
        if let date = calendar.date(from: dateComponents) {
            if let range = calendar.range(of: .day, in: .month, for: date) {
                return range.count
            }
        }
        
        return nil // Failed to determine the maximum number of days
    }
}

#Preview {
    YearMonthPickerView(yearRange: 1990...2023, isPickerShown: .constant(true), pickedDateTagValue: .constant(DateTagValue(date: Date())))
//    MonthDayYearPickerView(yearRange: 1990...2023)
}
