//
//  CardService.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/03.
//  Copyright © 2020 wookeon. All rights reserved.
//

import Alamofire
import SwiftKeychainWrapper

class CardService: APIManager, Requestable {
    
    // 발달 장애인 카드 조회
    func visibleCards(completion: @escaping (ResponseArray<Card>?, Error?) -> Void) {
        
        let url = Self.setURL("/cards/visible")
        let uuid = KeychainWrapper.standard.string(forKey: "uuid") ?? ""
        let header: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let body: Parameters = [
            "uuid": "\(uuid)"
        ]
        
        postable(url: url, type: ResponseArray<Card>.self, body: body, header: header) {
            (response, error) in
            
            if response != nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // 전체 카드 조회
    func cards(completion: @escaping (ResponseArray<Card>?, Error?) -> Void) {
        
        let url = Self.setURL("/cards")
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "token" : "\(token)"
        ]
        
        getable(url: url, type: ResponseArray<Card>.self, body: nil, header: header) {
            (response, error) in
            
            if response != nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // 카드 사용 빈도 증가
    func increaseCount(cardIdx: Int, completion: @escaping (ResponseMessage?, Error?) -> Void) {
        
        let url = Self.setURL("/cards/\(cardIdx)/count")
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "token" : "\(token)"
        ]
        
        putalbe(url: url, type: ResponseMessage.self, body: nil, header: header) {
            (response, error) in
            
            if response != nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // 카드 전체 수정
    func editCards(cards: [Card], completion: @escaping (ResponseArray<EditCard>?, Error?) -> Void) {
        
        let url = Self.setURL("/cards/")
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let header: HTTPHeaders = [
            "Content-Type" : "application/json",
            "token" : "\(token)"
        ]
        
        var json: Data?
        do {
            let result = try JSONEncoder().encode(cards)
            let jsonString = String(data: result, encoding: .utf8)
            print(jsonString)
            json = result
        } catch (let error) {
            print("catch: \(error.localizedDescription)")
        }
            
        let body: Parameters = [
            "updateArr" : "\(json)"
        ]
        
        putalbe(url: url, type: ResponseArray<EditCard>.self, body: body, header: header) {
            (response, error) in
            
            if response != nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
