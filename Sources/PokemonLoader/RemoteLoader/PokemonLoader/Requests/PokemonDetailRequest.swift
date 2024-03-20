//
//  PokemonDetailRequest.swift
//  
//
//  Created by 王富生 on 2024/3/18.
//

import Foundation
import Network

struct PokemonDetailRequest: APIRequest {
    var url: URL {
        pokemonURL
    }
    
    var httpMethod: Network.HTTPMethod {
        .get
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        .returnCacheDataElseLoad
    }
    
    private let pokemonURL: URL
    
    init(url: URL) {
        self.pokemonURL = url
    }
}
