//
//  LicenseView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 12/1/23.
//

import Foundation
import ComposableArchitecture

struct LicenseFeature: Reducer {
    struct State: Equatable {
        let licenses: [License] = [
            License(name: "Swift Composable Architecture", license: .MIT, url: "https://github.com/pointfreeco/swift-composable-architecture"),
            License(name: "SwiftKeychainWrapper", license: .MIT, url: "https://github.com/jrendel/SwiftKeychainWrapper"),
            License(name: "Alamofire", license: .MIT, url: "https://github.com/Alamofire/Alamofire"),
            License(name: "lottie-ios", license: .Apache2, url: "https://github.com/airbnb/lottie-ios"),
            License(name: "ZIPFoundation", license: .MIT, url: "https://github.com/weichsel/ZIPFoundation"),
            License(name: "Karlo", license: .etc("CreativeML Open RAIL-M license"), url: "https://github.com/kakaobrain/karlo"),
            License(name: "Pretendard", license: .etc("OFL"), url: "https://cactus.tistory.com/306"),
            License(name: "Kronos", license: .Apache2, url: "https://github.com/MobileNativeFoundation/Kronos")
        ]
    }
    
    enum Action: Equatable {
        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
            
        default: return .none
        }
    }
}
