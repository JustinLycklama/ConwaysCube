//
//  CubeDisplaySceneKitController.swift
//  Conways
//
//  Created by TribalScale on 2021-10-01.
//

import UIKit
import SceneKit

class CubeDisplaySceneKitController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    // MUST equal value in SCNProgram
    private let gameN = 16
    
    private let dataSet = CubeDataSet()
    
    var faceToDataMap: [CubeDataSet.Face : [Int8]] = [:]
    
    private let faceOrder: [CubeDataSet.Face] = [.top, .bottom, .front, .back, .right, .left]
    
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
        
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
            
        // Shader Program (Custom Metal Shader)
        let program = SCNProgram()
        program.fragmentFunctionName = "CubeFragmentShader"
        program.vertexFunctionName = "CubeVertexShader"
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
        
    fileprivate func saveLifeData(data: [LifeData], onFace face: CubeDataSet.Face) {
        let intValues = data.compactMap { (data: LifeData) -> Int8 in
            data.containsLife ? 1 : 0
        }
        
        faceToDataMap[face] = intValues
    }
    
    fileprivate func displayLifeData() {

        let orderedFacesIntValues = faceOrder.compactMap({ face in
            faceToDataMap[face] ?? []
        }).reduce([], +)
        
        
        if let device = scnView.device {
            material.setValue(ShaderUtilities.ArraytoData(orderedFacesIntValues, usingDevice: device), forKey: "game_data");
        }
    }
}

extension CubeDisplaySceneKitController: SCNProgramDelegate {
    func program(_ program: SCNProgram, handleError error: Error) {
        print(error)
    }
}

extension CubeDisplaySceneKitController: CubeDataSetDelegate {
    func newDataSet(data: [LifeData], onFace face: CubeDataSet.Face) {
        saveLifeData(data: data, onFace: face)
        displayLifeData()
    }
    
    func dataSetDidChange(data: [LifeData], onFace face: CubeDataSet.Face) {
        saveLifeData(data: data, onFace: face)
        displayLifeData()
    }
}
