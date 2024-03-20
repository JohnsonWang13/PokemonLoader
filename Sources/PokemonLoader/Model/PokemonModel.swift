//
//  PokemonModel.swift
//  
//
//  Created by 王富生 on 2024/3/15.
//

import Foundation

public struct PokemonList: Equatable {
    let next: URL?
    let previous: URL?
    public let pokemonItems: [PokemonItem]
    
    public init(next: URL?, previous: URL?, pokemonItems: [PokemonItem]) {
        self.next = next
        self.previous = previous
        self.pokemonItems = pokemonItems
    }
}

public struct PokemonItem: Equatable, Decodable {
    public let name: String
    public let url: URL
    
    public init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}

public struct PokemonDetail: Equatable {
    public let id: Int
    public let name: String
    public let types: [String]
    public let thumbnailImageURL: URL
    public let stats: Stats
    public let speciesURL: URL
    
    public struct Stats: Equatable {
        public let hp: Int
        public let attack: Int
        public let defense: Int
        public let specialAttack: Int
        public let specialDefense: Int
        public let speed: Int
        
        public init(hp: Int, attack: Int, defense: Int, specialAttack: Int, specialDefense: Int, speed: Int) {
            self.hp = hp
            self.attack = attack
            self.defense = defense
            self.specialAttack = specialAttack
            self.specialDefense = specialDefense
            self.speed = speed
        }
    }
    
    public init(id: Int, name: String, types: [String], thumbnailImageURL: URL, stats: Stats, speciesURL: URL) {
        self.id = id
        self.name = name
        self.types = types
        self.thumbnailImageURL = thumbnailImageURL
        self.stats = stats
        self.speciesURL = speciesURL
    }
}

public struct PokemonSpecies: Equatable {
    public let id: Int
    public let description: String
    public let evolutionChainURL: URL
    
    public init(id: Int, description: String, evolutionChainURL: URL) {
        self.id = id
        self.description = description
        self.evolutionChainURL = evolutionChainURL
    }
}
