//
//  CustomButton.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/6.
//

import UIKit

class CustomButton: UIButton {
    var interTitleImageSpacing: CGFloat = 5.0  // 圖片和文字之間的距離
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let titleSize = super.titleRect(forContentRect: contentRect).size
        let imageFrame = super.imageRect(forContentRect: contentRect)
        
        return CGRect(x: (contentRect.width - titleSize.width) * 0.5,
                      y: imageFrame.origin.y + imageFrame.height + interTitleImageSpacing,
                      width: titleSize.width,
                      height: titleSize.height)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        let imageSize = super.imageRect(forContentRect: contentRect).size
        
        return CGRect(x: (contentRect.width - imageSize.width) * 0.5,
                      y: 0,
                      width: imageSize.width,
                      height: imageSize.height)
    }
}
