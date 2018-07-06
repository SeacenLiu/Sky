//
//  UnitTestHelp.swift
//  SkyTests
//
//  Created by SeacenLiu on 2018/7/6.
//  Copyright © 2018年 Mars. All rights reserved.
//

import XCTest
@testable import Sky

class UnitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // 这里放测试用例中执行前需要初始化和设置的代码
    }
    
    override func tearDown() {
        // 这里放测试用例结束后需要执行的后续操作代码
        super.tearDown()
    }
    
    // 单元测试的方法名开头必须有test，名字上最好将测试的内容都表示清楚
    func testExample() {
        // 测试的内容
        // 使用 XCTAssert 去查看测试的结果是否符合预期（类似断言的用法）
    }
    
}
