import Foundation
import SwiftUI
import OpenAISwift
import Combine

class ChatHistoryStore {
    private init() {}
    public static let shared = ChatHistoryStore()
    let updateHistorySubject = PassthroughSubject<Bool, Never>()
    
    private func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("chat_history.data")
    }
    
    func load() async throws -> [Int: [ChatMessage]] {
        do {
            let fileURL = try fileURL()
            guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                return [:]
            }
            let chatHistory = try JSONDecoder().decode([Int: [ChatMessage]].self, from: file.availableData)
            return chatHistory
        } catch {
            throw error
        }
    }
    
    func loadMessages(by id: Int) async throws -> [ChatMessage] {
        let pastHistory = try await load()
        return pastHistory[id] ?? []
    }
    
    func save(messages: [ChatMessage], targetId: Int? = nil) async throws -> Int {
        var pastHistory = try await load()
        var id = targetId ?? 0
        if targetId == nil {
            pastHistory.forEach { (key: Int, _: [ChatMessage]) in
                if id <= key {
                    id = key + 1
                }
            }
        }
        pastHistory[id] = messages
        let data = try JSONEncoder().encode(pastHistory)
        let outfile = try fileURL()
        try data.write(to: outfile)
        updateHistorySubject.send(true)
        return id
    }
    
    func remove(by id: Int) async throws {
        let pastHistory = try await load()
        var newHistory: [Int: [ChatMessage]] = [:]
        pastHistory.forEach { (key: Int, value: [ChatMessage]) in
            guard key != id else { return }
            return newHistory[key] = value
        }
        let data = try JSONEncoder().encode(newHistory)
        let outfile = try fileURL()
        try data.write(to: outfile)
        updateHistorySubject.send(true)
    }
}
