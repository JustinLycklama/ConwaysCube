//
//  ConwaysCoreGraphicsView.swift
//  Conways
//
//  Created by Justin Lycklama on 2021-07-18.
//

import UIKit

class ConwaysCoreGraphicsView: UIView {
    
    private var lifeData: [LifeData] = []

    private var viewSize: CGSize = .zero
    private var cellSize: CGSize = .zero
    private var cellsPerEdge: Int = 0 { didSet { determineCellSize() }}
    private let borderWidth: CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewSize = self.bounds.size
        determineCellSize()
    }
    
    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.setStrokeColor(UIColor.gray.cgColor)
        ctx?.setLineWidth(borderWidth)
                
        let squareLength = min(viewSize.width, viewSize.height)
        
        let startX = (viewSize.width / 2) - (squareLength / 2)
        let startY = (viewSize.height / 2) - (squareLength / 2)
        
        for row in 0..<cellsPerEdge {
            for column in 0..<cellsPerEdge {
                let cell = getItemAt(row: row, column: column)
                
                ctx?.setFillColor(cell.containsLife ? UIColor.black.cgColor : UIColor.white.cgColor)

                let rectangle = CGRect(x: startX + cellSize.width * CGFloat(column), y: startY + cellSize.height * CGFloat(row), width: cellSize.width, height: cellSize.height)
                ctx?.addRect(rectangle)
                ctx?.drawPath(using: .fillStroke)
            }
        }
    }
    
    // MARK: Private
    
    fileprivate func determineCellSize() {
        let itemCount = CGFloat(cellsPerEdge)
        let screenWidth: CGFloat = viewSize.width
        let squareSize: CGFloat = screenWidth / itemCount
        
        cellSize = CGSize(width: squareSize, height: squareSize)
        setNeedsDisplay()
    }
    
    func getItemAt(row: Int, column: Int) -> LifeData {
        return lifeData[(row * cellsPerEdge + column)]
    }
}

extension ConwaysCoreGraphicsView: SquareDataSetDelegate {
    func newDataSet(data: [LifeData]) {
        self.lifeData = data
        self.cellsPerEdge = Int(Double(lifeData.count).squareRoot())
        setNeedsDisplay()
    }
    
    func dataSetDidChange(data: [LifeData], modifiedIndicies: Set<Int>) {
        self.lifeData = data
        setNeedsDisplay()
    }
}
