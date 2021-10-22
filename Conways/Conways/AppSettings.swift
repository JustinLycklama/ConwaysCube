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
    let gameType: GameType = .cubeSceneKit
    let gameDelay: DispatchTimeInterval = .milliseconds(800)
    
    enum GameType {
        case squareCollection
        case squareCoreGraphics
        case squareSceneKit
        case squareMetal
        case flatCube
        case cubeSceneKit
        
        var viewController: UIViewController {
            switch self {
            case .squareCollection:
                return ConwaysViewController()
            case .squareCoreGraphics:
                return SquareDisplayViewController()
            case .squareSceneKit:
                return SquareDisplaySceneKitController()
            case .squareMetal:
                return MetalViewController()
            case .flatCube:
                return FlattenedCubeViewController()
            case .cubeSceneKit:
                return CubeDisplaySceneKitController()
            }
        }
    }
}
