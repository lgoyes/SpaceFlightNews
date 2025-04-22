//
//  Logger.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

enum LogLevel {
    case info, warning, error
}

protocol Logger {
    func log(_ message: String, level: LogLevel)
}
