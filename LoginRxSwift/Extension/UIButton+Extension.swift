//
//  UIButton+Extension.swift
//  LoginRxSwift
//
//  Created by Gaurang Vyas on 02/01/21.
//  Copyright © 2021 Gaurang Vyas. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base : UIButton {
    public var valid : Binder<Bool> {
        return Binder(self.base) { button, valid in
            button.isEnabled = valid
            button.alpha = valid ? 1 : 0.5 
        }
    }
}
