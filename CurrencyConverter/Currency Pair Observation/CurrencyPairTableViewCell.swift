//
//  CurrencyPairTableViewCell.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 11/13/19.
//

import UIKit

class CurrencyPairTableViewCell: UITableViewCell {

    @IBOutlet private weak var baseCurrencyLabel: UILabel!
    @IBOutlet private weak var targetCurrencyLabel: UILabel!
    
    private let amountFont = UIFont.systemFont(ofSize: 20, weight: .medium)
    private let identifierFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func update(currencyPairExchangeRate: CurrencyPairExchangeRate) {
        baseCurrencyLabel.attributedText = attributedLabel(
            forCurrency: currencyPairExchangeRate.currencyPair.baseCurrency,
            amount: 1
        )
                
        targetCurrencyLabel.attributedText = attributedLabel(
            forCurrency: currencyPairExchangeRate.currencyPair.conversionTargetCurrency,
            amount: currencyPairExchangeRate.exchangeRate
        )
    }
        
    private func attributedLabel(forCurrency currency: Currency, amount: Double?) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString()
        if let amount = amount {
            let amountAttributedString = NSAttributedString(
                string: String(amount),
                attributes: [.font: amountFont, .foregroundColor: UIColor.label]
            )
            mutableAttributedString.append(amountAttributedString)
        }
        
        let identifierAttributedString = NSAttributedString(
            string: currency.identifier,
            attributes: [.font: identifierFont, .foregroundColor: UIColor.secondaryLabel]
        )
        mutableAttributedString.append(identifierAttributedString)
        
        return mutableAttributedString
    }
    
}
