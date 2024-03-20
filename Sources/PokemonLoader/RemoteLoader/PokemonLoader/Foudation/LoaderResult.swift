//
//  LoaderResult.swift
//  
//
//  Created by 王富生 on 2024/3/17.
//

import Foundation

public enum LoaderResult<T: Equatable>: Equatable {
    public static func ==(lhs: LoaderResult<T>, rhs: LoaderResult<T>) -> Bool {
        switch (lhs, rhs) {
        case let (.success(value1), .success(value2)):
            return value1 == value2
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }
    
    case success(T)
    case failure(Error)
}

public enum LoaderError: Swift.Error {
    case connectivity
    case invalidData
}
