//
//  buttonView.swift
//  Timer
//
//  Created by Денис Андриевский on 12/15/18.
//  Copyright © 2018 Денис Андриевский. All rights reserved.
//

import UIKit
@IBDesignable
class buttonView: UIButton {

    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    
    func customizeView() {
        layer.cornerRadius = layer.frame.width/2
        layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        layer.borderWidth = 5.0
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
