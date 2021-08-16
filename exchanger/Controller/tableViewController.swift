//
//  tableViewController.swift
//  exchanger
//
//  Created by Patrik Duksin on 10.08.2021.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    var sender: UIButton?
    weak var delegate: setValueDelegate?

    var currencies: [Currency] = []
    var filltredCurrencies: [Currency] = []

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filltredCurrencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filltredCurrencies[indexPath.row].description
        cell.detailTextLabel?.text = filltredCurrencies[indexPath.row].code
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let title = sender?.title(for: .normal) else { return }
        delegate?.setValue(for: title, newValue: filltredCurrencies[indexPath.row])
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        filltredCurrencies = currencies
    }

    // MARK: - Search bar configuration

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filltredCurrencies.removeAll()
        if searchText.isEmpty {
            filltredCurrencies = currencies
        } else {
            currencies.forEach {
                guard let containInDescription =
                        $0.description?.lowercased().contains(searchText.lowercased()),
                      let containInCode = $0.code?.lowercased().contains(searchText.lowercased())
                else {return}

                if containInDescription || containInCode == true {
                    filltredCurrencies.append($0)
                }
            }
            tableView.reloadData()
        }
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
