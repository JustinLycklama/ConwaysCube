//
//  AppSettings.swift
//  Conways
//
//  Created by TribalScale on 2021-07-23.
//

import Foundation
import UIKit

class AppSettings {
    static let shared = AppSettings()
    
    let isDebug = false
    let n: Int = 15
    let gameType: GameType = .squareCollection
    
    enum GameType {
        case squareCollection
        case squareCoreGraphics
        
        var viewController: UIViewController {
            switch self {
            case .squareCollection:
                return ConwaysViewController()
            case .squareCoreGraphics:
                return SquareDisplayViewController()
            }
        }
    }
}
