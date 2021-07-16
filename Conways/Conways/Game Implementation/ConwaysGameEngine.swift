//
//  ConwaysGameEngine.swift
//  Conways
//
//  Created by TribalScale on 2021-07-16.
//

import Foundation

struct LifeData {
    let containsLife: Bool
    
    init(alive: Bool? = nil) {
        if let alive = alive {
            self.containsLife = alive
        } else {
            let diceRoll = Int.random(in: 1..<10)
            self.containsLife = diceRoll <= 3
        }
    }
}

protocol GameEngineDelegate: AnyObject {
    func initialzeGame(n: Int, initialData: [LifeData])
    func nextLifeCycle(newData: [LifeData], modifiedIndicies: Set<Int>)
}

class ConwaysGameEngine {
    weak var delegate: GameEngineDelegate?
    
    func initializeGame() {
        let lifeData = initLifeData(n: 30)
        queueNextEvolution(currentLife: lifeData, evolutionDelay: .milliseconds(500))
    }
    
    // Create an nxn grid
    private func initLifeData(n: Int) -> [LifeData] {
        var lifeData = [LifeData]()
        
        for _ in 0..<n*n {
            lifeData.append(LifeData())
        }
        
        delegate?.initialzeGame(n: n, initialData: lifeData)

        return lifeData
    }
    
    private func queueNextEvolution(currentLife: [LifeData], evolutionDelay: DispatchTimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + evolutionDelay) { [weak self] in
            self?.evaluateNextStage(currentLife) { nextStage, modifiedIndicies in
                self?.delegate?.nextLifeCycle(newData: nextStage, modifiedIndicies: modifiedIndicies)
                self?.queueNextEvolution(currentLife: nextStage, evolutionDelay: evolutionDelay)
            }
        }
    }
    
    /*
     Any live cell with fewer than two live neighbours dies, as if by underpopulation.
     Any live cell with two or three live neighbours lives on to the next generation.
     Any live cell with more than three live neighbours dies, as if by overpopulation.
     Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
     */
    
    private func evaluateNextStage(_ data: [LifeData], completion: @escaping ([LifeData], Set<Int>) -> Void) {
        var newLifeData: [LifeData?] = Array(repeating: nil, count: data.count)
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "thread-safe-obj", attributes: .concurrent)
        
        var modifiedIndicies = Set<Int>()

        for i in 0..<data.count {
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let oldLifeData = data[i]
                let nextLifeData: LifeData!

                let neighbourCount = self?.countNeighbours(for: data, at: i) ?? 0
                
                if !oldLifeData.containsLife {
                    nextLifeData = LifeData(alive: neighbourCount == 3)
                } else {
                    nextLifeData = LifeData(alive: neighbourCount >= 2 && neighbourCount <= 3)
                }
                
                queue.async(flags: .barrier) {
                    newLifeData[i] = nextLifeData
                    if oldLifeData.containsLife != nextLifeData.containsLife {
                        modifiedIndicies.insert(i)
                    }
                    
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(newLifeData as! [LifeData], modifiedIndicies)
        }
    }
    
    private func countNeighbours(for data: [LifeData], at arrayPosition: Int) -> Int {
        let n: Int = Int(Double(data.count).squareRoot())
        let row: Int = arrayPosition / n
        let column = arrayPosition % n
        
        var neibourCount = 0
        
        neibourCount += (getItemAt(row: row - 1, column: column - 1, forData: data)?.containsLife ?? false) ? 1 : 0
        neibourCount += (getItemAt(row: row - 1, column: column, forData: data)?.containsLife ?? false) ? 1 : 0
        neibourCount += (getItemAt(row: row - 1, column: column + 1, forData: data)?.containsLife ?? false) ? 1 : 0

        neibourCount += (getItemAt(row: row, column: column - 1, forData: data)?.containsLife ?? false) ? 1 : 0
        neibourCount += (getItemAt(row: row, column: column + 1, forData: data)?.containsLife ?? false) ? 1 : 0
        
        neibourCount += (getItemAt(row: row + 1, column: column - 1, forData: data)?.containsLife ?? false) ? 1 : 0
        neibourCount += (getItemAt(row: row + 1, column: column, forData: data)?.containsLife ?? false) ? 1 : 0
        neibourCount += (getItemAt(row: row + 1, column: column + 1, forData: data)?.containsLife ?? false) ? 1 : 0
        
        return neibourCount
    }
    
    private func getItemAt(row: Int, column: Int, forData data: [LifeData]) -> LifeData? {
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
