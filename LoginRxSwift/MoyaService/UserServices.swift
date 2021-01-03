//
//  UserServices.swift
//  LoginRxSwift
//
//  Created by Gaurang Vyas on 02/01/21.
//  Copyright © 2021 Gaurang Vyas. All rights reserved.
//


import Moya

enum UserServices {
    case login(params: [String: Any])
}

extension UserServices: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.dev.yousic.co/v1/user")!
    }

    var path: String {
        switch self {
        case .login:
            return "login"
        }
    }

    var method: Method {
        return .post
    }

    var task: Task {
        switch self {
        case .login(let params):
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }

}
