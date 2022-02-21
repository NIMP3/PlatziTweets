//
//  PostRequest.swift
//  PlatziTweets
//
//  Created by Edwin Yovany on 21/02/22.
//

import Foundation

struct PostRequest: Codable {
    let text: String
    let imageUrl: String?
    let videoUrl: String?
    let location: Location?
}
