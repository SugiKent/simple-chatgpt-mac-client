//
//  ChatHistoryViewModel.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/08.
//

import Foundation
import OpenAISwift

class ChatHistoryViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    
    @MainActor
    func loadHistory() {
        Task {
            do {
                let history = try await ChatHistoryStore.shared.load()
                let keys = history.map { $0.key }.sorted { prev, next in
                    next < prev
                }
                menuItems = keys.compactMap { key in
                    guard let target = history[key], let title = target.first?.content else { return nil }
                    var second = ""
                    if target.count > 1 {
                        second = target[1].content
                    }
                    return MenuItem(id: key, title: title, subTitle: second)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    @MainActor
    func removeHistory(by id: Int) {
        Task {
            do {
                try await ChatHistoryStore.shared.remove(by: id)
            } catch {
                print(error.localizedDescription)
            }
        }

    }
}

