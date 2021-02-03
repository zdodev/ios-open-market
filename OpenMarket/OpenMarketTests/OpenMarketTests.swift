//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Zero DotOne on 2021/01/27.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    let networkLayer = NetworkLayer()
    
    func test_getItemList_existData() throws {
        let expectation = XCTestExpectation(description: "목록 조회")
        networkLayer.requestItemList(page: 1) { data, _, _ in
            XCTAssertNotNil(data, "목록 조회 실패")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func test_requestItemRegistration_existData() throws {
        let expectation = XCTestExpectation(description: "상품 등록")
        let imageData = UIImage(systemName: "pencil")!.pngData()!
        let item = ItemRegistrationRequest(
            title: "상품 등록",
            descriptions: "상품 등록 테스트",
            price: 100,
            currency: "KRW",
            stock: 100,
            discountedPrice: 50,
            images: [imageData],
            password: "test")

        networkLayer.requestRegistration(bodyData: item) { data, _, _ in
            XCTAssertNotNil(data, "상품 등록 실패")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func test_getItemSpecification_existData() throws {
        let expectation = XCTestExpectation(description: "상품 조회")
        let id = 22
        networkLayer.requestSpecification(id: id) { data, _, _ in
            XCTAssertNotNil(data, "상품 조회 실패")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

//    func test_requestItemModification_existData() throws {
//        let expectation = XCTestExpectation(description: "상품 수정")
//        let imageData = UIImage(systemName: "pencil")!.pngData()!
//        let item = ItemModificationRequest(
//            title: "상품 수정",
//            descriptions: "상품 수정 테스트",
//            price: 100,
//            currency: "KRW",
//            stock: 100,
//            discountedPrice: 50,
//            images: [imageData],
//            password: "test")
//
//        networkLayer.requestModification(id: 22, bodyData: item) { data, _, _ in
//            XCTAssertNotNil(data, "상품 수정")
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10.0)
//    }

    func test_requestItemDeletion_existData() throws {
        let expectation = XCTestExpectation(description: "상품 삭제")
        let item = ItemDeletionRequest(id: 24, password: "test")

        networkLayer.requestDeletion(id: 24, bodyData: item) { data, _, _ in
            XCTAssertNotNil(data, "상품 삭제")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
