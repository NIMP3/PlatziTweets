//
//  RequestResponse.swift
//  PlatziTweets
//
//  Created by Edwin Yovany on 21/02/22.
//

import Foundation

struct RegisterResponse: Codable {
    let user: User
    let token: String
}
