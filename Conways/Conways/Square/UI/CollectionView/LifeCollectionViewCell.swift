//
//  LifeCollectionViewCell.swift
//  Conways
//
//  Created by TribalScale on 2021-07-16.
//

import UIKit

class LifeCollectionViewCell: UICollectionViewCell {

    var debugLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setDebugString(_ string: String?) {
        if AppSettings.shared.isDebug && debugLabel == nil {
            
            let label = UILabel()
            debugLabel = label
            
            label.textAlignment = .center
            label.frame = self.contentView.bounds
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.contentView.addSubview(label)
        }
        
        debugLabel?.text = string
    }
}
