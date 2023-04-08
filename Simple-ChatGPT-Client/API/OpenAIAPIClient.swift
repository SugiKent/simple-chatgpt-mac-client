//
//  OpenAIAPIClient.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/08.
//

import Foundation
import OpenAISwift

final class OpenAIAPIClient: ObservableObject {
    private init() {
        if let apikey = UserDefaults.standard.string(forKey: "apikey") {
            apiKey = apikey
        }
        if let temperature = UserDefaults.standard.string(forKey: "temperature") {
            self.temperature = temperature
        }
    }
    public static let shared = OpenAIAPIClient()
    var apiKey = ""
    var temperature = "1"
    
    func saveSetting(apiKey: String, temperature: String) {
        self.apiKey = apiKey
        self.temperature = temperature
        
        UserDefaults.standard.set(apiKey, forKey: "apikey")
        UserDefaults.standard.set(temperature, forKey: "temperature")
    }

    func callChatAPI(messages: [ChatMessage]) async throws -> OpenAI<MessageResult> {
        let openAI = OpenAISwift(authToken: apiKey)
        let res = try await openAI.sendChat(
            with: messages,
            model: .chat(.chatgpt),
            temperature: Double(temperature)
        )
        return res
    }
}
