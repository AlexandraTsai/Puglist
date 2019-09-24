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
        var api = API()
        api.getPugList = { callback in
            callback(nil, [])
        }
        let vc = PugListViewController.init(api: api)
        _ = vc.view //為了呼叫 viewDidLoad，加上這行
        if case PugListViewControllerState.empty = vc.state {
            
        } else {
            XCTFail("Not empty")
        }
    }
    
    func testLoading() {
        var api = API()
        api.getPugList = { callback in
           
        }
        let vc = PugListViewController.init(api: api)
        _ = vc.view //為了呼叫 viewDidLoad，加上這行
        if case PugListViewControllerState.loading = vc.state {
            
        } else {
            XCTFail("Not loading")
        }
    }
    
    func testError() {
        var api = API()
        api.getPugList = { callback in
            callback(NSError(domain: "", code: 0, userInfo: nil), nil)
        }
        let vc = PugListViewController.init(api: api)
        _ = vc.view //為了呼叫 viewDidLoad，加上這行
        if case PugListViewControllerState.error(_) = vc.state {
            
        } else {
            XCTFail("No eroor")
        }
    }
    
    func testNormal() {
        var api = API()
        api.getPugList = { callback in
            callback(nil, [.init(pugId: "", name: "", photo: "")])
        }
        let vc = PugListViewController.init(api: api)
        _ = vc.view //為了呼叫 viewDidLoad，加上這行
        if case PugListViewControllerState.normal(_) = vc.state {
            
        } else {
            XCTFail("Not normal")
        }
    }
}
