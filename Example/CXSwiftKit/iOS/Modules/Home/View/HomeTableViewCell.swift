//
//  HomeTableViewCell.swift
//  CXSwiftKit
//
//  Created by chenxing on 2023/7/10.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class HomeTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setup() {
        
    }
    
    override func layoutUI() {
        
    }
    
    override func addActions() {
        
    }
    
    func bind(to model: DataModel) {
        nameLabel.text = model.name
    }
    
}
