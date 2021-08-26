//
//  FlattenedCubeViewController.swift
//  Conways
//
//  Created by TribalScale on 2021-07-23.
//

import UIKit

class FlattenedCubeViewController: UIViewController {

    let leftView = ConwaysCoreGraphicsView()
    let rightView = ConwaysCoreGraphicsView()

    let topView = ConwaysCoreGraphicsView()
    let frontView = ConwaysCoreGraphicsView()
    let bottomView = ConwaysCoreGraphicsView()
    let backView = ConwaysCoreGraphicsView()
    
    private let dataSet = CubeDataSet()
    
    fileprivate var engineDelegates: [SquareDataSetDelegate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        engineDelegates = [leftView, rightView, topView, frontView, bottomView, backView]
        
        dataSet.delegate = self
        setupView()
                
        dataSet.newGame(n: 5)
    }
    
    private func setupView() {
        setupHorizontalView()
        
        let equalWidth1 = NSLayoutConstraint.init(item: leftView, attribute: .width, relatedBy: .equal, toItem: frontView, attribute: .width, multiplier: 1, constant: 0)
        
        let equalWidth2 = NSLayoutConstraint.init(item: rightView, attribute: .width, relatedBy: .equal, toItem: frontView, attribute: .width, multiplier: 1, constant: 0)
        
        let equalHeight1 = NSLayoutConstraint.init(item: topView, attribute: .height, relatedBy: .equal, toItem: frontView, attribute: .height, multiplier: 1, constant: 0)
        
        let equalHeight2 = NSLayoutConstraint.init(item: bottomView, attribute: .height, relatedBy: .equal, toItem: frontView, attribute: .height, multiplier: 1, constant: 0)
        
        let equalHeight3 = NSLayoutConstraint.init(item: backView, attribute: .height, relatedBy: .equal, toItem: frontView, attribute: .height, multiplier: 1, constant: 0)
        
        self.view.addConstraints([equalWidth1, equalWidth2, equalHeight1, equalHeight2, equalHeight3])
    }
    
    private func setupHorizontalView() {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = 5
        
        hStack.addArrangedSubview(leftView)
        hStack.addArrangedSubview(createVerticalView())
        hStack.addArrangedSubview(rightView)
        
        self.view.addSubview(hStack)
        
        let views = ["hStack" : hStack]
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[hStack]-(0)-|", options: .alignAllCenterY, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[hStack]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        self.view.addConstraints(hConstraints + vConstraints)
    }
    
    private func createVerticalView() -> UIView {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = 5
        
        vStack.addArrangedSubview(topView)
        vStack.addArrangedSubview(frontView)
        vStack.addArrangedSubview(bottomView)
        vStack.addArrangedSubview(backView)
        
        return vStack
    }
}

//extension FlattenedCubeViewController: SquareDataSetDelegate {
//    func newDataSet(data: [LifeData]) {
//        engineDelegates.forEach { (delegate) in
//            delegate.newDataSet(data: data)
//        }
//    }
//
//    func dataSetDidChange(data: [LifeData], modifiedIndicies: Set<Int>) {
//        engineDelegates.forEach { (delegate) in
//            delegate.dataSetDidChange(data: data, modifiedIndicies: modifiedIndicies)
//        }
//    }
//}

extension FlattenedCubeViewController: CubeDataSetDelegate {
    func newDataSet(data: [LifeData], onFace face: CubeDataSet.Face) {
        switch face {
        case .front:
            frontView.newDataSet(data: data)
            
        case .back:
            backView.newDataSet(data: data)

        case .left:
            leftView.newDataSet(data: data)

        case .right:
            rightView.newDataSet(data: data)

        case .top:
            topView.newDataSet(data: data)

        case .bottom:
            bottomView.newDataSet(data: data)
        }
    }
    
    func dataSetDidChange(data: [LifeData], onFace face: CubeDataSet.Face) {
        switch face {
        case .front:
            frontView.dataSetDidChange(data: data, modifiedIndicies: [])
            
        case .back:
            backView.dataSetDidChange(data: data, modifiedIndicies: [])

        case .left:
            leftView.dataSetDidChange(data: data, modifiedIndicies: [])

        case .right:
            rightView.dataSetDidChange(data: data, modifiedIndicies: [])

        case .top:
            topView.dataSetDidChange(data: data, modifiedIndicies: [])

        case .bottom:
            bottomView.dataSetDidChange(data: data, modifiedIndicies: [])
        }
    }
}
