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

enum MockData {
    
    static let realFMedia: FMedia = FMedia(
        ownerUid: realUid,
        caption: "Anyone But You",
        timestamp: Timestamp(),
        imageUrl: "/1SexNjgm9b0sHJiOaIWf1pghcs2.jpg",
        overview: "一對貌合神離的俊男美女，在一場舉辦在澳洲的婚禮中，發現自己被親朋好友硬湊成堆，為了不破壞這樁喜事，他們決定暫時攜手合作，繼續扮演眾人眼中的完美情侶。在首支曝光的預告中，席德妮史威尼不吝展現她雄偉上圍的魔鬼身材，與擁有大肌肌的格蘭鮑威爾共同上演一場大騙局。",
        mId: NSUUID().uuidString
    )
    
    static let fakeFMedia: FMedia = FMedia(
        ownerUid: realUid,
        caption: "dkjdkmcdiefedfx",
        timestamp: Timestamp(),
        imageUrl: "https://example.com/image.png",
        overview: "This is a test overview",
        mId: NSUUID().uuidString
    )
    
    static let testFMedia: FMedia = FMedia(
        ownerUid: fakeUid,
        caption: NSUUID().uuidString,
        timestamp: Timestamp(),
        imageUrl: "https://example.com/image.png",
        overview: "This is a test overview",
        mId: NSUUID().uuidString
    )
    
    static let fakeFMedias: [FMedia] = [
        fakeFMedia
    ]
    
    static let fakeMedias: [Media] = [
        Media(
            id: 969492,
            genre_ids: [
                28,
                53,
                10752
            ],
            media_type: nil,
            original_name: nil,
            original_title: "Land of Bad",
            poster_path: "/khmQoGP39zfrESdHR1BzSf84JTF.jpg",
            overview: "一支特種部隊前往菲律賓南部執行一項緊急救援任務，代號「死神」（羅素克洛 飾）的空軍無人機駕駛奉命操作「MQ-9死神無人機」進行空中支援，但救援過程卻意外出了差錯，特種部隊因而遭受武裝民兵猛烈攻擊。面對突如其來的危機，「死神」必須想辦法在短短48小時內扭轉失控的救援行動，而他來自天空的指引，將成為身陷絕境的特種部隊成功拯救人質並逃出生天的唯一希望……。",
            vote_count: 188,
            release_date: "2024-01-25",
            vote_average: 7.1
        )
    ]
    
    static let fakeMediaDic: [String : [Media]] = [
        "\(Sections.MandarinMedia.caseDescription)" : fakeMedias
    ]
    
    static let fakeItems : [HotNewReleaseViewModelUpcomingItem] = [
        HotNewReleaseViewModelUpcomingItem(medias: fakeMedias)
    ]
    
}

