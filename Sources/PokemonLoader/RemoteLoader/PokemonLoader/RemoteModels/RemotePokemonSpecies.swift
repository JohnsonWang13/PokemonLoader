//
//  RemotePokemonSpecies.swift
//  
//
//  Created by 王富生 on 2024/3/16.
//

import Foundation

struct RemotePokemonSpecies: Equatable {
    public let id: Int
    public let description: String
    public let evolutionChainURL: URL
    
    init(id: Int, description: String, evolutionChainURL: URL) {
        self.id = id
        self.description = description
        self.evolutionChainURL = evolutionChainURL
    }
    
    init(json: [String: Any]) {
        self.id = json["id"] as? Int ?? 0
        
        let allDescriptions = json["flavor_text_entries"] as? [[String: Any]]
        let firstChDescription = allDescriptions?.first { ($0["language"] as? [String: String])?["name"] == "zh-Hant" }
        self.description = firstChDescription?["flavor_text"] as? String ?? ""
        
        self.evolutionChainURL = URL(string: (json["evolution_chain"] as? [String: Any])?["url"] as? String ?? "") ?? URL(string: "https://pokeapi.co/api/v2/evolution-chain/1")!
    }
}
