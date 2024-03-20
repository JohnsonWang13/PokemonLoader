//
//  PokemonSpeciesRequest.swift
//  
//
//  Created by 王富生 on 2024/3/18.
//

import Foundation
import Network

struct PokemonSpeciesRequest: APIRequest {
    var url: URL {
        pokemonSpeciesURL
    }
    
    var httpMethod: Network.HTTPMethod {
        .get
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        .returnCacheDataElseLoad
    }
    
    private let pokemonSpeciesURL: URL
    
    init(url: URL) {
        self.pokemonSpeciesURL = url
    }
}
