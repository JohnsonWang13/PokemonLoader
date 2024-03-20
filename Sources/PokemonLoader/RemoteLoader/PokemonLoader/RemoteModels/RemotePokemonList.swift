//
//  RemotePokemonList.swift
//  
//
//  Created by 王富生 on 2024/3/16.
//

import Foundation

struct RemotePokemonList: Equatable, Decodable {
    let next: String?
    let previous: String?
    let results: [PokemonItem]
    
    struct RemotePokemonItem: Equatable, Decodable {
        let name: String
        let url: URL
        
        init(name: String, url: URL) {
            self.name = name
            self.url = url
        }
    }
}


