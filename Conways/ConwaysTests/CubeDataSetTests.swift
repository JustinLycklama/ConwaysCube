//
//  CubeDataSetTests.swift
//  ConwaysTests
//
//  Created by TribalScale on 2021-08-13.
//

import XCTest
@testable import Conways

class CubeDataSetTests: XCTestCase {

    let sut = CubeDataSet()
    
    override func setUpWithError() throws {
        sut.newGame(n: 6)
    }

    // MARK: - Base Case
    
    // MARK: Front
    func testFrontBaseCase() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 4, face: .front),
                                      direction: .left)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 3)
        XCTAssertEqual(n.face, .front)
    }
    
    // MARK: Left
    func testLeftBaseCase() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 4, face: .left),
                                      direction: .left)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 3)
        XCTAssertEqual(n.face, .left)
    }
    
    // MARK: Right
    func testRightBaseCase() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 4, face: .right),
                                      direction: .left)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 3)
        XCTAssertEqual(n.face, .right)
    }
    
    // MARK: Back
    func testBackBaseCase() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 4, face: .back),
                                      direction: .left)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 3)
        XCTAssertEqual(n.face, .back)
    }
    
    // MARK: Bottom
    func testBottomBaseCase() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 4, face: .bottom),
                                      direction: .left)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 3)
        XCTAssertEqual(n.face, .bottom)
    }
    
    // MARK: Top
    func testTopBaseCase() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 4, face: .top),
                                      direction: .left)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 3)
        XCTAssertEqual(n.face, .top)
    }
}

// MARK: - Left Rotation
extension CubeDataSetTests {
    
    // MARK: Front
    func testFrontFaceLeft() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 0, face: .front),
                                      direction: .left)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 5)
        XCTAssertEqual(n.face, .left)
    }
    
    // MARK: Left
    func testLeftFaceLeft() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 0, face: .left),
                                      direction: .left)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 5)
        XCTAssertEqual(n.face, .back)
    }
    
    // MARK: Back
    func testBackFaceLeft() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 0, face: .back),
                                      direction: .left)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 5)
        XCTAssertEqual(n.face, .right)
    }
    
    // MARK: Right
    func testRightFaceLeft() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 0, face: .right),
                                      direction: .left)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 5)
        XCTAssertEqual(n.face, .front)
    }

    // MARK: Bottom
    func testBottomFaceLeft() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 0, face: .bottom),
                                      direction: .left)
        
        XCTAssertEqual(n.row, 5)
        XCTAssertEqual(n.column, 1)
        XCTAssertEqual(n.face, .left)
    }
    
    // MARK: Top
    func testTopFaceLeft() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 0, face: .top),
                                      direction: .left)
        
        XCTAssertEqual(n.row, 0)
        XCTAssertEqual(n.column, 4)
        XCTAssertEqual(n.face, .left)
    }
}

// MARK: - Right Rotation
extension CubeDataSetTests {
    
    // MARK: Front
    func testFrontFaceRight() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 5, face: .front),
                                      direction: .right)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 0)
        XCTAssertEqual(n.face, .right)
    }
    
    // MARK: Left
    func testLeftFaceRight() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 5, face: .left),
                                      direction: .right)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 0)
        XCTAssertEqual(n.face, .front)
    }
    
    // MARK: Back
    func testBackFaceRight() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 5, face: .back),
                                      direction: .right)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 0)
        XCTAssertEqual(n.face, .left)
    }
    
    // MARK: Right
    func testRightFaceRight() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 5, face: .right),
                                      direction: .right)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 0)
        XCTAssertEqual(n.face, .back)
    }

    // MARK: Bottom
    func testBottomFaceRight() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 5, face: .bottom),
                                      direction: .right)
        
        XCTAssertEqual(n.row, 5)
        XCTAssertEqual(n.column, 4)
        XCTAssertEqual(n.face, .right)
    }
    
    // MARK: Top
    func testTopFaceRight() {
        
        let n = sut.horizontalNeibour(CubeDataSet.Coordinate(row: 4, column: 5, face: .top),
                                      direction: .right)
        
        XCTAssertEqual(n.row, 0)
        XCTAssertEqual(n.column, 1)
        XCTAssertEqual(n.face, .right)
    }
}

