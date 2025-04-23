//
//  ArticlesRepositoryFactory.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 23/4/25.
//

class ArticlesRepositoryFactory {
    private enum Constant {
        static let baseURLKey = "articles_url"
    }
    private var logger: Logger?
    init(logger: Logger? = nil) {
        self.logger = logger
    }
    
    func create() -> ArticlesListRepository {
        var client: RESTAPIFetchable = APIClient()
        if let logger {
            client = LoggingAPIClient(decorated: client, logger: logger)
        }
        let baseURL = getBaseURL()
        let mapper = APIArticleMapper()
        let result = DefaultArticlesListRepository(apiClient: client, baseURL: baseURL, articleMapper: mapper)
        return result
    }
    
    private func getBaseURL() -> String {
        let settingsRetriever = SettingsRetrieverFactory().create()
        let settings = settingsRetriever.retrieve()
        guard let baseURL = settings[Constant.baseURLKey] else {
            fatalError("This key MUST exist.")
        }
        return baseURL
    }
}
