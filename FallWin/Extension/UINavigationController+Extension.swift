//
//  UINavigationController+Extension.swift
//  FallWin
//
//  Created by 최명근 on 10/19/23.
//

import Foundation
import UIKit

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}
