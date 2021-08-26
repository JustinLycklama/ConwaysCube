//
//  CubeDataSet.swift
//  Conways
//
//  Created by TribalScale on 2021-08-06.
//

import Foundation

protocol CubeDataSetDelegate: AnyObject {
    func newDataSet(data: [LifeData], onFace: CubeDataSet.Face)
    func dataSetDidChange(data: [LifeData], onFace: CubeDataSet.Face)
}

class CubeDataSet {

    enum Face: Int, CaseIterable {
        case front = 0, back, left, right, top, bottom
        
        static var horizontalList: [Face] { [Face.left, .front, .right, .back] }
        static var verticalList: [Face] { [Face.top, .front, .bottom, .back] }
    }
    
    struct Coordinate {
        let row: Int
        let column: Int
        let face: Face
    }
    
    fileprivate var faceMap: [Face: [LifeData]] = [:]
    
    fileprivate var n: Int = 0
    fileprivate var totalLifePerFace: Int = 0 {
        didSet {
            n = Int(Double(totalLifePerFace).squareRoot())
        }
    }
    
    fileprivate let engine = ConwaysGameEngine()
    
    weak var delegate: CubeDataSetDelegate?
    
    init() {
        engine.dataSource = self
    }

    func newGame(n: Int) {
        totalLifePerFace = n*n
        
        for face in Face.allCases {
            var data = [LifeData]()
            
            for i in 0..<totalLifePerFace {
                let life: LifeData!

                if AppSettings.shared.isDebug {
//                    let coordinate = getCoordinate(for: i, of: totalLife)
//                    life = LifeData(debugString: "row: \(coordinate.row), col: \(coordinate.column)")
                    life = LifeData()

                } else {
                    life = LifeData()
                }

                data.append(life)
            }

            faceMap[face] = data
            delegate?.newDataSet(data: data, onFace: face)
        }
        
        engine.initializeGame()
    }
    
