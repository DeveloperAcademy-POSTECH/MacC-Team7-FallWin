//
//  UIViewController+Extension.swift
//  FallWin
//
//  Created by semini on 2023/11/05.
//

import Foundation
import UIKit
extension UIViewController{
    func topViewController() -> UIViewController {
            // 프리젠트 방식의 뷰컨트롤러가 있다면
            if let presented = self.presentedViewController {
                // 해당 뷰컨트롤러에서 재귀 (자기 자신의 메소드를 실행)
                return presented.topViewController()
            }
            // 자기 자신이 네비게이션 컨트롤러 라면
            if let navigation = self as? UINavigationController {
                // 네비게이션 컨트롤러에서 보이는 컨트롤러에서 재귀 (자기 자신의 메소드를 실행)
                return navigation.visibleViewController?.topViewController() ?? navigation
            }
            // 최상단이 탭바 컨트롤러 라면
            if let tab = self as? UITabBarController {
                // 선택된 뷰컨트롤러에서 재귀 (자기 자신의 메소드를 실행)
                return tab.selectedViewController?.topViewController() ?? tab
            }
            // 재귀를 타다가 최상단 뷰컨트롤러를 반환
            return self
        }
}
