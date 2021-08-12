//
//  ExchangeViewController.swift
//  exchanger
//
//  Created by Patrik Duksin on 10.08.2021.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    private var currencies: [Currency] = []
    
    let network  = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        guard let viewController = segue.destination as? TableViewController else { return }
        network.getCurrencies() { [weak self] resources in
            viewController.currencies = resources
        }
        //        viewController.tableView.reloadData()
    }
    
}
