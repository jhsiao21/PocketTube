//
//  FakeMedia.swift
//  PocketTubeTests
//
//  Created by LoganMacMini on 2024/2/28.
//

import Foundation
@testable import PocketTube
@testable import Firebase

let realUid = "xsvuUN7dJZXQTJwMwkICZeXxzLp1"
let fakeUid = "xavuIVXwJZXQTJwfdcwCZeXxzLp2"

enum FakeMedia {
    
    static let realData: FMedia = FMedia(
        ownerUid: realUid,
        caption: "Anyone But You",
        timestamp: Timestamp(),
        imageUrl: "/1SexNjgm9b0sHJiOaIWf1pghcs2.jpg",
        overview: "一對貌合神離的俊男美女，在一場舉辦在澳洲的婚禮中，發現自己被親朋好友硬湊成堆，為了不破壞這樁喜事，他們決定暫時攜手合作，繼續扮演眾人眼中的完美情侶。在首支曝光的預告中，席德妮史威尼不吝展現她雄偉上圍的魔鬼身材，與擁有大肌肌的格蘭鮑威爾共同上演一場大騙局。",
        mId: NSUUID().uuidString
    )
    
    static let fakeData: FMedia = FMedia(
        ownerUid: realUid,
        caption: "dkjdkmcdiefedfx",
        timestamp: Timestamp(),
        imageUrl: "https://example.com/image.png",
        overview: "This is a test overview",
        mId: NSUUID().uuidString
    )
    
    static let testData: FMedia = FMedia(
        ownerUid: fakeUid,
        caption: NSUUID().uuidString,
        timestamp: Timestamp(),
        imageUrl: "https://example.com/image.png",
        overview: "This is a test overview",
        mId: NSUUID().uuidString
    )
}
