//
//  ViewController.swift
//  LoginRxSwift
//
//  Created by Gaurang Vyas on 30/12/20.
//  Copyright © 2020 Gaurang Vyas. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class ViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var processIndicator: UIActivityIndicatorView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var passwordErrorLabel: UILabel!
    @IBOutlet var emailErrorLabel: UILabel!
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createViewModelBinding()
        observeTextFieldEvents()
        createCallbacks()
    }
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 6
    }
    
    private func createViewModelBinding() {
        usernameTextField
            .rx
            .text.orEmpty
            .bind(to: viewModel.emailIdViewModel.data)
            .disposed(by: disposeBag)
        
        passwordTextField
            .rx
            .text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
            .disposed(by: disposeBag)
        
        loginButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [unowned self] in
            self.view.endEditing(true)
            self.viewModel.loginUser()
        }).disposed(by: disposeBag)
        
    }
    
    private func observeTextFieldEvents() {
        usernameTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [unowned self] in
            self.passwordTextField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        usernameTextField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [unowned self] in
            self.viewModel.emailIdViewModel.errorValue.accept("")
        }).disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [unowned self] in
            self.passwordTextField.resignFirstResponder()
        }).disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [unowned self] in
            self.viewModel.passwordViewModel.errorValue.accept("")
        }).disposed(by: disposeBag)
        
        viewModel.enableButton.bind(to: loginButton.rx.valid).disposed(by: disposeBag)
    }
    
    private func createCallbacks() {
        viewModel
            .isLoading
            .asObservable()
            .bind(to: processIndicator.rx.isAnimating, loginButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.emailIdViewModel.errorValue
            .asObservable()
            .bind(to:self.emailErrorLabel.rx.text)
            .disposed(by:self.disposeBag)
        
        viewModel.passwordViewModel.errorValue
            .asObservable()
            .bind(to:self.passwordErrorLabel.rx.text)
            .disposed(by:self.disposeBag)
        
        // success
        viewModel.isSuccess.asObservable()
            .bind{ value in
                guard value else {
                    return
                }
                self.showAlert(title: "Success", message: "Logged In!", style: .alert,
                               actions: [AlertAction.action(title: "Ok", style: .cancel)]
                ).subscribe(onNext: { selectedIndex in
                   print(selectedIndex)
                }).disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
        
        // errors
        viewModel.errorMsg.asObservable()
            .bind { errorMessage in
                guard !errorMessage.isEmpty else {
                    return
                }
                self.showAlert(title: "Failure", message: errorMessage, style: .alert,
                               actions: [AlertAction.action(title: "Ok", style: .cancel)]
                ).subscribe(onNext: { selectedIndex in
                   print(selectedIndex)
                }).disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)

    }
}

