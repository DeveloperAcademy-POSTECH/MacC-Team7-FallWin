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
        var appVersion: String = "1.0.0"
        var appBuild: String = "1"
        
        @PresentationState var lockSetting: LockSettingFeature.State? = .init()
        @PresentationState var backupSetting: BackupSettingFeature.State? = .init()
        @PresentationState var policy: PolicyFeature.State? = .init()
        @PresentationState var feedback: FeedbackFeature.State? = .init()
    }
    
    enum Action: Equatable {
        case fetchAppInfo
        case lockSetting(PresentationAction<LockSettingFeature.Action>)
        case backupSetting(PresentationAction<BackupSettingFeature.Action>)
        case policy(PresentationAction<PolicyFeature.Action>)
        case feedback(PresentationAction<FeedbackFeature.Action>)
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
                
            default: return .none
            }
        }
        .ifLet(\.$lockSetting, action: /Action.lockSetting) {
            LockSettingFeature()
        }
        .ifLet(\.$backupSetting, action: /Action.backupSetting) {
            BackupSettingFeature()
        }
        .ifLet(\.$policy, action: /Action.policy) {
            PolicyFeature()
        }
        .ifLet(\.$feedback, action: /Action.feedback) {
            FeedbackFeature()
        }
    }
}
