//
//  LoginResult.swift
//  RxNetwork
//
//  Created by Inwoo Park on 2022/05/11.
//

import Foundation

struct LoginResult: Codable {
    let message: String
    let data: LoginData?
    
    static func parse(data: Data) -> LoginResult? {
        var result: LoginResult?
        
        do {
            let decoder = JSONDecoder()
            result = try decoder.decode(LoginResult.self, from: data)
        } catch {
            print(error)
        }
        
        return result
    }
}

struct LoginData: Codable {
    let accesstoken: String
}
