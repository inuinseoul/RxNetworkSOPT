//
//  NetworkService.swift
//  RxNetwork
//
//  Created by Inwoo Park on 2022/05/11.
//

import Foundation
import RxCocoa
import RxSwift

final class NetworkService {
    let baseUrlStr = "https://asia-northeast3-vegin-2a51e.cloudfunctions.net/api"
    var accesstoken = ""
    
    func loginRequest(id: String, password: String) throws -> Observable<String> {
        let url = URL(string: baseUrlStr + "/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": id, "password": password]
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(body)
        
        return URLSession.shared.rx.response(request: request)
            .map { [weak self] (_, data) in
                guard let loginResult = LoginResult.parse(data: data) else { return "Error" }
                if let loginData = loginResult.data {
                    self?.accesstoken = loginData.accesstoken
                } else {
                    self?.accesstoken = ""
                }
                return loginResult.message
            }
    }
    
    func checkPostRequest() -> Observable<(result: String, title: String, content: String)> {
        let url = URL(string: baseUrlStr + "/post/34")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(self.accesstoken, forHTTPHeaderField: "accesstoken")
        
        return URLSession.shared.rx.response(request: request)
            .map { (_, data) in
                guard let postResult = PostResult.parse(data: data) else {
                    return (result: "Error", title: "Error", content: "Error")
                }
                
                guard let dataResult = postResult.data else {
                    return (result: postResult.message, title: "Error", content: "Error")
                }
                
                return (result: postResult.message, title: dataResult.title, content: dataResult.content)
            }
    }
}
