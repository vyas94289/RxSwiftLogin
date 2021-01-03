//
//  PasswordValidationModel.swift
//  LoginRxSwift
//
//  Created by Gaurang Vyas on 02/01/21.
//  Copyright © 2021 Gaurang Vyas. All rights reserved.
//

import RxRelay
class PasswordViewModel : ValidationViewModel {
    
    var errorMessage: String = "Password require at least 1 uppercase, 1 lowercase, and 1 number."
    
    var data = BehaviorRelay<String>(value: "")
    
    var errorValue = BehaviorRelay<String?>(value: "")
    
    func validateCredentials() -> Bool {
        guard validatePassword() else{
            errorValue.accept(errorMessage)
            return false
        }
        errorValue.accept("")
        return true
    }
    
    private func validatePassword() -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{3,16}$"
        return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: data.value)
    }
    
}
