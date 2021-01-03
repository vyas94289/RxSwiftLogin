//
//  ValidationViewModel.swift
//  LoginRxSwift
//
//  Created by Gaurang Vyas on 02/01/21.
//  Copyright © 2021 Gaurang Vyas. All rights reserved.
//

import RxRelay

protocol ValidationViewModel {
     
    var errorMessage: String { get }
    
    // Observables
    var data: BehaviorRelay<String> { get set }
    var errorValue: BehaviorRelay<String?> { get }
    
    // Validation
    func validateCredentials() -> Bool
}
