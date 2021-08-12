//
//  ConwaysLifeData.swift
//  Conways
//
//  Created by TribalScale on 2021-08-06.
//

import Foundation

struct LifeData {
    let containsLife: Bool
    
    let debugString: String?
    
    init(alive: Bool? = nil) {
        if let alive = alive {
            self.containsLife = alive
        } else {
            let diceRoll = Int.random(in: 1..<10)
            self.containsLife = diceRoll <= 3
        }
        
        debugString = nil
    }
    
    init(debugString: String) {
        self.debugString = debugString
        self.containsLife = false
    }
}

protocol GameEngineDataSource: AnyObject {
    var lifeData: [LifeData] { get }
    func setLifeData(data: [LifeData], modifiedIndicies: Set<Int>)
    
    func getNeighbours(at index: Int) -> [LifeData]
}
