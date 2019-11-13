//
//  AddPairTableViewCell.swift
//  CurrencyConverter
//
//  Created by Mindaugas Jucius on 10/11/2019.
//

import UIKit

class AddPairTableViewCell: UITableViewCell {

    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var addPairLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        plusImageView.image = UIImage.init(systemName: "plus.circle.fill")
        addPairLabel.font = .systemFont(ofSize: 20, weight: .medium)
        addPairLabel.text = NSLocalizedString("add_pair", comment: "")
        addPairLabel.textColor = .systemBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
