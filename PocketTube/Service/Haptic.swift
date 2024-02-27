//
//  Haptic.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/26.
//

import Foundation
import UIKit

class Haptic {
    static let shared = Haptic()
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    private init(){
        print("Haptic init()")
        
    }
    
    func vibrate(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        // 銷毀之前的物件（如果存在）
        feedbackGenerator?.prepare()
        
        // 創建新的物件並設定樣式
        feedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
        
        // 觸發震動
        feedbackGenerator?.impactOccurred()
    }
}
