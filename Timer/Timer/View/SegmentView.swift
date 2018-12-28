//
//  SegmentView.swift
//  Timer
//
//  Created by Денис Андриевский on 12/15/18.
//  Copyright © 2018 Денис Андриевский. All rights reserved.
//

import UIKit
@IBDesignable
class SegmentView: UISegmentedControl {

    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    func customizeView() {
        
        layer.cornerRadius = 6.0
        layer.frame.size.height = 46.0
        
        
    }

}
