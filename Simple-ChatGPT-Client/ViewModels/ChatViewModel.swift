//
//  ChatViewModel.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/08.
//

import Foundation
import OpenAISwift

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var loading = false
    @Published var errorMessage: String?
    
    @MainActor
    func onSubmit(text: String) {
        print(text)
        messages.append(ChatMessage(role: .user, content: text))
        Task {
            loading = true
            do {
                let res = try await OpenAIAPIClient.shared.callChatAPI(messages: messages)
                if let assistantRes = res.choices?.first?.message.content {
                    messages.append(ChatMessage(role: .assistant, content: assistantRes))
                }
                loading = false
            } catch {
                errorMessage = error.localizedDescription
                loading = false
            }
        }
    }
}
