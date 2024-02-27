//
//  CustomButton.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2023/9/6.
//

import UIKit

class CustomButton: UIButton {
    var interTitleImageSpacing: CGFloat = 5.0  // 图片和文字之间的间距
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        // 计算文本标签的位置和大小
        let titleSize = super.titleRect(forContentRect: contentRect).size
        let imageFrame = super.imageRect(forContentRect: contentRect)
        
        return CGRect(x: (contentRect.width - titleSize.width) * 0.5,
                      y: imageFrame.origin.y + imageFrame.height + interTitleImageSpacing,
                      width: titleSize.width,
                      height: titleSize.height)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        // 计算图像视图的位置和大小
        let imageSize = super.imageRect(forContentRect: contentRect).size
        
        return CGRect(x: (contentRect.width - imageSize.width) * 0.5,
                      y: 0,
                      width: imageSize.width,
                      height: imageSize.height)
    }
}
