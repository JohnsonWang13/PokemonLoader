//
//  File.swift
//  
//
//  Created by 王富生 on 2024/3/16.
//

import Foundation
import Network

class HTTPClientSpy: HTTPClient {
    
    private var messages: [(url: URL, completion: (Network.HTTPClientResult) -> Void)] = []
    
    var requestURLs: [URL] {
        return messages.map { $0.url }
    }
    
    func request(with apiRequest: Network.APIRequest, completion: @escaping (Network.HTTPClientResult) -> Void) {
        messages.append((apiRequest.url, completion))
    }
    
    func complete(with error: Network.HTTPClientResult, at index: Int = 0) {
        messages[index].completion(error)
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(url: requestURLs[index],
                                       statusCode: code,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        messages[index].completion(.success(data, response))
    }
}
