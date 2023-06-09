//
//  ChatView.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/08.
//

import SwiftUI
import Combine
import OpenAISwift
import MarkdownUI
import AppKit

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var text = ""

    var body: some View {
        VStack {
            ScrollViewReader { reader in
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
                                VStack {
                                    Markdown {
                                        viewModel.messages[index].content
                                    }
                                    .textSelection(.enabled)
                                    .markdownTextStyle(\.code) {
                                        FontFamilyVariant(.monospaced)
                                        FontSize(.em(1))
                                        ForegroundColor(.purple)
                                        BackgroundColor(.purple.opacity(0.05))
                                    }
                                    .markdownBlockStyle(\.codeBlock) { configuration in
                                        configuration.label
                                            .padding(8)
                                            .markdownTextStyle {
                                                FontFamilyVariant(.monospaced)
                                                FontSize(.em(1))
                                            }
                                            .foregroundColor(.white)
                                            .background(.black.opacity(0.5))
                                            .padding(.vertical, 12)
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(viewModel.messages[index].role == .assistant ? .black.opacity(0.25) : .blue.opacity(0.5))
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
                        ProgressView("thinking...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.vertical, 16)
                    }
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .background(.white)
                    }
                    Text("")
                        .padding(0)
                        .id("bottomView")// Bottom スクロール用
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation (.default){
                        reader.scrollTo("bottomView")
                    }
                }
            }
            Spacer()
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    TextEditor(text: $text)
                        .padding(.top, 12)
                        .padding(.bottom, 4)
                        .padding(.horizontal, 8)
                    Text("send with command + return")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom, 4)
                        .padding(.horizontal, 10)
                }
                .font(.system(size: 14))
                .background(.gray.opacity(0.2))
                .cornerRadius(8)
                .lineSpacing(4)
                .frame(height: 180)
                .frame(minHeight: 180)
                .padding(5)
                .shadow(radius: 5)
                Button(action: {
                    viewModel.onSubmit(text: text)
                    text = ""
                }) {
                    Text("Send")
                        .font(.title3)
                        .fontWeight(.regular)
                        .frame(width: 60, height: 60)
                        .foregroundColor(viewModel.loading || text.isEmpty ? .gray : .white)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 4)
                }
                .keyboardShortcut(.return, modifiers: [.command])
                .disabled(viewModel.loading || text.isEmpty)
            }
            .frame(minHeight: 180)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(viewModel: ChatViewModel())
    }
}

