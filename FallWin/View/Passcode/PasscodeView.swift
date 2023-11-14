//
//  PasscodeView.swift
//  FallWin
//
//  Created by 최명근 on 11/1/23.
//

import SwiftUI
import LocalAuthentication

struct PasscodeView: View {
    
    enum AfterAction {
        case none
        case dismiss
        case retype(_ message: String)
    }
    
    enum PasscodePad: Hashable {
        case biometric
        case delete
        case number(Int)
    }
    
    // PasscodeView options
    private var dismissable: Bool
    private var biometric: Bool
    private var authenticateOnLaunch: Bool
    private var onPasswordEntered: (_ typed: String?, _ biometric: Bool?) -> AfterAction
    
    @State private var typed: [Int] = []
    @State private var temp: [Int] = []
    
    @State private var message: String
    
    @Environment(\.dismiss) var dismiss
    
    private let laContext: LAContext = LAContext()
    private let pad: [PasscodePad] = [
        .number(1), .number(2), .number(3),
        .number(4), .number(5), .number(6),
        .number(7), .number(8), .number(9),
        .biometric, .number(0), .delete
    ]
    
    init(initialMessage: String = "password_type".localized, dismissable: Bool = false, enableBiometric: Bool = true, authenticateOnLaunch: Bool = true, onPasswordEntered: @escaping (_ typed: String?, _ biometric: Bool?) -> AfterAction) {
        self._message = State(initialValue: initialMessage)
        self.dismissable = dismissable
        self.biometric = enableBiometric
        self.authenticateOnLaunch = authenticateOnLaunch
        self.onPasswordEntered = onPasswordEntered
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()
            
            VStack {
                if dismissable {
                    HStack {
                        Button {
                            dismiss()
                            
                        } label: {
                            Image(systemName: "xmark")
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(.ultraThickMaterial)
                                )
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                
                Spacer()
                
                Text(message)
                    .font(.pretendard(.semiBold, size: 24))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                HStack(spacing: 16) {
                    ForEach(0..<6) { number in
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: 28, height: 48)
                            .opacity(number < typed.count ? 0.8 : 0.1)
                    }
                }
                
                Spacer()
                
                LazyVGrid(columns: Array(repeating: GridItem(alignment: .center), count: 3), alignment: .center, spacing: 24) {
                    ForEach(pad, id: \.self) { pad in
                        switch pad {
                        case .number(let number):
                            numberButton(number: number)
                            
                        case .delete:
                            deleteButton
                            
                        case .biometric:
                            if biometric &&
                                UserDefaults.standard.bool(forKey: UserDefaultsKey.Settings.biometric) &&
                                laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) &&
                                laContext.biometryType != .none {
                                biometricButton
                                    .onAppear {
                                        if authenticateOnLaunch {
                                            authenticateViaBiometric()
                                        }
                                    }
                            } else {
                                Spacer()
                            }
                        }
                    }
                }
                .frame(maxWidth: 360)
                .padding()
            }
        }
    }
    
    private var biometricButton: some View {
        Button {
            authenticateViaBiometric()
            
        } label: {
            var icon: String = {
                if laContext.biometryType == .touchID {
                    return "touchid"
                } else if laContext.biometryType == .faceID {
                    return "faceid"
                } else if #available(iOS 17, *), laContext.biometryType == .opticID {
                    return "opticid"
                } else {
                    return "exclamationmark.triangle"
                }
            }()
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24)
                .padding(24)
                .background(
                    Circle()
                        .fill(.backgroundPrimary)
                )
        }
    }
    
    private var deleteButton: some View {
        Button {
            if !typed.isEmpty {
                typed.removeLast()
            }
            
        } label: {
            Image(systemName: "delete.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24)
                .padding(24)
                .background(
                    Circle()
                        .fill(.backgroundPrimary)
                )
        }
        .disabled(typed.isEmpty)
    }
    
    @ViewBuilder
    private func numberButton(number: Int) -> some View {
        Button {
            typed.append(number)
            
            if typed.count >= 6 {
                validate(typed: convert(array: typed), biometric: nil)
            }
            
        } label: {
            Text(String(format: "%d", number))
                .font(.pretendard(.medium, size: 24))
                .padding(24)
                .background(
                    Circle()
                        .fill(.backgroundPrimary)
                )
                .shadow(color: .shadow.opacity(0.1), radius: 8, y: 4)
        }
    }
    
    private func authenticateViaBiometric() {
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "일기장 잠금 해제") { success, error in
                if let error = error {
                    print(error)
                }
                if success {
                    validate(typed: nil, biometric: true)
                }
            }
        }
    }
    
    private func convert(array: [Int]) -> String {
        var string = ""
        for i in array {
            string.append(String(i))
        }
        return string
    }
    
    private func validate(typed: String?, biometric: Bool?) {
        switch onPasswordEntered(typed, biometric) {
        case .none:
            break
            
        case .dismiss:
            dismiss()
            
        case .retype(let message):
            self.typed.removeAll()
            self.message = message
        }
    }
}

#Preview {
    PasscodeView(initialMessage: "Hello, world!", dismissable: false, enableBiometric: true, authenticateOnLaunch: true) { typed, biometric in
        return .retype("Retype")
    }
}
