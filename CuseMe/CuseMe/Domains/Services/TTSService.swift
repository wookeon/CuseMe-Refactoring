//
//  TTSService.swift
//  CuseMe
//
//  Created by wookeon on 2020/02/03.
//  Copyright © 2020 wookeon. All rights reserved.
//

import AVFoundation

class TTSService {
        
    func speak(_ contents: String, completion: @escaping (AVSpeechUtterance) -> Void) {

        let utterance = AVSpeechUtterance(string: contents)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = 0.5
        
        completion(utterance)
    }
}
