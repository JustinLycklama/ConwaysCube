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
    let gameType: GameType = .flatCube
    let gameDelay: DispatchTimeInterval = .milliseconds(500)    
    
    enum GameType {
        case squareCollection
        case squareCoreGraphics
        case flatCube
        
        var viewController: UIViewController {
            switch self {
            case .squareCollection:
                return ConwaysViewController()
            case .squareCoreGraphics:
                return SquareDisplayViewController()
            case .flatCube:
                return FlattenedCubeViewController()
            }
        }
    }
}
