//
//  APIClient.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import Foundation

enum RESTAPIFetchableError: Swift.Error, Equatable {
    case badURL, invalidResponse, connectionFailed, decodingFailed(Error)
    
    static func == (lhs: RESTAPIFetchableError, rhs: RESTAPIFetchableError) -> Bool {
        switch (lhs, rhs) {
        case (.badURL, .badURL),
            (.invalidResponse, .invalidResponse),
            (.connectionFailed, .connectionFailed):
            return true
        case (.decodingFailed(let lhsError), .decodingFailed(let rhsError)):
            return isSameErrorType(lhsError, rhsError)
        default:
            return false
        }
    }
    
    private static func isSameErrorType(_ lhs: Error, _ rhs: Error) -> Bool {
        let lhsNSError = lhs as NSError
        let rhsNSError = rhs as NSError
        return lhsNSError.domain == rhsNSError.domain && lhsNSError.code == rhsNSError.code
    }
}

protocol RESTAPIFetchable {
    func fetchData<T: Decodable>(from urlString: String) async throws(RESTAPIFetchableError) -> T
}

class APIClient: RESTAPIFetchable {
    private struct Constant {
        static let validStatusCodeRange: Range<Int> = 200..<300
    }
    private let decoder = JSONDecoder()
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func fetchData<T: Decodable>(from urlString: String) async throws(RESTAPIFetchableError) -> T {
        guard let url = URL(string: urlString) else {
            throw .badURL
        }
        
        let (data, response) : (Data, URLResponse)
        do {
            (data, response) = try await downloadData(from: url)
        } catch {
            debugPrint((error as! NSError).userInfo)
            throw .connectionFailed
        }
        
        guard isResponseValid(response) else {
            throw .invalidResponse
        }
        
        let result: T
        do {
            result = try decoder.decode(T.self, from: data)
        } catch {
            throw .decodingFailed(error)
        }
        
        return result
    }
    
    func downloadData(from url: URL) async throws-> (Data, URLResponse) {
        return try await session.data(from: url)
    }
    
    func isResponseValid(_ response: URLResponse) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse else {
            return false
        }
        return Constant.validStatusCodeRange.contains(httpResponse.statusCode)
    }
}
