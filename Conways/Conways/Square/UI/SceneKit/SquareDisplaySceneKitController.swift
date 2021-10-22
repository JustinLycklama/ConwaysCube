//
//  SquareDisplaySceneKitController.swift
//  Conways
//
//  Created by TribalScale on 2021-08-18.
//

import UIKit
import SceneKit

class SquareDisplaySceneKitController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    // MUST equal value in SCNProgram
    private let gameN = 16
    
    private let dataSet = SquareDataSet()
    
    private let scnView = SCNView()
    let material = SCNMaterial()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSet.delegate = self
        setupScene()
        
        dataSet.newGame(n: gameN)
    }
    
    func setupScene() {
        // create a new scene
        let scene = SCNScene()

        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 1)
        
        let box = SCNBox(width: 1, height: 1, length: 0.01, chamferRadius: 0)
        
        // Shader Program (Custom Metal Shader)
        let program = SCNProgram()
        program.fragmentFunctionName = "SquareFragmentShader"
        program.vertexFunctionName = "SquareVertexShader"
        program.delegate = self

        material.program = program

        let node = SCNNode(geometry: box)
        
        box.firstMaterial = material
        box.firstMaterial?.diffuse.contents = UIColor.red
        box.firstMaterial?.isDoubleSided = true
        node.position = SCNVector3(0, 0, -1)
        
        scene.rootNode.addChildNode(node)

        // configure the SCNView
        scnView.scene = scene
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = .white
        scnView.loops = true
        scnView.isPlaying = true
        scnView.backgroundColor = .lightGray
        
        let initialArray = [Int8](repeating: 0, count: gameN*gameN)
        
        if let device = scnView.device {
            material.setValue(ShaderUtilities.ArraytoData(initialArray, usingDevice: device), forKey: "game_data");
        }
        
        self.view.addSubview(scnView)

        scnView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["view" : scnView]
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[view]-(0)-|",
                                                                options: .alignAllCenterX, metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|",
                                                                options: .alignAllCenterY, metrics: nil, views: views)
        
        self.view.addConstraints(verticalConstraints + horizontalConstraints)
    }
    
    fileprivate func displayLifeData(data: [LifeData]) {
        let intValues = data.compactMap { (data: LifeData) -> Int8 in
            data.containsLife ? 1 : 0
        }
        
        if let device = scnView.device {
            material.setValue(ShaderUtilities.ArraytoData(intValues, usingDevice: device), forKey: "game_data");
        }
    }
}

extension SquareDisplaySceneKitController: SCNProgramDelegate {
    func program(_ program: SCNProgram, handleError error: Error) {
        print(error)
    }
}

extension SquareDisplaySceneKitController: SquareDataSetDelegate {
    func newDataSet(data: [LifeData]) {
        displayLifeData(data: data)
    }
    
    func dataSetDidChange(data: [LifeData], modifiedIndicies: Set<Int>) {
        displayLifeData(data: data)
    }
}
