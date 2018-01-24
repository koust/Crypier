
import Foundation
import Alamofire
import SwiftyJSON

enum Router: URLRequestConvertible {
    static let baseURLString = "http://coincap.io"
    static let dovizURLString = "http://www.doviz.gen.tr"
    static var token: String? = nil;
    static var doviz: Int? = nil;
    
    
    case front
    case oneDayHistory(String)
    case oneDayHistoryPrice(JSON,String)
    case login(String)
    case coinPage(String)
    case kurlar
    
    
    var method: HTTPMethod {
        switch self {
        case .front , .oneDayHistory,.oneDayHistoryPrice,.coinPage,.kurlar:
            return .get
        case .login:
            return .post
        }
    }
    
    
    var path: String{
        switch self {
        case .front:
            return "/front"
        case .oneDayHistory(let coin),.oneDayHistoryPrice(_,let coin):
            return "/history/365day/\(coin)"
        case .login:
            return "/tlogin"
        case .coinPage(let coin):
            return "/page/\(coin)"
        case .kurlar:
            return "/doviz_json.asp"

        }
        
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let access_token):
            return [
                "access_token": access_token
            ]

        default:
            return nil
        }
    }
    
    var encoding : ParameterEncoding {
        switch self {
        case .login:
            return JSONEncoding.default;
        default:
            return URLEncoding.default;
        }
    }
    
    
    public func asURLRequest() throws -> URLRequest {
        
        var requestURLString = Router.baseURLString.appending(self.path);
        if Router.doviz == 1 {
             requestURLString = Router.dovizURLString.appending(self.path);
        }else{
             requestURLString = Router.baseURLString.appending(self.path);
        }
        print(requestURLString)
        let requestURL = URL(string: requestURLString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!;
        var request = try URLRequest(url: requestURL, method: self.method)
        
        request = try self.encoding.encode(request, with: self.parameters);
        
        request.cachePolicy = .reloadIgnoringLocalCacheData;
        
        if let token = Router.token {
            
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization");
        }
        
        
        //URLCache.shared.removeAllCachedResponses();
    
        
        return request;
    }
    
    enum APIError: Error {
        case invalidUrl
    }
    
    
    
}
