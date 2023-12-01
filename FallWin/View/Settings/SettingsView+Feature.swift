//
//  SettingsView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 11/7/23.
//

import Foundation
import ComposableArchitecture

struct SettingsFeature: Reducer {
    struct State: Equatable {
        // App Info
        var appVersion: String = "1.0.0"
        var appBuild: String = "1"
        
        // Profile
        var nickname: String = UserDefaults.standard.string(forKey: UserDefaultsKey.User.nickname) ?? "PICDA"
        var gender: String = UserDefaults.standard.string(forKey: UserDefaultsKey.User.gender) ?? "none"
        var remainingDrawingCount: Int? = FilmManager.shared.drawingCount?.count
        var showNicknameAlert: Bool = false
        var tempNickname: String = ""
        var showCountInfo: Bool = false
        var showFilmNetworkAlert: Bool = false
        var devMode: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.AppEnvironment.devMode)
        var devTapCount: Int = 0
        var devLastTap: Date = Date()
        var showDevModeAlert: Bool = false
        var devModePasscode: String = ""
        
        @PresentationState var lockSetting: LockSettingFeature.State? = .init()
        @PresentationState var notification: NotificationSettingFeature.State? = .init()
        @PresentationState var policy: PolicyFeature.State? = .init()
    }
    
    enum Action: Equatable {
        case fetchAppInfo
        case setNickname(String)
        case showNicknameAlert(Bool)
        case setTempNickname(String)
        case showCountInfo(Bool)
        case getRemainingDrawingCount
        case showFilmNetworkAlert(Bool)
        case devTap
        case activateDevMode
        case showDevModeAlert(Bool)
        case setDevModePasscode(String)
        
        case lockSetting(PresentationAction<LockSettingFeature.Action>)
        case notification(PresentationAction<NotificationSettingFeature.Action>)
        case policy(PresentationAction<PolicyFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchAppInfo:
                if let dictionary = Bundle.main.infoDictionary, let version = dictionary["CFBundleShortVersionString"] as? String, let build = dictionary["CFBundleVersion"] as? String {
                    state.appVersion = version
                    state.appBuild = build
                }
                return .none
                
            case let .setNickname(nickname):
                UserDefaults.standard.set(nickname, forKey: UserDefaultsKey.User.nickname)
                state.nickname = nickname
                return .none
                
            case let .showNicknameAlert(show):
                state.showNicknameAlert = show
                return .none
                
            case let .setTempNickname(nickname):
                state.tempNickname = nickname
                return .none
                
            case let .showCountInfo(show):
                state.showCountInfo = show
                return .none
                
            case .getRemainingDrawingCount:
                state.remainingDrawingCount = FilmManager.shared.drawingCount?.count
                return .none
                
            case let .showFilmNetworkAlert(show):
                state.showFilmNetworkAlert = show
                return .none
                
            case .devTap:
                if state.devLastTap.timeInMillis - Date().timeInMillis < 1000 {
                    state.devTapCount += 1
                } else {
                    state.devTapCount = 1
                }
                state.devLastTap = Date()
                if state.devTapCount > 5 {
                    state.devTapCount = 0
                    return .send(.showDevModeAlert(true))
                }
                return .none
                
            case .activateDevMode:
                let activate = Bundle.main.devModePasscode == state.devModePasscode
                UserDefaults.standard.set(activate, forKey: UserDefaultsKey.AppEnvironment.devMode)
                state.devMode = activate
                return .none
                
            case let .showDevModeAlert(show):
                state.showDevModeAlert = show
                return .none
                
            case let .setDevModePasscode(passcode):
                state.devModePasscode = passcode
                return .none
                
            default: return .none
            }
        }
        .ifLet(\.$lockSetting, action: /Action.lockSetting) {
            LockSettingFeature()
        }
        .ifLet(\.$policy, action: /Action.policy) {
            PolicyFeature()
        }
        .ifLet(\.$notification, action: /Action.notification) {
            NotificationSettingFeature()
        }
    }
}
