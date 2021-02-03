//
//  ItemListViewController.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/02/03.
//

import UIKit

class ItemListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var isEnd: Bool = false
    private var currentPage: Int = 1 {
        didSet {
            print("현재페이지는 \(currentPage) 입니다")
        }
    }
    private var items: [Item] = [] {
        didSet {
            if items.isEmpty { return }
            
            DispatchQueue.main.async { [weak self] in
                let currentSegment = self?.segmentedControl.selectedSegmentIndex
                if currentSegment == 0 {
                    self?.showTableView()
                } else if currentSegment == 1 {
                    self?.showCollectionView()
                }
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSetting()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        getItems(page: currentPage)
    }
    
    private func getItems(page: Int) {
        NetworkLayer().requestItemList(page: page) { [weak self] result in
            switch result {
            case .success(let itemList):
                if itemList.items.isEmpty {
                    self?.isEnd = true
                } else {
                    self?.items.append(contentsOf: itemList.items)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func initializeSetting() {
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let normalTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        segmentedControl.setTitleTextAttributes(selectedTitleTextAttributes,
                                                for: .selected)
        segmentedControl.setTitleTextAttributes(normalTitleTextAttributes,
                                                for: .normal)
        
        collectionView.isHidden = true
        tableView.isHidden = true
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showTableView()
        } else if sender.selectedSegmentIndex == 1 {
            showCollectionView()
        }
    }
    
    private func showTableView() {
        collectionView.isHidden = true
        tableView.isHidden = false
        if items.isEmpty { return }
        tableView.reloadData()
    }
    
    private func showCollectionView() {
        tableView.isHidden = true
        collectionView.isHidden = false
        if items.isEmpty { return }
        collectionView.reloadData()
    }
}

extension ItemListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count {
            currentPage += 1
            getItems(page: currentPage)
        }
    }
}

extension ItemListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isEnd {
            return items.count
        } else {
            return items.count + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == items.count { return .init() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableViewCell") as? ItemListTableViewCell else {
            return .init()
        }
        cell.setModel(items[indexPath.row], index: indexPath.row)
        return cell
    }
}

extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isEnd {
            return items.count
        } else {
            return items.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == items.count {
            currentPage += 1
            getItems(page: currentPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCollectionViewCell", for: indexPath) as? ItemListCollectionViewCell else { return .init() }
        if indexPath.row == items.count { return cell }
        cell.setCellStyle()
        cell.setModel(items[indexPath.row], index: indexPath.row)
        return cell
    }
}

extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSpacing: CGFloat = 10
        let columnCount: CGFloat = 2
        let margin: CGFloat = 5
        let width: CGFloat = (collectionView.bounds.width - itemSpacing - margin * 2) / columnCount
        let height: CGFloat = width + 125

        return CGSize(width: width, height: height)
    }
}

