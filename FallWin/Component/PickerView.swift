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
    @Binding var journals: [Journal]
    
    private var checkDateValid: ((Date) -> Date)? = nil
    
    init(isPickerShown: Binding<Bool>, pickedDateTagValue: Binding<DateTagValue>, journals: Binding<[Journal]>, checkDateValid: ((Date) -> Date)? = nil) {
        self._isPickerShown = isPickerShown
        self._pickedDateTagValue = pickedDateTagValue
        self._journals = journals
        
        self.pickedYear = pickedDateTagValue.wrappedValue.year
        self.pickedMonth = pickedDateTagValue.wrappedValue.month
        
        self.checkDateValid = checkDateValid
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
                        ForEach(1900...Date().year, id: \.self) { year in
                            Text(String(describing: year) + "년").tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    Picker("Month", selection: $pickedMonth) {
                        ForEach(1...maxMonthsInYear(year: pickedYear), id: \.self) { month in
                            Text(String(describing: month) + "월").tag(month)
                        }
                    }
                    .pickerStyle(.wheel)
                    Spacer()
                }
                Button {
                    pickedDateTagValue.year = pickedYear
                    pickedDateTagValue.month = pickedMonth
                    pickedDateTagValue.updateTagValue(journals: journals)
                    pickedDateTagValue.isScrolling.toggle()
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
    
    func maxMonthsInYear(year: Int) -> Int {
        if year == Date().year {
            return Date().month
        } else {
            return 12
        }
    }
    
    func getLastTimestamp(year: Int, month: Int, elementType: DateElementInPicker) -> Int {
        
        let years = journals.map( { DateTagValue(date: $0.timestamp ?? Date()).year } )
        let months = journals.map( { DateTagValue(date: $0.timestamp ?? Date()).month } )
        
        switch elementType {
        case .year:
            if years.contains(year) && months.contains(month) {
                return year
            } else {
                return pickedYear
            }
        default:
            if years.contains(year) && months.contains(month) {
                return month
            } else {
                return pickedMonth
            }
        }
    }
}

struct MonthDayYearPickerView: View {
    
    @State var selectedYear: Int = Date().year
    @State var selectedMonth: Int = Date().month
    @State var selectedDay: Int = Date().day
    
    @Binding var pickedDateTagValue: DateTagValue
    @Binding var isPickerShown: Bool
    
    init(dateTagValue: Binding<DateTagValue>, isPickerShown: Binding<Bool>) {
        self._pickedDateTagValue = dateTagValue
        self._isPickerShown = isPickerShown
        
        self.selectedYear = dateTagValue.wrappedValue.year
        self.selectedMonth = dateTagValue.wrappedValue.month
        self.selectedDay = dateTagValue.wrappedValue.day
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
                        ForEach(1900...Date().year, id: \.self) { year in
                            Text(String(describing: year) + "년").tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(1...maxMonthsInYear(year: selectedYear), id: \.self) { month in
                            Text(String(describing: month) + "월").tag(month)
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
                    pickedDateTagValue.month = selectedMonth
                    pickedDateTagValue.year = selectedYear
                    pickedDateTagValue.day = selectedDay
                    isPickerShown.toggle()
                } label: {
                    ConfirmButtonLabelView(text: "확인", backgroundColor: .button, foregroundColor: .textOnButton)
                }
            }
        }
        .onAppear {
            self.selectedYear = pickedDateTagValue.year
            self.selectedMonth = pickedDateTagValue.month
            self.selectedDay = pickedDateTagValue.day
        }
    }
    
    func maxMonthsInYear(year: Int) -> Int {
        if year == Date().year {
            return Date().month
        } else {
            return 12
        }
    }
    
    func maxDaysInMonth(year: Int, month: Int) -> Int? {
        if year == Date().year && month == Date().month {
            return Date().day
        } else {
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
}

#Preview {
    YearMonthPickerView(isPickerShown: .constant(true), pickedDateTagValue: .constant(DateTagValue(date: Date())), journals: .constant([Journal()]))
//    MonthDayYearPickerView(yearRange: 1990...2023)
}
