//
//  Search.swift
//  GeoBudgeting
//
//  Created by Marie Kristein-Harmsen on 2019/05/03.
//  Copyright © 2019 DVT. All rights reserved.
//

import Foundation
import UIKit

class SearchView: UIView {
    var searchTextView: UITextField = {
        let uiTextField=UITextField()
        uiTextField.borderStyle = .roundedRect
        uiTextField.backgroundColor = .white
        uiTextField.layer.borderColor = UIColor.darkGray.cgColor
        uiTextField.placeholder="Search here"
        uiTextField.translatesAutoresizingMaskIntoConstraints=false
        return uiTextField
    }()
}
