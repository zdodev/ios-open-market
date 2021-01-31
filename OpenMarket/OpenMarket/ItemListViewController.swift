//
//  ItemListViewController.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/01/26.
//

import UIKit

class ItemListViewController: UIViewController {
    
    private var items: [ItemResponse] = [] {
        didSet {
            //readItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func readItems() {
        OpenMarketManager.shared.readItems(page: 1) { [weak self] result in
            switch result {
            case .success(let itemListResponse):
                self?.items = itemListResponse.items
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func readItem() {
        guard let item = items.randomElement() else { return }
        OpenMarketManager.shared.readItem(id: item.id) { result in
            switch result {
            case .success(let itemDetailResponse):
                print(itemDetailResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func deleteItem() {
        let targetItem = ItemIdRequest(id: 138, password: "zziruru")
        OpenMarketManager.shared.deleteItem(targetItem) { [weak self] result in
            switch result {
            case .success(let itemIdResponse):
                print(itemIdResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateItem() {
        let targetItem = ItemUpdateRequest(title: "루루 지팡이?!", password: "zziruru")
        OpenMarketManager.shared.updateItem(targetItem, id: 147) { [weak self] result in
            switch result {
            case .success(let itemDetailResponse):
                print(itemDetailResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func createItem() {
        let newItem = ItemCreateRequest(title: "루루 지팡이",
                                        descriptions: "지팡입니다.",
                                        price: 500,
                                        currency: "KRW",
                                        stock: 1,
                                        discountedPrice: 480000,
                                        password: "zziruru")
        
        let images: [UIImage] = [UIImage(named: "item5")!,
                                 UIImage(named: "item6")!]
        OpenMarketManager.shared.createItem(newItem, images: images) { result in
            switch result {
            case .success(let itemDetailResponse):
                print(itemDetailResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
