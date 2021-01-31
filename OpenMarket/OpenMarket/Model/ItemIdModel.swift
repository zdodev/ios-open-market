//
//  ItemIdModel.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/01/26.
//

import Foundation

struct ItemIdRequest: Encodable {
    let id: Int
    let password: String
}

struct ItemIdResponse: Decodable {
    let id: Int
}
