//
//  ItemListTableViewCell.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/02/03.
//

import UIKit

final class ItemListTableViewCell: UITableViewCell {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var stockCountLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var discountedPriceLabel: UILabel!
    private var index: Int?
    private var model: Item?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemNameLabel.text = nil
        stockCountLabel.text = nil
        priceLabel.text = nil
        discountedPriceLabel.text = nil
    }
    
    func setModel(_ model: Item, index: Int) {
        self.model = model
        self.index = index
        updateUI()
    }
    
    private func updateUI() {
        guard let item = model,
              let index = index else { return }
        
        if let thumbnail = item.thumbnails.first {
            NetworkLayer().requestImage(urlString: thumbnail, index: index) { [weak self] image, index in
                guard index == self?.index else { return }
                self?.itemImageView.image = image
            }
        } else {
            itemImageView.image = UIImage(named: "image1")
        }
        
        itemNameLabel.text = item.title
        
        // enum 으로 만들어주기 0
        if item.stock == 0 {
            stockCountLabel.text = "품절"
            stockCountLabel.textColor = UIColor.systemOrange
        } else {
            stockCountLabel.text = "잔여수량: \(item.stock)"
            stockCountLabel.textColor = UIColor.systemGray
        }
        
        if let discountedPrice = item.discountedPrice {
            priceLabel.isHidden = false
            priceLabel.attributedText = NSAttributedString(string: "\(item.currency) \(item.price.withCommas())", attributes: [.strikethroughStyle: 1])
            discountedPriceLabel.text = "\(item.currency) \(discountedPrice.withCommas())"
        } else {
            priceLabel.isHidden = true
            discountedPriceLabel.text = "\(item.currency) \(item.price.withCommas())"
        }
    }
}


