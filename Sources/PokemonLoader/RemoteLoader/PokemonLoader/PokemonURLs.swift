//
//  PokemonURLs.swift
//  
//
//  Created by 王富生 on 2024/3/17.
//

import Foundation

final class PokemonURLs {
    static func list(offset: Int, limit: Int) -> URL {
        URL(string: "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=\(limit)")!
    }
    
    static func detail(id: Int) -> URL {
        URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
    }
    
    static func species(id: Int) -> URL {
        URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(id)")!
    }
}
