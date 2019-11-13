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
    
    func update(pair: CurrencyPair, exchangeRate: Double) {
        baseCurrencyLabel.text = pair.baseCurrency.identifier
        targetCurrencyLabel.attributedText = constructTargetCurrencyLabel(
            targetCurrency: pair.conversionTargetCurrency,
            exchangeRate: exchangeRate
        )
    }
    
    private func constructTargetCurrencyLabel(targetCurrency: Currency, exchangeRate: Double) -> NSAttributedString {
        return NSAttributedString.init(string: targetCurrency.identifier + "\(exchangeRate)")
    }
    
}
