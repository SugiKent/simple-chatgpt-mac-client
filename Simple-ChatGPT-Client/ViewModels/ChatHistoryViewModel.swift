//
//  ChatHistoryViewModel.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/08.
//

import Foundation
import OpenAISwift

class ChatHistoryViewModel: ObservableObject {
    @Published var history: [Int: [ChatMessage]] = [:]
    @Published var keys: [Int] = []
    @Published var values: [[ChatMessage]] = []
    
    @MainActor
    func loadHistory() {
        Task {
            do {
                history = try await ChatHistoryStore.load()
                history = mockChatHistory
                keys = history.map { $0.key }
                values = keys.compactMap { history[$0] }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var mockChatHistory: [Int: [ChatMessage]] {
        [
            0: [
                ChatMessage(role: .user, content: "これは最初の質問です。"),
                ChatMessage(role: .assistant, content: "これは最初の回答分です。どれだけ長いかはまだわからない。"),
            ],
            1: [
                ChatMessage(role: .user, content: "これは二個目の質問です。"),
                ChatMessage(role: .assistant, content: "これは二個目の回答分です。どれだけ長いかはまだわからない。"),
            ],
            2: [
                ChatMessage(role: .user, content: "これは3個目の質問です。"),
                ChatMessage(role: .assistant, content: "これは3個目の回答分です。どれだけ長いかはまだわからない。"),
            ],
            3: [
                ChatMessage(role: .user, content: "This is th forth question."),
                ChatMessage(role: .assistant, content: "This is the forth answer. We do not know how long it is."),
            ],
            4: [
                ChatMessage(role: .user, content: "これは最初の質問です。質問はまだ返ってきてません。"),
            ],
            5: [],
        ]
    }
}
