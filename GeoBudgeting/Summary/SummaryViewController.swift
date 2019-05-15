//
//  SummaryViewController.swift
//  GeoBudgeting
//
//  Created by David Minders on 5/15/19.
//  Copyright © 2019 DVT. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    var summerizedPurchases = [String: Double]()
    @IBOutlet weak var summaryTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        summerizePurchases() { [weak self] (summerizedPurchases) in
            self?.summerizedPurchases = summerizedPurchases
            self?.summaryTableview.reloadData()
        }
    }
    
    func summerizePurchases(completion: @escaping ([String: Double]) -> Void){
        var purchasesSummary = [String: Double]()
        FirebaseServices().fetchAllStoreAndPurchaseData(forUser: userID){allStoreData in
            
            for storeData in allStoreData {
                
                if purchasesSummary.index(forKey: storeData.category!) != nil {
                    var currentAmount: Double = purchasesSummary[storeData.category!] ?? 0
                    let storePurchases = storeData.purchases
                    let storePurchaseAmount = storePurchases?.map{$0.amount}.reduce(0, +)
                    currentAmount += storePurchaseAmount ?? 0
                    purchasesSummary[storeData.category!] = (currentAmount)
                    
                } else {
                    let storePurchases = storeData.purchases
                    let storePurchaseAmount = storePurchases?.map{$0.amount}.reduce(0, +)
                    purchasesSummary[storeData.category!] = storePurchaseAmount
                }
            }
            completion(purchasesSummary)
        }
    }
}

extension SummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summerizedPurchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: SummaryCell = summaryTableview.dequeueReusableCell(withIdentifier: "SummaryCell") as! SummaryCell else {
            return SummaryCell()
        }
        
        let categories = Array(summerizedPurchases.keys)
        cell.CategoryLabel.text = categories[indexPath.item]
        let amount = summerizedPurchases[categories[indexPath.item]]
        cell.amountLabel.text = String(format:"%.2f", amount ?? 0.0)
        
        return cell
    }
}
