//
//  CXLiveGiftModel.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/3/16.
//

import Foundation

public class CXLiveGiftModel: NSObject {
    /// The name for the gift.
    @objc public var giftName: String = ""
    /// The asset url for the gift.
    @objc public var giftAssetUrl: String = ""
    /// The default amount for sending the gift.
    @objc public var defaultCount: Int = 0
    /// The amount for sending the gift.
    @objc public var sendCount: Int = 1
    /// The id for the gift.
    @objc public var giftId: String = ""
    /// The key for the gift.
    @objc public var giftKey: String = ""
    /// The description for the gift.
    @objc public var giftDescription: String = ""
}