    private func getCoordinate(for arrayPosition: Int) -> Coordinate {
        let faceIndex = Int(arrayPosition / totalLifePerFace)
        
        let arrayPositionWithinFace = arrayPosition % totalLifePerFace
        
        let row: Int = arrayPositionWithinFace / n
        let column = arrayPositionWithinFace % n
        
        let face: Face! = Face(rawValue: faceIndex)
        if face == nil {
            print("Face Calculation Failed: \(faceIndex)")
            exit(0)
        }
        
        return Coordinate(row: row, column: column, face: face)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension CubeDataSet: GameEngineDataSource {
    var lifeData: [LifeData] {
        var totalData = [LifeData]()
        for face in Face.allCases {
            totalData.append(contentsOf: faceMap[face] ?? [])
        }
        
        return totalData
    }
    
    func setLifeData(data: [LifeData], modifiedIndicies: Set<Int>) {
        
        let dataChunks = data.chunked(into: totalLifePerFace)
        
        guard dataChunks.count == Face.allCases.count else {
            print("Chunking data for cube failed")
            return
        }
        
        for i in 0..<dataChunks.count {
            let face = Face.allCases[i]
            faceMap[face] = dataChunks[i]
            
            delegate?.dataSetDidChange(data: dataChunks[i], onFace: face)
        }
        
//        delegate?.dataSetDidChange(data: data, modifiedIndicies: modifiedIndicies)
    }
    
    func getNeighbours(at index: Int) -> [LifeData] {
        let coordinate = getCoordinate(for: index)
        
        let left = horizontalNeibour(coordinate, direction: .left)
        let right = horizontalNeibour(coordinate, direction: .right)
        
        let top = verticalNeibour(coordinate, direction: .up)
        let bottom = verticalNeibour(coordinate, direction: .down)
        
        let topleft = horizontalNeibour(top, direction: .left)
        let topRight = horizontalNeibour(top, direction: .right)
        
        let bottomLeft = horizontalNeibour(bottom, direction: .left)
        let bottomRight = horizontalNeibour(bottom, direction: .right)
        
        let coordinates = [left, right, top, bottom, topleft, topRight, bottomLeft, bottomRight]
            
        return coordinates.compactMap { (coordinate: Coordinate) -> LifeData? in
            getItemAt(coordinate: coordinate)
        }
    }
        
    enum HDirection: Int {
        case left = -1, right = 1
    }
    
    func horizontalNeibour(_ from: Coordinate, direction: HDirection) -> Coordinate {
        var nextRow = from.row
        var nextColumn = from.column + direction.rawValue
        var nextFace = from.face
        
        // If the new column is still within our face, we are done
        if nextColumn < 0 || nextColumn >= n {
            // If the new column is ourside our face, find the new face
            switch from.face {
            // No Coordinate Axis Rotations
            case .left, .right, .front, .back:
                guard let currentFacePos = Face.horizontalList.firstIndex(of: from.face) else {
                    exit(0)
                }
                
                var nextFacePos = currentFacePos + direction.rawValue
                if nextFacePos < 0 {
                    nextFacePos = Face.horizontalList.count - 1
                }
                if nextFacePos >= Face.horizontalList.count {
                    nextFacePos = 0
                }
                
                nextFace = Face.horizontalList[nextFacePos]
                
                if nextColumn < 0 {
                    nextColumn = n - 1
                } else {
                    nextColumn = 0
                }
                                                                
            // Requires Coordinate Axis Rotations
            case .top, .bottom:
                if from.face == .bottom && direction == .left ||
                    from.face == .top && direction == .right {
                    nextColumn =  (n-1) - from.row
                } else {
                    nextColumn = from.row
                }
                
                nextRow = from.face == .top ? 0 : n - 1
                nextFace = (direction == .left) ? .left : .right
            }
        }
                        
        return Coordinate(row: nextRow, column: nextColumn, face: nextFace)
    }
    
    enum VDirection: Int {
        case up = -1, down = 1
    }
    
    func verticalNeibour(_ from: Coordinate, direction: VDirection) -> Coordinate {
                
        var nextRow = from.row + direction.rawValue
        var nextColumn = from.column
        var nextFace = from.face
        
        // If the new column is still within our face, we are done
        if nextRow < 0 || nextRow >= n {
            switch from.face {
            case .front, .top, .bottom, .back:
                
                guard let currentFacePos = Face.verticalList.firstIndex(of: from.face) else {
                    exit(0)
                }
                
                var modifiedDirection = direction.rawValue
                if from.face == .back {
                    modifiedDirection *= -1
                }
                
                var nextFacePos = currentFacePos + modifiedDirection
                if nextFacePos < 0 {
                    nextFacePos = Face.verticalList.count - 1
                }
                if nextFacePos >= Face.verticalList.count {
                    nextFacePos = 0
                }
                
                nextFace = Face.verticalList[nextFacePos]
                
                // If we are moving to or from the back, we need to inverse our row and column
                if from.face == .back || nextFace == .back {
                    if nextRow < 0 {
                        nextRow = 0
                    } else {
                        nextRow = n - 1
                    }
                    
                    nextColumn = n - 1 - nextColumn
                } else {
                    if nextRow < 0 {
                        nextRow = n - 1
                    } else {
                        nextRow = 0
                    }
                }
                
            // Requires Coordinate Axis Rotations
            case .left, .right:
                if from.face == .left && direction == .down ||
                    from.face == .right && direction == .up {
                    nextRow = (n-1) - from.column
                } else {
                    nextRow = from.column
                }
                
                nextColumn = from.face == .left ? 0 : n - 1
                nextFace = (direction == .down) ? .bottom : .top
            }
        }
        
        return Coordinate(row: nextRow, column: nextColumn, face: nextFace)
    }
    
    private func getItemAt(coordinate: Coordinate) -> LifeData? {
        guard coordinate.row >= 0, coordinate.row < n, coordinate.column >= 0, coordinate.column < n else {
            return nil
        }
        
        let arrayPosition: Int = coordinate.row * n + coordinate.column
        if arrayPosition >= 0 && arrayPosition < n*n {
            return faceMap[coordinate.face]?[arrayPosition]
        }
        
        print("Array item not within bounds?")
        return nil
    }
}
