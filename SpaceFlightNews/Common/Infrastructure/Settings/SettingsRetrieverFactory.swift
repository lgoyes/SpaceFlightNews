//
//  SettingsRetrieverFactory.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

class SettingsRetrieverFactory {
    func create() -> SettingsRetrieverProtocol {
        let plistReader = PlistReader()
        let result = SettingsRetriever(plistReader: plistReader)
        return result
    }
}
