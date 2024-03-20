//
//  RemotePokemonLoader.swift
//  
//
//  Created by 王富生 on 2024/3/16.
//

import XCTest
import TestHelper
import Network
import PokemonLoader
@testable import PokemonLoader

final class RemotePokemonLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFormURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestURLs.isEmpty)
    }
    
    // MARK: - Pokemon List
    func test_loadPokemonList_requestDataFromURL() {
        let (sut, client) = makeSUT()
        let pokemonListURL = pokemonListURL()
        
        sut.loadPokemonList(offset: 0, limit: 0) { _ in }

        XCTAssertEqual(client.requestURLs, [pokemonListURL])
    }
    
    func test_loadPokemonListTwice_requestDataFromURL() {
        
        let (sut, client) = makeSUT()
        
        let url = pokemonListURL()
        
        sut.loadPokemonList(offset: 0, limit: 0) { _ in }
        sut.loadPokemonList(offset: 0, limit: 0) { _ in }

        XCTAssertEqual(client.requestURLs, [url, url])
    }
    
    func test_loadPokemonList_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expectPokemonListLoad(sut, toCompleteWith: .failure(LoaderError.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: .failure(clientError))
        }
    }
    
    func test_loadPokemonList_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expectPokemonListLoad(sut, toCompleteWith: .failure(LoaderError.invalidData)) {
                let pokemonList = makePokemonList(next: nil, previous: nil, items: [])
                let JSONData = makeData(with: pokemonList.json)
                client.complete(withStatusCode: code, data: JSONData, at: index)
            }
        }
    }
    
    func test_loadPokemonList_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expectPokemonListLoad(sut, toCompleteWith: .failure(LoaderError.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_loadPokemonList_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        let emptyList = makePokemonList(next: nil, previous: nil, items: [])
        expectPokemonListLoad(sut,
               toCompleteWith: .success(emptyList.list),
               when: {
            let emptyJSON = makeData(with: emptyList.json)
            client.complete(withStatusCode: 200, data: emptyJSON)
        })
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithJSONList() {
        let (sut, client) = makeSUT()
        
        let nextURL = URL(string: "https://pokeapi.co/api/v2/pokemon?offset=40&limit=20")!
        let previousURL = URL(string:  "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20")!
        let (item1, _) = makePokemonItems(name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)
        let (item2, _) = makePokemonItems(name: "ivysaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/2/")!)
        let pokemonList = makePokemonList(next: nextURL, previous: previousURL, items: [item1, item2])
        
        expectPokemonListLoad(sut,
               toCompleteWith: .success(pokemonList.list),
               when: {
            
            let JSONData = makeData(with: pokemonList.json)
            client.complete(withStatusCode: 200, data: JSONData)
        })
    }
    

    // MARK: - Pokemon Detail
    func test_loadPokemonDetail_requestDataFromURL() {
        let (sut, client) = makeSUT()
        
        let url = pokemonDetailURL(id: 0)
        
        sut.loadPokemonDetail(url: url) { _ in }

        XCTAssertEqual(client.requestURLs, [url])
    }

    func test_loadPokemonDetailTwice_requestDataFromURL() {
        
        let (sut, client) = makeSUT()
        
        let url = pokemonDetailURL(id: 0)
        
        sut.loadPokemonDetail(url: url) { _ in }
        sut.loadPokemonDetail(url: url) { _ in }

        XCTAssertEqual(client.requestURLs, [url, url])
    }

    func test_loadPokemonDetail_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expectPokemonDetailLoad(sut, toCompleteWith: .failure(LoaderError.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: .failure(clientError))
        }
    }

    func test_loadPokemonDetail_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expectPokemonDetailLoad(sut, toCompleteWith: .failure(LoaderError.invalidData)) {
                let pokemonDetail = makeRemotePokemonDetail()
                let JSONData = makeData(with: pokemonDetail.json)
                client.complete(withStatusCode: code, data: JSONData, at: index)
            }
        }
    }

    func test_loadPokemonDetail_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expectPokemonDetailLoad(sut, toCompleteWith: .failure(LoaderError.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }


    func test_loadPokemonDetail_deliversNoItemsOn200HTTPResponseWithJSONList() {
        let (sut, client) = makeSUT()
        
        let pokemonDetail = makeRemotePokemonDetail()
        expectPokemonDetailLoad(sut,
                            toCompleteWith: .success(pokemonDetail.detail),
                            when: {
            
            let JSONData = makeData(with: pokemonDetail.json)
            client.complete(withStatusCode: 200, data: JSONData)
        })
    }
    
    // MARK: - Pokemon species
    func test_loadPokemonSpecies_requestDataFromURL() {
        let url = pokemonSpeciesURL(id: 0)
        let (sut, client) = makeSUT()
        
        sut.loadPokemonSpecies(url: url) { _ in }
        
        XCTAssertEqual(client.requestURLs, [url])
    }
    
    func test_loadPokemonSpeciesTwice_requestDataFromURL() {
        let url = pokemonSpeciesURL(id: 0)
        let (sut, client) = makeSUT()
        
        sut.loadPokemonSpecies(url: url) { _ in }
        sut.loadPokemonSpecies(url: url) { _ in }
        
        XCTAssertEqual(client.requestURLs, [url, url])
    }
    
    func test_loadPokemonSpecies_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expectPokemonSpeciesLoad(sut, toCompleteWith: .failure(LoaderError.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: .failure(clientError))
        }
    }
    
    func test_loadPokemonSpecies_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expectPokemonSpeciesLoad(sut, toCompleteWith: .failure(LoaderError.invalidData)) {
                let pokemonSpecies = makePokemonSpecies()
                let JSONData = makeData(with: pokemonSpecies.json)
                client.complete(withStatusCode: code, data: JSONData, at: index)
            }
        }
    }
    
    func test_loadPokemonSpecies_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expectPokemonSpeciesLoad(sut, toCompleteWith: .failure(LoaderError.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_loadPokemonSpecies_deliversNoItemsOn200HTTPResponseWithJSONList() {
        let (sut, client) = makeSUT()
        
        let pokemonSpecies = makePokemonSpecies()
        
        expectPokemonSpeciesLoad(sut,
               toCompleteWith: .success(pokemonSpecies.species),
               when: {
            
            let JSONData = makeData(with: pokemonSpecies.json)
            client.complete(withStatusCode: 200, data: JSONData)
        })
    }
    
    // MARK: - Helper

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (RemotePokemonLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePokemonLoader(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
    
    private func pokemonListURL(offset: Int = 0, limit: Int = 0) -> URL {
        return PokemonURLs.list(offset: offset, limit: limit)
    }
    
    private func pokemonDetailURL(id: Int) -> URL {
        return PokemonURLs.detail(id: id)
    }
    
    private func pokemonSpeciesURL(id: Int) -> URL {
        return PokemonURLs.species(id: id)
    }
    
    // MARK: - List Helper
    
    private func makePokemonItems(name: String, url: URL) -> (model: PokemonItem, json: [String: Any]) {
        let item = PokemonItem(name: name, url: url)
        let json = ["name": name, "url": url.absoluteString]
        return (item, json)
    }
    
    private func makePokemonList(next: URL?, previous: URL?, items: [PokemonItem]) -> (list: PokemonList, json: [String: Any]) {
        let list = PokemonList(next: next, previous: previous, pokemonItems: items)
        let itemsJson = items.map { makePokemonItems(name: $0.name, url: $0.url).json }
        var json = [String: Any]()
        json["next"] = next?.absoluteString
        json["previous"] = previous?.absoluteString
        json["results"] = itemsJson
        return (list, json)
    }
    
    private func expectPokemonListLoad(_ sut: RemotePokemonLoader, toCompleteWith result: LoaderResult<PokemonList>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults: [LoaderResult<PokemonList>] = []
        
        sut.loadPokemonList(offset: 0, limit: 0) { capturedResults.append($0) }

        action()

        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    // MARK: - Detail Helper
    
    private func makeRemotePokemonDetail() -> (detail: PokemonDetail, json: [String: Any]) {
        let stats = PokemonDetail.Stats(hp: 45, attack: 49, defense: 49, specialAttack: 65, specialDefense: 65, speed: 45)
        let detail = PokemonDetail(id: 1,
                                   name: "bulbasaur",
                                   types: ["grass", "poison"],
                                   thumbnailImageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!,
                                   stats: stats,
                                   speciesURL: URL(string: "https://pokeapi.co/api/v2/pokemon-species/1")!)
        
        let types: [[String: Any]] = [
            [
                "slot": 1,
                "type": [
                    "name": "grass",
                    "url": "https://pokeapi.co/api/v2/type/12/"
                ]
            ],
            [
                "slot": 2,
                "type": [
                    "name": "poison",
                    "url": "https://pokeapi.co/api/v2/type/4/"
                ]
            ]
        ]
        let statsJSON: [[String: Any]] = [
            [
                "base_stat": 45,
                "effort": 0,
                "stat": [
                    "name": "hp",
                    "url": "https://pokeapi.co/api/v2/stat/1/"
                ]
            ],
            [
                "base_stat": 49,
                "effort": 0,
                "stat": [
                    "name": "attack",
                    "url": "https://pokeapi.co/api/v2/stat/2/"
                ]
            ],
            [
                "base_stat": 49,
                "effort": 0,
                "stat": [
                    "name": "defense",
                    "url": "https://pokeapi.co/api/v2/stat/3/"
                ]
            ],
            [
                "base_stat": 65,
                "effort": 1,
                "stat": [
                    "name": "special-attack",
                    "url": "https://pokeapi.co/api/v2/stat/4/"
                ]
            ],
            [
                "base_stat": 65,
                "effort": 0,
                "stat": [
                    "name": "special-defense",
                    "url": "https://pokeapi.co/api/v2/stat/5/"
                ]
            ],
            [
                "base_stat": 45,
                "effort": 0,
                "stat": [
                    "name": "speed",
                    "url": "https://pokeapi.co/api/v2/stat/6/"
                ]
            ]
        ]
        
        let species = [
            "species": [
                "name": "bulbasaur",
                "url": "https://pokeapi.co/api/v2/pokemon-species/1/"
            ]
        ]
        var json = [String: Any]()
        json["id"] = 1
        json["name"] = "bulbasaur"
        json["types"] = types
        json["sprites"] = ["front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"]
        json["stats"] = statsJSON
        json["species"] = species
        return (detail, json)
    }

    private func expectPokemonDetailLoad(_ sut: RemotePokemonLoader, toCompleteWith result: LoaderResult<PokemonDetail>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults: [LoaderResult<PokemonDetail>] = []
        
        sut.loadPokemonDetail(url: anyURL()) { capturedResults.append($0) }

        action()

        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    // MARK: - Species Helper
    
    private func makePokemonSpecies() -> (species: PokemonSpecies, json: [String: Any]) {
        let pokemonSpecies = PokemonSpecies(id: 1, description: "", evolutionChainURL: URL(string: "https://pokeapi.co/api/v2/evolution-chain/1")!)
        var json = [String: Any]()
        json["id"] = pokemonSpecies.id
        json["description"] = pokemonSpecies.description
        json["evolution_chain"] = pokemonSpecies.evolutionChainURL.absoluteString
        
        return (pokemonSpecies, json)
    }
    
    private func expectPokemonSpeciesLoad(_ sut: RemotePokemonLoader, toCompleteWith result: LoaderResult<PokemonSpecies>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults: [LoaderResult<PokemonSpecies>] = []
        
        sut.loadPokemonSpecies(url: anyURL()) { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func anyURL() -> URL {
        URL(string: "any-url.com")!
    }
}
