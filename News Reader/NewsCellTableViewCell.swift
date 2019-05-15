//
//  NewsCellTableViewCell.swift
//  News Reader
//
//  Created by MacOS on 4/2/19.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit

class NewsCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var NewsImage: UIImageView!
    @IBOutlet weak var titleOfNews: UILabel!
    @IBOutlet weak var authorOfNews: UILabel!
    @IBOutlet weak var sourceOfNews: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
