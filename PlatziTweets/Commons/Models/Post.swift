//
//  PostResponse.swift
//  PlatziTweets
//
//  Created by Edwin Yovany on 21/02/22.
//

import Foundation

struct Post: Codable {
    let id: String
    let author: User
    let imageUrl: String
    let text: String
    let videoUrl: String
    let location: Location
    let hasVideo: Bool
    let hasImage: Bool
    let hasLocation: Bool
    let createAt: String
}
