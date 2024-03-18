//
//  UIColor+Ext.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/2/22.
//

import UIKit


extension UIColor {
    static let primaryBackground = UIColor(red: 227/255, green: 56/255, blue: 49/255, alpha: 1)
            
    static let mainThemeBackgroundColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                    case
                    .unspecified,
                    .light:
                      return .white
                    case .dark:
                      return UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 1)
                    @unknown default:
                        fatalError()
                }
            }
        } else {
            return UIColor.white
        }
    }()
    
    static let mainTextColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                    case
                    .unspecified,
                    .light: return UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
                    case .dark: return UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1)
                    @unknown default:
                        fatalError()
                }
            }
        } else {
            return UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        }
    }()
    
    static let highlightedLabel = UIColor.label.withAlphaComponent(0.8)

    var highlighted: UIColor { withAlphaComponent(0.8) }

    var image: UIImage {
      let pixel = CGSize(width: 1, height: 1)
      return UIGraphicsImageRenderer(size: pixel).image { context in
        self.setFill()
        context.fill(CGRect(origin: .zero, size: pixel))
      }
    }
}
