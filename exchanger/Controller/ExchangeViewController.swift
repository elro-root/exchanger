//
//  ExchangeViewController.swift
//  exchanger
//
//  Created by Patrik Duksin on 10.08.2021.
//

import UIKit

protocol setValueDelegate: AnyObject {
    func setValue(for code: String, newValue: Currency)
}

class ExchangeViewController: UIViewController {
    
    public var exchangeView: ExchangeView! {
        guard isViewLoaded else { return nil }
        return (view as? ExchangeView ?? nil)
    }
    
    private var currencies: [Currency] = []
    
    private var topCurrency = Currency() {
        didSet {
            DispatchQueue.main.async {
                self.exchangeView.topCurrencyButton.setTitle(self.topCurrency.code, for: .normal)
            }
        }
    }
    private var bottomCurrency = Currency() {
        didSet {
            DispatchQueue.main.async {
                self.exchangeView.bottomCurrencyButton.setTitle(self.bottomCurrency.code, for: .normal)
            }
        }
    }
    
    let network  = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        exchangeView.changeCurrencyButton.backgroundColor = UIColor(red: 140 / 255, green: 18 / 255, blue: 255 / 255, alpha: 0.98)
        exchangeView.changeCurrencyButton.layer.cornerRadius = 16
        setupKeyboard(textField: exchangeView.topField)
        setupKeyboard(textField: exchangeView.bottomField)
        DispatchQueue.global(qos: .userInteractive).async {
            self.network.getCurrencies {[weak self]resources in
                var data = resources
                data.sort(by: {$0.description! < $1.description!})
                self?.currencies = data
                self?.currencies.forEach({currency in
                    guard let top =
                            currency.code?.lowercased().contains("USD".lowercased()),
                          let bottom =
                            currency.code?.lowercased().contains("RUB".lowercased())
                    else { return }
                    if top {
                        self?.topCurrency = currency
                    } else if bottom {
                        self?.bottomCurrency = currency
                    }
                })
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? TableViewController else { return }
        viewController.sender = sender as? UIButton
        viewController.currencies = currencies
        viewController.delegate = self
        DispatchQueue.main.async {
            viewController.tableView.reloadData()
        }
    }
    
    @IBAction func swapCurrency(_ sender: Any) {
        exchangeView.changeCurrencyButton.animate(sender: exchangeView.changeCurrencyButton)
        swap(&topCurrency, &bottomCurrency)
    }
    
}

// MARK: - Configure keyboard

extension ExchangeViewController {
    private func setupKeyboard(textField: UITextField) {
        textField.keyboardType = .decimalPad
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self,
                                     action: #selector(done))
        toolBar.setItems([space, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    @objc func done() {
        view.endEditing(true)
    }
    
}

// MARK: - Delegate
extension ExchangeViewController: setValueDelegate {
    func setValue(for code: String, newValue: Currency) {
        guard let topCode = topCurrency.code,
              let bottomCode = bottomCurrency.code else { return }
        switch code {
        case topCode:
            topCurrency = newValue
        case bottomCode:
            bottomCurrency = newValue
        default:
            print("cannot assign new currency")
        }
    }
}
