//
//  OpenAIAPIClient.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/08.
//

import Foundation
import OpenAISwift

final class OpenAIAPIClient: ObservableObject {
    private init() {}
    public static let shared = OpenAIAPIClient()
    let openAI = OpenAISwift(authToken: "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")

    
    func callChatAPI() async throws -> OpenAI<MessageResult> {
        var chatMessages = [
            ChatMessage(role: .user, content: "あなたは誰ですか？")
        ]
        print(chatMessages)
        let res = try await openAI.sendChat(
            with: chatMessages,
            model: .chat(.chatgpt)
        )
        return res
    }
}
