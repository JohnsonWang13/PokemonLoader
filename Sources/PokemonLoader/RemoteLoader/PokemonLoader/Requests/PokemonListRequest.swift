//
//  File.swift
//  
//
//  Created by 王富生 on 2024/3/18.
//

import Foundation
import Network

struct PokemonListRequest: APIRequest {
    var url: URL {
        URL(string: "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=\(limit)")!
    }
    
    var httpMethod: Network.HTTPMethod {
        .get
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        .returnCacheDataElseLoad
    }
    
    private let offset: Int
    private let limit: Int
    
    init(offset: Int = 20, limit: Int = 20) {
        self.offset = offset
        self.limit = limit
    }
}
