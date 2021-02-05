//
//  ItemListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/02/03.
//

import UIKit

final class ItemListCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var stockCountLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var discountedPriceLabel: UILabel!
    private var index: Int?
    private var model: Item?
    
    //뷰 모델 넘겨주기 ( 타이밍은 아무데나 )
    override func awakeFromNib() {
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.systemGray.cgColor
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
        self.index = index
        self.model = model
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

extension Int {
    func withCommas() -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
