//
//  BattlefieldInfoTableViewCell.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/1/30.
//

import UIKit

class BattlefieldInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var functionLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setupInfo(profession: String, function: String, level: String) {
        professionLabel.text = profession
        functionLabel.text = function
        levelLabel.text = level
    }
}
