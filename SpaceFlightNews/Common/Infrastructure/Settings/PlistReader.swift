//
//  PlistReader.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Foundation

protocol PlistReaderProtocol {
    func loadPlist(filename: String, bundle: Bundle) -> [String: Any]?
}

class PlistReader: PlistReaderProtocol {
    func loadPlist(filename: String, bundle: Bundle) -> [String: Any]? {
        guard let url = bundle.url(forResource: filename, withExtension: "plist"),
              let dictionary = NSDictionary(contentsOf: url) as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}
