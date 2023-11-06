//
//  ImageDetailView+Feature.swift
//  FallWin
//
//  Created by 최명근 on 11/2/23.
//

import Foundation
import UIKit
import ComposableArchitecture

struct ImageDetailFeature: Reducer {
    struct State: Equatable {
        var image: UIImage? = nil
    }
    
    enum Action: Equatable {
        case setZoomScale(CGFloat)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .setZoomScale(scale):
            return .none
            
        default: return .none
        }
    }
}
