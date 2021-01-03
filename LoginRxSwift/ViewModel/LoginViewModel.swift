//
//  LoginViewModel.swift
//  LoginRxSwift
//
//  Created by Gaurang Vyas on 02/01/21.
//  Copyright © 2021 Gaurang Vyas. All rights reserved.
//

import RxSwift
import RxRelay
import Moya

class LoginViewModel {
    
    let emailIdViewModel    = EmailValidationModel()
    let passwordViewModel   = PasswordViewModel()
    let disposebag          = DisposeBag()
    
    var enableButton: Observable<Bool>
    
    // Fields that bind to our view's
    let isSuccess   = BehaviorRelay<Bool>(value: false)
    let isLoading   = BehaviorRelay<Bool>(value: false)
    let errorMsg    = BehaviorRelay<String>(value: "")
    
    init() {
        let emailValidation = emailIdViewModel.data.map({!$0.isEmpty}).share(replay: 1)
        let passwordValidation = passwordViewModel.data.map({!$0.isEmpty}).share(replay: 1)
        enableButton = Observable.combineLatest(emailValidation, passwordValidation) {
            return $0 && $1
        }
    }
    
    func validateCredentials() -> Bool{
        let isValidEmail = emailIdViewModel.validateCredentials()
        let isValidPass = passwordViewModel.validateCredentials()
        return isValidEmail && isValidPass
    }
    
    func loginUser() {
        guard validateCredentials() else {
            return
        }
        isLoading.accept(true)
        let userName = emailIdViewModel.data.value
        let password = passwordViewModel.data.value
        let param: [String: Any] = ["password": password,
                                    "email": userName,
                                    "loginType": "default"]
        let provider = MoyaProvider<UserServices>()
    
        provider.request(.login(params: param)) { [weak self] result in
            self?.isLoading.accept(false)
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    print(try response.mapJSON())
                    self.isSuccess.accept(true)
                } catch {
                    self.errorMsg.accept(error.localizedDescription)
                }
            case .failure(let error):
                self.errorMsg.accept(error.localizedDescription)
            }
        }
    }
}
