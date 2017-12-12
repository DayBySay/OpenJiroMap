//
//  SearchViewController.swift
//  OpenJiroMap
//
//  Created by 清 貴幸 on 2017/12/12.
//  Copyright © 2017年 Takayuki Sei. All rights reserved.
//
import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let items:[String] = ["PPAP", "I have a pen", "I have a apple", "Uh! Apple-Pen!", "I have a pen", "I have pineapple", "Uh! Pineapple-Pen!", "Apple-Pen, Pineapple-Pen", "Uh! Pen-Pineapple-Apple-Pen", "Pen-Pineapple-Apple-Pen"]
    var searchResults:[String] = []
    var tableView: UITableView!
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: self.view.frame.width, height: self.view.frame.height))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        if searchController.isActive {
            cell.textLabel!.text = "\(searchResults[indexPath.row])"
        } else {
            cell.textLabel!.text = "\(items[indexPath.row])"
        }
        
        return cell
    }
    
    // 文字が入力される度に呼ばれる
    func updateSearchResults(for searchController: UISearchController) {
        self.searchResults = items.filter{
            // 大文字と小文字を区別せずに検索
            $0.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        self.tableView.reloadData()
    }
    
}
