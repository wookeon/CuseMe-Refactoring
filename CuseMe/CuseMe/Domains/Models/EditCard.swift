//
//  EditCard.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/04.
//  Copyright © 2020 wookeon. All rights reserved.
//

struct EditCard: Codable {
    let ownIdx: Int
    let cardIdx: Int
    let userIdx: Int
    let count: Int
    let visible: Int //TODO: visible -> Bool API 수정 후 고치기
    let sequence: Int
}
