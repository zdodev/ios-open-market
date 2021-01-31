//
//  ItemResponse.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/01/26.
//

import Foundation

struct ItemListResponse: Decodable {
    let page: Int
    let items: [ItemResponse]
}

struct ItemResponse: Decodable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
