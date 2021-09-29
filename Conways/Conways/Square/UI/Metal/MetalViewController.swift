//
//  MetalViewControoller.swift
//  Conways
//
//  Created by TribalScale on 2021-09-25.
//

import UIKit
import MetalKit

class MetalViewController: UIViewController {
    
    var metalView: MTKView!
    var renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalView = MTKView()
        metalView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(metalView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[mtkView]|", options: [], metrics: nil, views: ["mtkView" : metalView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mtkView]|", options: [], metrics: nil, views: ["mtkView" : metalView]))

        let device = MTLCreateSystemDefaultDevice()!
        metalView.device = device
        
        metalView.colorPixelFormat = .bgra8Unorm
        
        renderer = Renderer(view: metalView, device: device)
        metalView.delegate = renderer
    }
}
