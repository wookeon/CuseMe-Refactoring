//
//  SendDataDelegate.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/04.
//  Copyright © 2020 wookeon. All rights reserved.
//

protocol SendDataDelegate: AnyObject {
    func sendCards(data: [Card])
    func sendTag(data: Int)
}
