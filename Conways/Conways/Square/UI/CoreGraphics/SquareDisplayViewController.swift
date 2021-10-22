//
//  SquareDisplayViewController.swift
//  Conways
//
//  Created by Justin Lycklama on 2021-07-18.
//

import UIKit

class SquareDisplayViewController: UIViewController {

    private let coreView = ConwaysCoreGraphicsView()    
    private let dataSet = SquareDataSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSet.delegate = coreView
        setupView()
        
        dataSet.newGame(n: 45)
    }
    
    private func setupView() {
        
        coreView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(coreView)
        
        let views = ["core" : coreView]        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0)-[core]-(>=0)-|",
                                                                options: .alignAllCenterX, metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[core]-(0)-|",
                                                                options: .alignAllCenterY, metrics: nil, views: views)
        
        self.view.addConstraints(verticalConstraints + horizontalConstraints)
        self.view.addConstraint(.init(item: coreView,
                                      attribute: .centerY,
                                      relatedBy: .equal,
                                      toItem: self.view,
                                      attribute: .centerY,
                                      multiplier: 1, constant: 0))
        self.view.addConstraint(.init(item: coreView,
                                      attribute: .height,
                                      relatedBy: .equal,
                                      toItem: coreView,
                                      attribute: .width,
                                      multiplier: 1, constant: 0))
    }
}
