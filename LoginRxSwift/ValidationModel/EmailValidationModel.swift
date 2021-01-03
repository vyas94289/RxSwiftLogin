//
//  File.swift
//  LoginRxSwift
//
//  Created by Gaurang Vyas on 02/01/21.
//  Copyright © 2021 Gaurang Vyas. All rights reserved.
//

import RxRelay

class EmailValidationModel: ValidationViewModel {
    
    var errorMessage: String = "This is a invalid email."
    
    var data: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    var errorValue = BehaviorRelay<String?>(value: "")
     
    func validateCredentials() -> Bool {
        guard validatePattern(text: data.value) else {
            errorValue.accept(errorMessage)
            return false
        }
        errorValue.accept("")
        return true
    }
    
    private func validatePattern(text : String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
}
