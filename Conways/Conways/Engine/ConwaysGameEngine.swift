//
//  ConwaysGameEngine.swift
//  Conways
//
//  Created by TribalScale on 2021-07-16.
//

import Foundation

class ConwaysGameEngine {
    weak var dataSource: GameEngineDataSource?
    
    func initializeGame(withDelay delay: DispatchTimeInterval = AppSettings.shared.gameDelay) {
        queueNextEvolution(evolutionDelay: delay)
    }

    private func queueNextEvolution(evolutionDelay: DispatchTimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + evolutionDelay) { [weak self] in
            self?.evaluateNextStage { nextStage, modifiedIndicies in
                self?.dataSource?.setLifeData(data: nextStage, modifiedIndicies: modifiedIndicies)
                self?.queueNextEvolution(evolutionDelay: evolutionDelay)
            }
        }
    }
    
    /*
     Any live cell with fewer than two live neighbours dies, as if by underpopulation.
     Any live cell with two or three live neighbours lives on to the next generation.
     Any live cell with more than three live neighbours dies, as if by overpopulation.
     Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
     */
    
    private func evaluateNextStage(completion: @escaping ([LifeData], Set<Int>) -> Void) {
        
        let data = dataSource?.lifeData ?? []
        let lifeDataTotal = data.count
        
        var nextData: [LifeData?] = Array(repeating: nil, count: lifeDataTotal)
        var modifiedIndicies = Set<Int>()
        
        let group = DispatchGroup()
         
        for _ in 0..<lifeDataTotal {
            group.enter()
        }
        
        let numCores = ProcessInfo.processInfo.processorCount
        let dataPerCore: Int = lifeDataTotal / numCores
        
        for i in 0..<numCores {
            let low = dataPerCore * i
            var high = dataPerCore * (i + 1)
            
            // edge case for any remaining data fill in last core
            if i == numCores - 1 {
                high += lifeDataTotal % numCores
            }
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                for i in low..<high {
                    let oldLifeData = data[i]
                    let nextLifeData: LifeData!
                    
                    let aliveNeibours = self?.dataSource?.getNeighbours(at: i).reduce(0) { (count: Int, next: LifeData) -> Int in
                        return count + (next.containsLife ? 1 : 0)
                    } ?? 0
                                        
                    if !oldLifeData.containsLife {
                        nextLifeData = LifeData(alive: aliveNeibours == 3)
                    } else {
                        nextLifeData = LifeData(alive: aliveNeibours >= 2 && aliveNeibours <= 3)
                    }
                    
                     DispatchQueue.main.async {
                        nextData[i] = nextLifeData
                        if oldLifeData.containsLife != nextLifeData.containsLife {
                            modifiedIndicies.insert(i)
                        }
                        
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(nextData as! [LifeData], modifiedIndicies)
        }
    }
}
