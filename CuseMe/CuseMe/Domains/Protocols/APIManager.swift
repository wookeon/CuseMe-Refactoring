//
//  APIManager.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/03.
//  Copyright © 2020 wookeon. All rights reserved.
//

protocol APIManager {}

extension APIManager {
    public static func setURL(_ path: String) -> String {
        return "http://13.125.41.98:3000" + path
    }
}
