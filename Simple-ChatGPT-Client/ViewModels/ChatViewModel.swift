//
//  ChatViewModel.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/08.
//

import Foundation
import OpenAISwift
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var loading = false
    @Published var errorMessage: String?
    var targetId: Int?
    
    @MainActor
    func onSubmit(text: String) {
        guard !text.isEmpty else { return }
        print(text)
        messages.append(ChatMessage(role: .user, content: text))
        Task {
            loading = true
            errorMessage = nil
            do {
                let res = try await OpenAIAPIClient.shared.callChatAPI(messages: messages)
                if let assistantRes = res.choices?.first?.message.content {
                    messages.append(ChatMessage(role: .assistant, content: assistantRes))
                }
                // 初めて保存したときに targetId が確定する
                targetId = try await ChatHistoryStore.shared.save(messages: messages, targetId: targetId)
                loading = false
            } catch {
                errorMessage = error.localizedDescription
                loading = false
            }
        }
    }
    
    @MainActor
    func setup(by id: Int) {
        Task {
            do {
                targetId = id
                messages = try await ChatHistoryStore.shared.loadMessages(by: id)
            } catch {
                errorMessage = "会話の読み込みに失敗しました。"
            }
        }
    }
    @MainActor
    func buildNew() {
        targetId = nil
        messages = []
    }
}
