//
//  ItemListViewController.swift
//  OpenMarket
//
//  Created by Zero DotOne on 2021/02/03.
//

import UIKit

class ItemListViewController: UIViewController {
    let openMarketAPI = NetworkLayer()
    var data: ItemList!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension ItemListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let masterViewController = parent as? MasterViewController {
            if !masterViewController.itemList.isEmpty {
                let count = masterViewController.itemList[0].items.count
                return count
            }
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListCell") as? ListTableViewCell {
            if let masterViewController = parent as? MasterViewController {
                if !masterViewController.itemList.isEmpty {
                    let item = masterViewController.itemList[0].items[indexPath.row]
                    cell.itemTitle.text = item.title
                    cell.itemPrice.text = "\(item.currency) \(item.price)"
                    cell.itemStock.text = "잔여수량: \(item.stock)"
                    if !item.thumbnails.isEmpty {
                        let url = URL(string: item.thumbnails[0])!
                        let imageData = try! Data(contentsOf: url)
                        cell.itemImage.image = UIImage(data: imageData)
                    }
                } else {
                    cell.itemImage.image = UIImage(named: "image1")
                    cell.itemTitle.text = "흰머리오목눈이"
                    cell.itemPrice.text = "300원"
                    cell.itemStock.text = "1마리"
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
}
