//
//  generalScreen.swift
//  exchanger
//
//  Created by Patrik Duksin on 31.07.2021.
//

import UIKit

class ExchangeView: UIView {
    @IBOutlet weak var topCurrencyButton: UIButton!
    @IBOutlet weak var bottomCurrencyButton: UIButton!
    @IBOutlet weak var changeCurrencyButton: UIButton!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
}

extension UIButton {
    func animate(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: CGFloat(1),
            initialSpringVelocity: CGFloat(4),
            options: UIView.AnimationOptions.allowUserInteraction,
            animations: {
                sender.transform = CGAffineTransform.identity
            }
        )
    }
}