// MARK: - Up Rotation
extension CubeDataSetTests {
    // MARK: Front
    func testFrontFaceUp() {
        
        let n = sut.verticalNeibour(CubeDataSet.Coordinate(row: 0, column: 4, face: .front),
                                    direction: .up)
        
        XCTAssertEqual(n.row, 5)
        XCTAssertEqual(n.column, 4)
        XCTAssertEqual(n.face, .top)
    }
    
    // MARK: Left
    func testLeftFaceUp() {
        
        let n = sut.verticalNeibour(CubeDataSet.Coordinate(row: 0, column: 2, face: .left),
                                    direction: .up)
        
        XCTAssertEqual(n.row, 2)
        XCTAssertEqual(n.column, 0)
        XCTAssertEqual(n.face, .top)
    }
    
    // MARK: Back
    func testBackFaceUp() {
        
        let n = sut.verticalNeibour(CubeDataSet.Coordinate(row: 0, column: 4, face: .back),
                                    direction: .up)
        
        XCTAssertEqual(n.row, 0)
        XCTAssertEqual(n.column, 1)
        XCTAssertEqual(n.face, .top)
    }
    
    // MARK: Right
    func testRightFaceUp() {
        
        let n = sut.verticalNeibour(CubeDataSet.Coordinate(row: 0, column: 5, face: .right),
                                    direction: .up)
        
        XCTAssertEqual(n.row, 0)
        XCTAssertEqual(n.column, 5)
        XCTAssertEqual(n.face, .top)
    }

    // MARK: Bottom
    func testBottomFaceUp() {
        
        let n = sut.verticalNeibour(CubeDataSet.Coordinate(row: 0, column: 2, face: .bottom),
                                    direction: .up)
        
        XCTAssertEqual(n.row, 5)
        XCTAssertEqual(n.column, 2)
        XCTAssertEqual(n.face, .front)
    }
    
    // MARK: Top
    func testTopFaceUp() {
        
        let n = sut.verticalNeibour(CubeDataSet.Coordinate(row: 0, column: 3, face: .top),
                                    direction: .up)
        
        XCTAssertEqual(n.row, 0)
        XCTAssertEqual(n.column, 2)
        XCTAssertEqual(n.face, .back)
    }
}

// MARK: - Down Rotation
extension CubeDataSetTests {
    
    // MARK: Front
    func testFrontFaceDown() {
        
        let n = sut.verticalNeibour(CubeDataSet.Coordinate(row: 5, column: 4, face: .front),
                                    direction: .down)
        
        XCTAssertEqual(n.row, 0)
        XCTAssertEqual(n.column, 4)
        XCTAssertEqual(n.face, .bottom)
    }
    
    // MARK: Left
    func testLeftFaceDown() {
        
        let n = sut.verticalNeibour(CubeDataSet.Coordinate(row: 5, column: 3, face: .left),
                                    direction: .down)
        
        XCTAssertEqual(n.row, 2)
        XCTAssertEqual(n.column, 0)
        XCTAssertEqual(n.face, .bottom)
    }
    
    // MARK: Back
    func testBackFaceDown() {
        
        let n = sut.verticalNeibour(CubeDataSet.Coordinate(row: 5, column: 3, face: .back),
                                    direction: .down)
        
        XCTAssertEqual(n.row, 5)
        XCTAssertEqual(n.column, 2)
        XCTAssertEqual(n.face, .bottom)
    }
    
    // MARK: Right
    func testRightFaceDown() {
        
        let n = sut.verticalNeibour(CubeDataSet.Coordinate(row: 5, column: 4, face: .right),
                                    direction: .down)
        
        XCTAssertEqual(n.row, 4)
        XCTAssertEqual(n.column, 5)
        XCTAssertEqual(n.face, .bottom)
    }

    // MARK: Bottom
    func testBottomFaceDown() {
        
        let n = sut.verticalNeibour(CubeDataSet.Coordinate(row: 5, column: 2, face: .bottom),
                                    direction: .down)
        
        XCTAssertEqual(n.row, 5)
        XCTAssertEqual(n.column, 3)
        XCTAssertEqual(n.face, .back)
    }
    
    // MARK: Top
    func testTopFaceDown() {
        
        let n = sut.verticalNeibour(CubeDataSet.Coordinate(row: 5, column: 3, face: .top),
                                    direction: .down)
        
        XCTAssertEqual(n.row, 0)
        XCTAssertEqual(n.column, 3)
        XCTAssertEqual(n.face, .front)
    }
}
