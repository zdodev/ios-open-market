//
//  ItemRequest.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/01/26.
//

import Foundation

struct ItemCreateRequest: Encodable {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, password
        case discountedPrice = "discounted_price"
    }
}

struct ItemUpdateRequest: Encodable {
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let password: String
    
    init(title: String? = nil,
         descriptions: String? = nil,
         price: Int? = nil,
         currency: String? = nil,
         stock: Int? = nil,
         discountedPrice: Int? = nil,
         password: String) {
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, password
        case discountedPrice = "discounted_price"
    }
}

struct TmpItemCreateRequest: Encodable {
    let title: String
    let descriptions: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let password: String
    let images: [Data]
    
    enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, password, images
        case discountedPrice = "discounted_price"
    }
}
