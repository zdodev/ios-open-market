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
        openMarketAPI.requestItemList(page: 1) { data, response, error in
        }
    }
}

extension ItemListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListCell") as? ListTableViewCell {
            cell.itemImage.image = UIImage(named: "image1")
            cell.itemTitle.text = "흰머리오목눈이"
            cell.itemPrice.text = "300원"
            cell.itemStock.text = "1마리"
            return cell
            
        }
        return UITableViewCell()
    }
}
