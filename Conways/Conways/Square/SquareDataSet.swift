//
//  SquareDataSet.swift
//  Conways
//
//  Created by TribalScale on 2021-08-06.
//

import Foundation

protocol SquareDataSetDelegate: AnyObject {
    func newDataSet(data: [LifeData])
    func dataSetDidChange(data: [LifeData], modifiedIndicies: Set<Int>)
}

class SquareDataSet {
    
    struct Coordinate {
        let row: Int
        let column: Int
    }
    
    fileprivate var data: [LifeData] = []
    fileprivate let engine = ConwaysGameEngine()
    
    weak var delegate: SquareDataSetDelegate?
    
    init() {
        engine.dataSource = self
    }

    func newGame(n: Int) {
        var data = [LifeData]()

        let totalLife = n*n
        for i in 0..<totalLife {
            let life: LifeData!

            if AppSettings.shared.isDebug {
                let coordinate = getCoordinate(for: i, of: totalLife)
                life = LifeData(debugString: "row: \(coordinate.row), col: \(coordinate.column)")
            } else {
                life = LifeData()
            }

            data.append(life)
        }

        self.data = data
        
        delegate?.newDataSet(data: data)
        engine.initializeGame()
    }
    
    private func getCoordinate(for arrayPosition: Int, of total: Int) -> Coordinate {
        let n: Int = Int(Double(total).squareRoot())
        let row: Int = arrayPosition / n
        let column = arrayPosition % n
        
        return Coordinate(row: row, column: column)
    }
}

extension SquareDataSet: GameEngineDataSource {
    var lifeData: [LifeData] {
        data
    }
    
    func setLifeData(data: [LifeData], modifiedIndicies: Set<Int>) {
        self.data = data
        delegate?.dataSetDidChange(data: data, modifiedIndicies: modifiedIndicies)
    }
    
    func getNeighbours(at index: Int) -> [LifeData] {
        let coordinate = getCoordinate(for: index, of: data.count)
        
        let neibours: [LifeData?] = [
            getItemAt(row: coordinate.row - 1, column: coordinate.column - 1),
            getItemAt(row: coordinate.row - 1, column: coordinate.column),
            getItemAt(row: coordinate.row - 1, column: coordinate.column + 1),

            
            getItemAt(row: coordinate.row, column: coordinate.column - 1),
            getItemAt(row: coordinate.row, column: coordinate.column + 1),
            
            getItemAt(row: coordinate.row + 1, column: coordinate.column - 1),
            getItemAt(row: coordinate.row + 1, column: coordinate.column),
            getItemAt(row: coordinate.row + 1, column: coordinate.column + 1)
        ]
        
        return neibours.compactMap { $0 }
    }
    
    private func getItemAt(row: Int, column: Int) -> LifeData? {
        let n = Int(Double(data.count).squareRoot())
        guard row >= 0, row < n, column >= 0, column < n else {
            return nil
        }
        
        let arrayPosition: Int = row * n + column
        if arrayPosition >= 0 && arrayPosition < n*n {
            return data[arrayPosition]
        }
        
        return nil
    }
}
