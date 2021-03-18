//
//  Constant.swift
//  BoXoB
//
//  Created by apple on 11/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

struct Constants {
    static let rotatioGifName = "Rotato"
    static let piccrossGifName = "PicCross"
    static let matchNumbersGifName = "MatchNumbers"
    static let PatterenMatchGifName = "PatterenMatch"
    static let FlippoGifName = "Flippo"
    static let MusicFileName = "backgroundMusic.mp3"
}

struct GamesName {
    static let rotatioGameName = "ROTATO"
    static let matchNumbersGameName = "ARRANGO"
    static let PatterenMatchGameName = "PATTERNO"
    static let FlippoGameName = "FLIPPO"
}

@objc class InAppIds: NSObject {
    private override init() {}

    @objc class func points100() -> String { return InAppPurchaseIds.points100 }
    @objc class func points200() -> String { return InAppPurchaseIds.points200 }
    @objc class func points500() -> String { return InAppPurchaseIds.points500 }
    @objc class func points800() -> String { return InAppPurchaseIds.points800 }
    @objc class func points1000() -> String { return InAppPurchaseIds.points1000 }
    @objc class func points2000() -> String { return InAppPurchaseIds.points2000 }
    @objc class func proVersionId() -> String { return InAppPurchaseIds.proVersionId }
}

struct InAppPurchaseIds {
    static let points100 = "com.boxob.100Points"
    static let points200 = "com.boxob.200Points"
    static let points500 = "com.boxob.500Points"
    static let points800 = "com.boxob.800Points"
    static let points1000 = "com.boxob.1000Points"
    static let points2000 = "com.boxob.2000Points"
    static let proVersionId = "com.boxob.pro"
}

struct LevelMaker {
    static let numberOfLevelInEachStage = 12//150
}

@objc class AdmobIds: NSObject {
    private override init() {}
    static var unitId = "ca-app-pub-1748815945631578/3995323822"

    @objc class func admonUnitId() -> String { return unitId }
}

