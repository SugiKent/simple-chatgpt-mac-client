import Foundation
import SwiftUI
import OpenAISwift

class ChatHistoryStore {
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("chat_history.data")
    }
    
    static func load() async throws -> [Int: [ChatMessage]] {
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
    
    static func save(messages: [Int: ChatMessage], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(messages)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(messages.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
