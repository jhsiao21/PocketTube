//
//  ContentActionButtonDelegate.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/2/25.
//

import UIKit

protocol ContentActionButtonDelegate : AnyObject {
    func didTappedShareBtn(mediaName: String, image: UIImage)
    func didTappedWatchListBtn(uid: String, media: FMedia)
    func didTappedPlayBtn(mediaName: String, mediaOverview: String?)
}
