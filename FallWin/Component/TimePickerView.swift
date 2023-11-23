//
//  TimePickerView.swift
//  FallWin
//
//  Created by 최명근 on 11/22/23.
//

import SwiftUI

struct TimePickerView: View {
    var onDateSet: ((Int, Int) -> Void)
    
    @State private var selected: Date
    
    @Environment(\.dismiss) var dismiss
    
    init(hour: Int, minute: Int, _ onDateSet: @escaping (Int, Int) -> Void) {
        self.onDateSet = onDateSet
        self._selected = .init(initialValue: Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) ?? Date())
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("date_picker_title")
                    .font(.pretendard(.semiBold, size: 18))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                DatePicker("asdf", selection: $selected, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                
                Spacer()
                
                Button {
                    dismiss()
                    onDateSet(selected.hour, selected.minute)
                } label: {
                    ConfirmButtonLabelView(text: "confirm".localized, backgroundColor: .button, foregroundColor: .textOnButton)
                }
            }
            .padding()
        }
    }
}

#Preview {
    TimePickerView(hour: 21, minute: 0) { hour, minute in
        
    }
}
