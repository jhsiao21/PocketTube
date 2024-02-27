//
//  APIError.swift
//  Netflix Clone
//
//  Created by LoganMacMini on 2024/2/12.
//

import Foundation

enum APIError: Error, LocalizedError {
    case failedToGetData
    case invalidURL
    case httpError(Error)
    
    var errorDescription: String {
        switch self {
        case .failedToGetData:
            return "Data doesn't exist"
        case .invalidURL:
            return "URL error"
        case .httpError(let error):
            return error.localizedDescription
        }
    }

    var message: String {
        return localizedDescription
    }
}
