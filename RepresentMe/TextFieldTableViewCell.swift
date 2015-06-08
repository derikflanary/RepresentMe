//
//  TextFieldTableViewCell.swift
//  RepresentMe
//
//  Created by Derik Flanary on 6/8/15.
//  Copyright (c) 2015 Derik Flanary. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    var textField = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField = UITextField(frame: CGRectMake(15, 0, 200, self.contentView.frame.size.height))
        textField.keyboardType = UIKeyboardType.NumberPad
        self.contentView.addSubview(textField)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
