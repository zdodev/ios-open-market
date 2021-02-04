//
//  ItemGridViewController.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/02/03.
//

import UIKit

class ItemGridViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
    }
}

extension ItemGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemGridCell", for: indexPath) as? GridCollectionViewCell {
            cell.itemImage.image = UIImage(named: "image1")
            cell.itemTitle.text = "흰머리오목눈이"
            cell.itemPrice.text = "3천원"
            cell.itemStock.text = "3마리"
            return cell
        }
        return UICollectionViewCell()
//        return collectionView.dequeueReusableCell(withReuseIdentifier: "ItemGridCell", for: indexPath)
    }
}
