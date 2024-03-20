//
//  RemotePokemonDetail.swift
//  
//
//  Created by 王富生 on 2024/3/16.
//

import Foundation

struct RemotePokemonDetail: Equatable {
    let id: Int
    let name: String
    let types: [String]
    let thumbnailImageURL: URL
    let stats: Stats
    let speciesURL: URL
    
    struct Stats: Equatable {
        let hp: Int
        let attack: Int
        let defense: Int
        let specialAttack: Int
        let specialDefense: Int
        let speed: Int
    }
    
    init(json: [String: Any]) {
        self.id = json["id"] as? Int ?? 0
        self.name = json["name"] as? String ?? ""
        self.types = (json["types"] as? [[String: Any]])?.compactMap { ($0["type"] as? [String: String])?["name"] } ?? []
        self.thumbnailImageURL = URL(string: (json["sprites"] as? [String: Any])?["front_default"] as? String ?? "") ?? URL(string: "https://static.wikia.nocookie.net/pokemon-fano/images/6/6f/Poke_Ball.png/revision/latest?cb=20140520015336")!
        
        var stats: [String: Int] = [:]
        (json["stats"] as? [[String: Any]])?.forEach {
            if let name = ($0["stat"] as? [String: String])?["name"] {
                stats[name] = $0["base_stat"] as? Int
            }
        }
        
        self.stats = Stats(hp: stats["hp", default: 0],
                           attack: stats["attack", default: 0],
                           defense: stats["defense", default: 0],
                           specialAttack: stats["special-attack", default: 0],
                           specialDefense: stats["special-defense", default: 0],
                           speed: stats["speed", default: 0])
        
        self.speciesURL = URL(string: (json["species"] as? [String: Any])?["url"] as? String ?? "") ?? URL(string: "https://pokeapi.co/api/v2/pokemon-species/1")!
    }
    
    init(id: Int, name: String, types: [String], thumbnailImageURL: URL, stats: Stats, speciesURL: URL) {
        self.id = id
        self.name = name
        self.types = types
        self.thumbnailImageURL = thumbnailImageURL
        self.stats = stats
        self.speciesURL = speciesURL
    }
}
