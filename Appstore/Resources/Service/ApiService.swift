//
//  ApiService.swift
//  Appstore
//
//  Created by 윤성환 on 2023/03/19.
//

import Foundation
import Alamofire

class ApiService {
    
    struct Config {
        static let baseURL = "\(Common.baseURL)"
        //https://itunes.apple.com/search?term=kakaobank&country=kr&entity=software&limit=5
    }
    
    var isConnectedToInternet : Bool {
        get { return NetworkReachabilityManager()?.isReachable ?? false }
    }
    
    static let shared = ApiService()
    private var request : DataRequest?
    private var headers : HTTPHeaders? = nil
    
    private var reachability = NetworkReachabilityManager()!
    
    private lazy var indicator : UIImageView = {
        let _indicator = UIImageView()
        _indicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        _indicator.loadGif(name: "loading_gif")
        return _indicator
    }()

    func startIndicator(controller : UIViewController) {
        self.indicator.center = controller.view.center
        controller.view.addSubview(indicator)
    }

    func stopIndicator(controll : UIViewController) {
        self.indicator.removeFromSuperview()
    }
    
    func SearchResult(controller: UIViewController, params: String,  whenIfFailed: @escaping (String?) -> Void, completionHandler: @escaping (_SearchResult) -> Void) {
        if isConnectedToInternet {
            startIndicator(controller: controller)

            request = AF.request("\(Config.baseURL+params+"&entity=software")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "", method: .post, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let obj) :
                    do {
                        print("CompareResult2 : ", params)
                        let data = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted) // obj(Any)를 Json으로 변경
                        print("Compare data2: ", data)
                        let result = try JSONDecoder().decode(_SearchResult.self, from: data) // Json Decoder사용 (Codable)

                        let stringValue = String(decoding: data, as: UTF8.self)
                        print("data2", stringValue)
                        

                        print("Compare result2 : ", result)
                        completionHandler(result)
                        
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                case .failure(let e) :
                    print(e.localizedDescription)
                    whenIfFailed(nil)
                }
                self.stopIndicator(controll: controller)
            }
        } else { whenIfFailed("CommonText1") }
    }
    
    
}
