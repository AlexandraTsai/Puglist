# Workshop: Web API Mocking 

source code: https://github.com/fengyi-line/puglist

---

[TOC]

---

### ISSUE
後端 API 沒完成時，前端該如何同步開發？ ➡︎ 介紹使用 ==Dependency Injection== 的方法


### Mock 的方法：
1. Server
2. Proxy
3. Client
    client 端改寫的方法有：
    * Hard Code
    * LLDB
    * DI (dependency injection)

### Sample Code

[Puglist](https://github.com/fengyi-line/puglist) 巴哥交友 App

![](https://i.imgur.com/eCUFsj2.gif)

#### 原始 code 解析
* Model
    >儲存巴哥資料的 object
    ```swift
    struct Pug: Codable {
        let pugId: String
        let name: String
        let photo: String
    }
    ```
* PlugListViewController ：
    > 巴哥清單 （第一頁）

    在 viewDidLoad 時，會呼叫 `func refresh()` ，`refresh()` 會在 call 完 API 並取得回傳值後更新 state。

    ```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refresh()
    }
    
    @objc
    func refresh() {
        state = .loading
        API.getPugList {[weak self] (error, pugs) in
            if let error = error {
                self?.state = .error(error)
                return
            }
            guard let pugs = pugs, !pugs.isEmpty else {
                self?.state = .empty
                return
            }
            self?.state = .normal(pugs)
        }
    }
    ```
    當 state 的值變更時，會依據 state 的狀態，更新 UI
    ```swift
    var state: PugListViewControllerState = .loading {
        didSet {
            switch state {
            case .normal(let items):
                centerLabel.text = nil
                self.navigationItem.title = "PUG (\(items.count))"
            case .error(_):
                centerLabel.text = "ERROR"
                self.navigationItem.title = "PUG"
            case .empty:
                centerLabel.text = "EMPTY"
                self.navigationItem.title = "PUG"
            case .loading:
                centerLabel.text = "LOADING..."
                self.navigationItem.title = "PUG"
            }
            self.tableView.reloadData()
        }
    }
    ```  
    ```swift
    //PugListViewController 的狀態，有四種（依 API 回傳結果）
    enum PugListViewControllerState {
        case normal([Pug])
        case error(Error)
        case empty
        case loading
    }
    ```
    
* API
    * 型別：Enum
    * 有兩個 static func
        1. `getPugList` 
        2. `getPugInfo`
    ```swift
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
    ```
### 利用 Dependency Injection 來 Mock Web API
#### 方法一： Protocol
透過 Protocol 的方式，創建 conform protocol 的 MockAPI，回傳假資料進行測試

##### STEP1：建立 protocol & 修改 API
```swift
protocol APIProtocol {
    static func getPugList(_ callback:@escaping (Error?, [Pug]?) -> ())
    static func getPugInfo(_ pugId:String, _ callback:@escaping (Error?, PugInfo?) -> ())
}

// 讓 enum conform APIProtocol
extension API: APIProtocol {}
```

##### STEP2：創建 MockAPI
```swift
enum MockAPI: APIProtocol {
    static func getPugList(_ callback:@escaping (Error?, [Pug]?) -> ()) {
     
        //1. 模擬 Empty 狀態
        callback(nil, []) 

        //2. 模擬 Error
        //callback(NSError.init(domain: "", code: 0, userInfo: nil), nil)

        //3. 模擬 Loading 狀態
        //空白（不 callback）

        //4. 模擬 Normal 狀態
        //callback(nil, [.init(pugId: "tedthepug0810", name: "小巴哥", photo: "https://fengyi-line.github.io/Puglist/api/image/ted.jpg")]))
    }
    static func getPugInfo(_ pugId:String, _ callback:@escaping (Error?, PugInfo?) -> ()) {
    }
}
```

##### STEP3：建立 PlugListViewController 的 init method & 修改 `func refresh()` 
```swift
// PlugListViewController.swift

var api: APIProtocol.Type

init(api: APIProtocol.Type) {
    self.api = api
    super.init(nibName: nil, bundle: nil)
}
    
required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
```
`API.getPugList` 改成 `api.getPugList`
```swift
// PlugListViewController.swift

@objc
func refresh() {
    state = .loading
    api.getPugList {[weak self] (error, pugs) in
        if let error = error {
            self?.state = .error(error)
            return
        }
        guard let pugs = pugs, !pugs.isEmpty else {
            self?.state = .empty
            return
        }
        self?.state = .normal(pugs)
    }
}
```

##### STEP4：修改 AppDelegate

初始 PugListViewController 時，可帶入 Mock API 進行測試了！！！

修改 `window?.rootViewController  = UINavigationController(rootViewController: PugListViewController())` 
``` swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window?.rootViewController  = UINavigationController(rootViewController: PugListViewController(api: MockAPI.self))
   
    return true
}
```

#### 方法二： Structure






