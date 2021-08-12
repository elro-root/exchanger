//
//  NetworkService.swift
//  exchanger
//
//  Created by Patrik Duksin on 10.08.2021.
//

import Foundation
import SwiftyJSON

class NetworkService {

    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var listOfCurrencies: [String: String] = [:]
    var currencies: [Currency] = []
    let group = DispatchGroup()
    func perform(url: URL, completionHandler: @escaping (Data) -> Void) {
        defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            if let error = error {
                self?.errorMessage += error.localizedDescription
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                completionHandler(data)
            }
        }.resume()
    }

    private func listOfCurrency(completionHandler: @escaping () -> Void) {
        guard let url = URL(string: "https://api.exchangerate.host/symbols") else {return}
        group.enter()
        perform(url: url) { [weak self] data in
            let json = JSON(data)["symbols"]
            for (_, description) in json {
                guard let code = description["code"].string,
                      let description = description["description"].string else { return }
                self?.listOfCurrencies.updateValue(description, forKey: code)
            }
            self?.group.leave()
        }
        completionHandler()
    }

    private func getRates(completionHandler: @escaping () -> Void) {
        guard let url = URL(string: "https://api.exchangerate.host/latest?base=USD") else { return }
        group.enter()
        perform(url: url) { [weak self] data in
            let json = JSON(data)["rates"]
            for (code, sell) in json {
                self?.currencies.append(Currency(description: nil, code: code, sell: sell.float))
            }
            self?.group.leave()
        }
        completionHandler()
    }
    public func getCurrencies(completion: @escaping ([Currency]) -> Void) {
//        let group = DispatchGroup()
        var currencies: [Currency] = []
        listOfCurrency {
            print("list done")
        }
        getRates {
            print("rates done")
        }
        group.notify(queue: .global()) {
            print("done")
            for index in 0 ..< self.currencies.count {
                guard let code = self.currencies[index].code,
                      let description = self.listOfCurrencies[code],
                      let sell = self.currencies[index].sell  else {return}
                currencies.append(Currency(description: description, code: code, sell: sell))
            }
            completion(currencies)
        }
    }
}
