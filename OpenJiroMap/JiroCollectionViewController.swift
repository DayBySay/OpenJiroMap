//
//  JiroCollectionViewController.swift
//  OpenJiroMap
//
//  Created by 清 貴幸 on 2017/12/18.
//  Copyright © 2017年 Takayuki Sei. All rights reserved.
//

import UIKit

private let reuseIdentifier = "JiroCollectionViewCell"

class JiroCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        let nib: UINib = UINib(nibName: "JiroCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return DataStore.shared.jiroItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: JiroCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! JiroCollectionViewCell
        let item = DataStore.shared.jiroItems[indexPath.row]

        cell.nameLabel.text = item.name
        cell.adressLabel.text = item.adress
        cell.openLabel.text = "営業中"
        cell.openTimeLabel.text = item.open

        return cell
    }
    
    @IBAction func didTouchUpCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
