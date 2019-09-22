//
//  puglistTests.swift
//  puglistTests
//
//  Created by ST20991 on 2019/08/28.
//  Copyright © 2019 fengyi. All rights reserved.
//

import XCTest
@testable import puglist

class puglistTests: XCTestCase {
    func testEmpty() {
        let vc = PugListViewController.init(api: MockEmpty.self)
        _ = vc.view //為了呼叫 viewDidLoad，加上這行
        if case PugListViewControllerState.empty = vc.state {
            
        } else {
            XCTFail("Not empty")
        }
    }
    
    func testLoading() {
        let vc = PugListViewController.init(api: MockLoading.self)
        _ = vc.view //為了呼叫 viewDidLoad，加上這行
        if case PugListViewControllerState.loading = vc.state {
            
        } else {
            XCTFail("Not loading")
        }
    }
    
    func testError() {
        let vc = PugListViewController.init(api: MockError.self)
        _ = vc.view //為了呼叫 viewDidLoad，加上這行
        if case PugListViewControllerState.error(_) = vc.state {
            
        } else {
            XCTFail("No eroor")
        }
    }
    
    func testNormal() {
        let vc = PugListViewController.init(api: MockNormal.self)
        _ = vc.view //為了呼叫 viewDidLoad，加上這行
        if case PugListViewControllerState.normal(_) = vc.state {
            
        } else {
            XCTFail("Not normal")
        }
    }
}

private enum MockEmpty: APIProtocol {
    static func getPugList(_ callback: @escaping (Error?, [Pug]?) -> ()) {
        callback(nil, [])
    }
    
    static func getPugInfo(_ pugId: String, _ callback: @escaping (Error?, PugInfo?) -> ()) {
        
    }
}

private enum MockError: APIProtocol {
    static func getPugList(_ callback: @escaping (Error?, [Pug]?) -> ()) {
        callback(NSError.init(domain: "", code: 0, userInfo: nil), nil)
    }
    
    static func getPugInfo(_ pugId: String, _ callback: @escaping (Error?, PugInfo?) -> ()) {
        
    }
}

private enum MockLoading: APIProtocol {
    static func getPugList(_ callback: @escaping (Error?, [Pug]?) -> ()) {
        //不 callback
    }
    
    static func getPugInfo(_ pugId: String, _ callback: @escaping (Error?, PugInfo?) -> ()) {
        
    }
}

private enum MockNormal: APIProtocol {
    static func getPugList(_ callback: @escaping (Error?, [Pug]?) -> ()) {
        callback(nil, [.init(pugId: "", name: "", photo: "")])
    }
    
    static func getPugInfo(_ pugId: String, _ callback: @escaping (Error?, PugInfo?) -> ()) {
        
    }
}
