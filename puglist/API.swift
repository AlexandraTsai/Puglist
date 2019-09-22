//
//  API.swift
//  puglist
//
//  Created by ST20991 on 2019/09/08.
//  Copyright © 2019 fengyi. All rights reserved.
//

import Foundation

enum API {
    static func getPugList(_ callback:@escaping (Error?, [Pug]?) -> ()) {
        URLSession.shared.dataTask(
            with: URL(string: "https://fengyi-line.github.io/Puglist/api/list.json")!
        ) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    callback(error, nil)
                }
                return
            }
            
            guard let data = data, let items = try? JSONDecoder().decode([Pug].self, from: data) else {
                DispatchQueue.main.async {
                    callback(nil, nil)
                }
                return
            }
            DispatchQueue.main.async {
                callback(nil, items)
            }
        }.resume()
    }

    static func getPugInfo(_ pugId:String, _ callback:@escaping (Error?, PugInfo?) -> ()) {
        URLSession.shared.dataTask(
            with: URL(string: "https://fengyi-line.github.io/Puglist/api/info/\(pugId).json")!
        ) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    callback(error, nil)
                }
                return
            }

            guard let data = data, let item = try? JSONDecoder().decode(PugInfo.self, from: data) else {
                DispatchQueue.main.async {
                    callback(nil, nil)
                }
                return
            }

            DispatchQueue.main.async {
                callback(nil, item)
            }
        }.resume()
    }
}

protocol APIProtocol {
    static func getPugList(_ callback:@escaping (Error?, [Pug]?) -> ()) 
    static func getPugInfo(_ pugId:String, _ callback:@escaping (Error?, PugInfo?) -> ())
}

extension API: APIProtocol {}

enum MockAPI: APIProtocol {
    static func getPugList(_ callback: @escaping (Error?, [Pug]?) -> ()) {
        //1. 模擬 Empty 狀態
        callback(nil, [])
        
        //2. 模擬 Error
//        callback(NSError.init(domain: "", code: 0, userInfo: nil), nil)
        
        //3. 模擬 Loading 狀態：（空白，不 callback）
//
        
        //4. 模擬 Normal 狀態
//        callback(nil,
//                 [.init(pugId: "tedthepug0810",
//                             name: "小巴哥",
//                             photo: "https://fengyi-line.github.io/Puglist/api/image/ted.jpg")])
    }
    
    static func getPugInfo(_ pugId: String, _ callback: @escaping (Error?, PugInfo?) -> ()) {
        
    }
}
