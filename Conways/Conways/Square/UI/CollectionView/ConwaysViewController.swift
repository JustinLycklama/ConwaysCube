//
//  ViewController.swift
//  Conways
//
//  Created by TribalScale on 2021-07-16.
//

import UIKit

class ConwaysViewController: UIViewController {
    
    private let dataSet = SquareDataSet()
    
    private let cellIdentifier = "Cell"
    private let spaceBetweenCells: CGFloat = 1
    fileprivate var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        dataSet.delegate = self
        dataSet.newGame(n: 25)
    }
    
    fileprivate func determineCellSize(n: Int) -> CGSize {
        let itemCount = CGFloat(n)
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let squareSize: CGFloat = (screenWidth - (spaceBetweenCells * (itemCount - 1))) / itemCount
        
        return CGSize(width: squareSize, height: squareSize)
    }
    
    fileprivate func buildLayout(cellSize: CGSize) -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = spaceBetweenCells
        layout.minimumLineSpacing = spaceBetweenCells
        layout.itemSize = cellSize
        
        return layout
    }
    
    fileprivate func setupCollection(_ layout: UICollectionViewLayout, forCellSize cellSize: CGSize, withNItems n: Int) {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(LifeCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionView)

        let heightOfCollection = cellSize.height * CGFloat(n) + (spaceBetweenCells * (CGFloat(n) - 1))
        
        let views = ["collection" : collectionView]
        let metrics = ["height": heightOfCollection]
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0)-[collection(height)]-(>=0)-|",
                                                                options: .alignAllCenterX, metrics: metrics, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[collection]-(0)-|",
                                                                options: .alignAllCenterY, metrics: nil, views: views)
        
        self.view.addConstraints(verticalConstraints + horizontalConstraints)
        self.view.addConstraint(.init(item: collectionView,
                                      attribute: .centerY,
                                      relatedBy: .equal,
                                      toItem: self.view,
                                      attribute: .centerY,
                                      multiplier: 1, constant: 0))
        
        collectionView.backgroundColor = .darkGray
        collectionView.reloadData()

        self.collectionView = collectionView
    }
}

extension ConwaysViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSet.lifeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? LifeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = dataSet.lifeData[indexPath.row].containsLife ? .black : .white
        
        if AppSettings.shared.isDebug {
            cell.setDebugString(dataSet.lifeData[indexPath.row].debugString)
        }
        
        return cell
    }
}

extension ConwaysViewController: SquareDataSetDelegate {
    func newDataSet(data: [LifeData]) {
        let n =  Int(Double(data.count).squareRoot())
        
        let cellSize = determineCellSize(n: n)
        let layout = buildLayout(cellSize: cellSize)

        setupCollection(layout, forCellSize: cellSize, withNItems: n)
    }
    
    func dataSetDidChange(data: [LifeData], modifiedIndicies: Set<Int>) {
        collectionView?.reloadItems(at: modifiedIndicies.map { (index: Int) -> IndexPath in
            return IndexPath(row: index, section: 0)
        })
    }
}
