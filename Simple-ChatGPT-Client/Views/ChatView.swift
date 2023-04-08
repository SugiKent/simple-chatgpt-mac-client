//
//  ChatView.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/08.
//

import SwiftUI
import Combine
import OpenAISwift

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
//    @EnvironmentObject var chatHistoryEnv: ChatHistoryEnvironment
    @State private var text = ""
//    @ObservedObject var historyViewModel: ChatHistoryViewModel
//    let loadHistory: (() -> Void)?
    
//    init(loadHistory: ( () -> Void)? = nil) {
//        self.loadHistory = loadHistory
//    }
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        print("xxx [ChatView init] called")
    }
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            ScrollView {
                if viewModel.messages.count == 0 {
                    Text("Empty")
                        .font(.title3)
                } else {
                    ForEach(0..<viewModel.messages.count, id: \.self) { index in
                        HStack {
                            if viewModel.messages[index].role == .user {
                                Spacer()
                            }
                            Text(viewModel.messages[index].content)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(viewModel.messages[index].role == .assistant ? .black : .blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            if viewModel.messages[index].role == .assistant {
                                Spacer()
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 5)
                    }
                }
                if viewModel.loading {
                    ProgressView("かんがえちゅう・・・", value: 0.5)
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.vertical, 16)
                }
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .background(.white)
                }
            }
            Spacer()
            HStack(alignment: .center) {
                TextEditor(text: $text)
                    .font(.body)
                    .frame(height: 100)
                    .lineLimit(nil)
                    .lineSpacing(4)
                    .disabled(viewModel.loading)
                    .cornerRadius(8)
                Button(action: {
                    viewModel.onSubmit(text: text)
                    text = ""
//                    loadHistory?()
                }) {
                    Text("送信")
                        .font(.title3)
                        .frame(width: 60, height: 60)
                        .fontWeight(.semibold)
                        .foregroundColor(viewModel.loading || text.isEmpty ? .gray : .white)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 4)
                }
                .keyboardShortcut(KeyEquivalent.return, modifiers: [.command])
                .disabled(viewModel.loading || text.isEmpty)
                .background(viewModel.loading || text.isEmpty ? .clear : .blue)
            }
            .frame(minHeight: 100)
        }
//        .onReceive(viewModel.$messages, perform: { value in
//            print(value)
        // 無限ループしちゃう
//            historyViewModel.loadHistory()
//        })
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
//        ChatView(loadHistory: {})
        ChatView(viewModel: ChatViewModel())
    }
}

