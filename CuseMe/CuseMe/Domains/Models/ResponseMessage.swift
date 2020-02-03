//
//  ResponseMessage.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/03.
//  Copyright © 2020 wookeon. All rights reserved.
//

struct ResponseMessage: Codable {
    let status: Int
    let success: Bool
    let message: String
}
