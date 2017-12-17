//
//  FilteringViewController.swift
//  OpenJiroMap
//
//  Created by 清 貴幸 on 2017/12/17.
//  Copyright © 2017年 Takayuki Sei. All rights reserved.
//

import UIKit
import Eureka

class FilteringViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ SelectableSection<ListCheckRow<String>>("系列", selectionType: .multipleSelection)
        for type in jiroTypes {
            form.last! <<< ListCheckRow<String>(type.rawValue){ lrow in
                lrow.title = type.rawValue
                lrow.selectableValue = type.rawValue
                
                if Filter.shared.types.index(of: type.rawValue) != nil {
                    lrow.value = type.rawValue
                }
                
                }.cellSetup { cell, _ in
                    cell.accessoryType = .checkmark
                }.onChange({ row in
                    var types = Filter.shared.types
                    if row.value != nil {
                        types.append(row.selectableValue!)
                    } else {
                        types.remove(at: types.index(of: row.selectableValue!)!)
                    }
                    Filter.shared.types = types
                })
        }
    }
    
    @IBAction func DidTouchUpDoneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
