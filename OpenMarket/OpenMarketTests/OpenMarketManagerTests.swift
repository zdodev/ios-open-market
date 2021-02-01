//
//  OpenMarketManagerTests.swift
//  OpenMarketTests
//
//  Created by 김지혜 on 2021/01/27.
//

@testable import OpenMarket
import XCTest

class OpenMarketManagerTests: XCTestCase {
    var baseURL: URL!
    var mockSession: MockURLSession!
    var sut: OpenMarketManager!
    
    var dummyItem: ItemDetailResponse?
    
    var createItemURL: URL { baseURL.appendingPathComponent("item") }
    
    override func setUp() {
        super.setUp()
        baseURL = URL(string: "http://camp-open-market.herokuapp.com")
//        mockSession = MockURLSession()
        sut = OpenMarketManager.shared
    }
    
    override func tearDown() {
      //mockSession = nil
      sut = nil
      super.tearDown()
    }
    
    func test_conformsTo_OpenMarketService() {
        XCTAssertTrue((sut as AnyObject) is OpenMarketService)
    }
    
    func test_shared_sets() {
        
    }
    
    func get_dummy_item() throws -> ItemDetailResponse {
        let data = try Data.fromJSON(fileName: "item")
        let decoder = JSONDecoder()
        let item = try decoder.decode(ItemDetailResponse.self, from: data)
        
        return item
    }
    
    func test_OpenMarketService_declaresCreateItem() throws {
        let service = sut as OpenMarketService
        let dummyItem = try get_dummy_item()
        let targetItem = ItemCreateRequest(title: dummyItem.title,
                                            descriptions: dummyItem.descriptions,
                                            price: dummyItem.price,
                                            currency: dummyItem.currency,
                                            stock: dummyItem.stock,
                                            discountedPrice: dummyItem.discountedPrice,
                                            password: "zziruru")
        var targetImages: [UIImage] = []
        for urlString in dummyItem.images {
            let url = URL(string: urlString)!
            let data = try Data(contentsOf: url)
            targetImages.append(UIImage(data: data)!)
        }
        
        _ = service.createItem(targetItem, images: targetImages) { _ in }
    }
    
    func test_createItem_callsExpectedURL() {
//        let mockTask = sut.createItem(<#T##item: ItemCreateRequest##ItemCreateRequest#>, images: <#T##[UIImage]#>, completion: <#T##(Result<ItemDetailResponse, Error>) -> Void#>) { _, _ in } as! MockURLSessionDataTask
        
        // then
        XCTAssertEqual(mockTask.url, createItemURL)
    }
    
//    func test_OpenMarketService_declaresReadItem() {
//        let service = sut as OpenMarketService
//        _ = service.readItem(id: 1) { _ in }
//    }
//
//    func test_OpenMarketService_declaresReadItems() {
//        let service = sut as OpenMarketService
//        _ = service.readItems(page: 1) { _ in }
//    }
//
//    func test_OpenMarketService_declaresReadItems() {
//        let service = sut as OpenMarketService
//        _ = service.readItems(page: 1) { _ in }
//    }
}

extension Data {
  public static func fromJSON(fileName: String,
                              file: StaticString = #file,
                              line: UInt = #line) throws -> Data {
    
    let bundle = Bundle(for: TestBundleClass.self)
    let url = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: "json"),
                            "Unable to find \(fileName).json. Did you add it to the tests?",
      file: file, line: line)
    return try Data(contentsOf: url)
  }
}

private class TestBundleClass { }
