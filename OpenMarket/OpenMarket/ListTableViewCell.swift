//
//  ListTableViewCell.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/02/04.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemStock: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImage.image = nil
        itemTitle.text = nil
        itemPrice.text = nil
        itemStock.text = nil
    }
}
