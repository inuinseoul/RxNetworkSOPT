//
//  PostResult.swift
//  RxNetwork
//
//  Created by Inwoo Park on 2022/05/11.
//

import Foundation

struct PostResult: Codable {
    let message: String
    let data: PostData?
    
    static func parse(data: Data) -> PostResult? {
        var result: PostResult?
        
        do {
            let decoder = JSONDecoder()
            result = try decoder.decode(PostResult.self, from: data)
        } catch {
            print(error)
        }
        
        return result
    }
}

struct PostData: Codable {
    let title: String
    let content: String
}
