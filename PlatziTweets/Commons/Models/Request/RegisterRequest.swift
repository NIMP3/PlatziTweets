//
//  RegisterRequest.swift
//  PlatziTweets
//
//  Created by Edwin Yovany on 21/02/22.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let names: String
}
