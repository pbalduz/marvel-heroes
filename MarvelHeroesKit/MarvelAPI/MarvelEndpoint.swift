//
//  Created by Pablo Balduz on 07/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import Moya

public enum MarvelEndpoint: TargetType {
    case heroes(query: String?)
    
    public var baseURL: URL {
        return MarvelAPIClient.environment.baseURL
    }
    
    public var path: String {
        switch self {
        case .heroes:
            return "/v1/public/characters"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .heroes:
            return .get
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .heroes:
            return stubResponse(for: "heroes")
        }
    }
    
    public var task: Task {
        switch self {
        case .heroes(let query):
            var params = authParams
            if let query = query {
                params["nameStartsWith"] = query
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        ["Content-type": "application/json"]
    }
}

extension TargetType {
    
    var authParams: [String: Any] {
        let ts = "\(Date().timeIntervalSince1970)"
        return [
            "ts": ts,
            "apikey": MarvelAuth.publicKey,
            "hash": MarvelAuth.hash(ts: ts)
        ]
    }
}
