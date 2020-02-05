//
//  Card.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/03.
//  Copyright © 2020 wookeon. All rights reserved.
//

struct Card: Codable {
    let userIdx: Int?
    var cardIdx: Int
    let title: String
    let content: String
    let imageURL: String
    let recordURL: String?
    var count: Int
    var visible: Bool
    let serialNum: String
    let sequence: Int
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case userIdx
        case cardIdx
        case title
        case content
        case imageURL = "image"
        case recordURL = "record"
        case count
        case visible
        case serialNum
        case sequence
    }
}

