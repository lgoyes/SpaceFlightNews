//
//  UseCase.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

protocol Command {
    associatedtype ErrorType: Swift.Error
    func execute() async throws(ErrorType)
}

protocol Resultable {
    associatedtype Output
    associatedtype ErrorType: Swift.Error
    func getResult() throws(ErrorType) -> Output
}

protocol UseCase: Resultable, Command {
    var error: ErrorType? {get}
    var result: Output? {get}
}

extension UseCase {
    func getResult() throws(ErrorType) -> Output {
        if let error {
            throw error
        }
        if let result {
            return result
        }
        fatalError("Result not set")
    }
}
