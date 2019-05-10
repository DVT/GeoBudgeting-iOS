//
//  StorePurchasesViewController.swift
//  GeoBudgeting
//
//  Created by David Minders on 5/9/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class StorePurchasesViewController: UIViewController {
    
    @IBOutlet weak var purchasesTableView: UITableView!
    
    
    var purchases: [Purchase] = [Purchase]()
    var storeName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = storeName
        
        FirebaseServices().fetchAllPurchases(forStore: storeName!) { [weak self] purchases in
            self!.updateTable(purchases: purchases)
        }
    }
    
    func updateTable(purchases: [Purchase]) {
        self.purchases = purchases
        purchasesTableView.reloadData()
    }
}

extension StorePurchasesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: PurchaseCell = purchasesTableView.dequeueReusableCell(withIdentifier: "PurchaseCell") as! PurchaseCell else {
            return UITableViewCell()
        }
        
        cell.amountLabel.text = String(purchases[indexPath.item].amount)
        let dateString: String = purchases[indexPath.item].date
        cell.dateLabel.text = fixDate(dateString: dateString)
        return cell
    }
    
    private func fixDate(dateString: String) -> String {
        
        let split = dateString.split(separator: " ")
        print("the split \(split)")
        let date = split[0] + " " + split[1] + " " + split[2]
        print(date)
        return date
    }
}
