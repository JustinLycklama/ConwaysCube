//
//  ShaderStructs.swift
//  Conways
//
//  Created by Justin Lycklama on 2021-09-25.
//

import Foundation
import UIKit

struct UnusableShaderGameData {
    let values = [Int8]()
}

/*
    To pass data from CPU to GPU we need to create an object on both sides that has the same definition.
 This way we can transform the data to bytes on our end, and the GPU can read it directly without havingany overhead of figuring out the Type
 (this will fail if your objects are not exactly equal: the byte data will not be the same and we will not be able to unwrap it on the GPU side)
 
 Turns out swift does not have fixed size arrays, which is a problem if I want to send an array of 256 ints.
 Just creating an array (Array = []) and filling it will values will not create an array of exactly size 256 * sizeOf(Int).
 
 Normally for passing data to the shader we would just fill out a swift struct to match the shader struct.
 Since that is not possible for arrays, lets manually create the bytes of the shader struct.
 */

class ShaderUtilities {
    static func ArraytoData<T>(_ array: [T], usingDevice device: MTLDevice) -> Data {
        let sizeOfElement = MemoryLayout<T>.stride
        let sizeOfUniformBuffer = sizeOfElement * array.count

        let buffer = device.makeBuffer(length: sizeOfUniformBuffer, options: .cpuCacheModeWriteCombined)
        let pointer = buffer?.contents()
                
        if let pointer = pointer {
            var mutableArray = array
            
            for i in 0..<mutableArray.count {
                memcpy(pointer + (i * sizeOfElement), &mutableArray[i], sizeOfElement)
            }
            
            return Data(bytes: pointer, count: sizeOfUniformBuffer)
        }
        
        return Data()
    }
}


