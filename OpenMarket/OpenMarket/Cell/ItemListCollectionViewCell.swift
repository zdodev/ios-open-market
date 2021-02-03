//
//  ItemListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/02/03.
//

import UIKit

class ItemListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var stockCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    var index: Int?
    var model: Item? {
        didSet {
            updateUI()
        }
    }
    
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

extension ItemListCollectionViewCell {
    func setCellStyle() {
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.systemGray.cgColor
    }
}

extension Int {
    func withCommas() -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
