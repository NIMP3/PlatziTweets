//
//  EndPoints.swift
//  PlatziTweets
//
//  Created by Edwin Yovany on 21/02/22.
//

import Foundation

struct Endpoints {
    static let domain = "https://platzi-tweets-backend.herokuapp.com/api/v1"
    static let login = domain + "/auth"
    static let register = domain + "/register"
    static let posts = domain + "/posts"
}
