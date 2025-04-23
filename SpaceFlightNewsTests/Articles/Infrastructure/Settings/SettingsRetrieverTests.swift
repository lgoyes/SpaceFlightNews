//
//  SettingsRetrieverTests.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

import Foundation
import Testing
@testable import SpaceFlightNews

fileprivate final class PlistReaderStub: PlistReaderProtocol {
    var result: [String: Any]?
    func loadPlist(filename: String, bundle: Bundle) -> [String: Any]? {
        result
    }
}

struct SettingsRetrieverUnitTests {

    private let readerStub: PlistReaderStub
    private let sut: SettingsRetriever
    
    init() {
        self.readerStub = PlistReaderStub()
        self.sut = SettingsRetriever(plistReader: readerStub)
    }
    
    @Test("GIVEN some valid data WHEN retrieve THEN it should return some valid data")
    func loadContent() {
        GIVEN_someValidData()
        let result = WHEN_retrieve()
        THEN_itShouldReturnSomeValidData(result)
    }
    
    func GIVEN_someValidData() {
        readerStub.result = ["someKey": "someValue"]
    }
    
    func WHEN_retrieve() -> [String: String] {
        sut.retrieve()
    }
    
    func THEN_itShouldReturnSomeValidData(_ data: [String: String]) {
        #expect(data["someKey"] == "someValue")
    }
}

struct SettingsRetrieverIntegrationTests {
    private let sut = SettingsRetrieverFactory().create()
    
    @Test("GIVEN Settings file exists in main bundle WHEN retrieve THEN it should return the settings")
    func loadContent() {
        let result = sut.retrieve()
        #expect(result["articles_url"]!.starts(with: "https://api.spaceflightnewsapi"))
    }
}
