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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseCurrencyLabel.font = .systemFont(ofSize: 20, weight: .medium)
        targetCurrencyLabel.font = .systemFont(ofSize: 20, weight: .medium)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(currencyPairExchangeRate: CurrencyPairExchangeRate) {
        baseCurrencyLabel.text = currencyPairExchangeRate.currencyPair.baseCurrency.identifier
        targetCurrencyLabel.attributedText = constructTargetCurrencyLabel(
            targetCurrency: currencyPairExchangeRate.currencyPair.conversionTargetCurrency,
            exchangeRate: currencyPairExchangeRate.exchangeRate
        )
    }
    
    private func constructTargetCurrencyLabel(targetCurrency: Currency, exchangeRate: Double?) -> NSAttributedString {
        guard let exchangeRate = exchangeRate else {
            return NSAttributedString.init(string: targetCurrency.identifier)
        }
        return NSAttributedString.init(string: targetCurrency.identifier + "\(exchangeRate)")
    }
    
}
