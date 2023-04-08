//
//  ChatView.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/08.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ChatViewModel()
    @State private var text = ""
    
    var body: some View {
        VStack {
            ScrollView {
                if viewModel.messages.count == 0 {
                    Text("Empty")
                        .font(.title3)
                }
                ForEach(0..<(viewModel.messages.count + 1), id: \.self) { index in
                    if let message = viewModel.messages[index] {
                        HStack {
                            if message.role == .user {
                                Spacer()
                            }
                            Text(message.content)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(message.role == .assistant ? .gray : .blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            if message.role == .assistant {
                                Spacer()
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 5)
                    } else {
                        Text("Empty")
                            .font(.title3)
                    }
                }
                if viewModel.loading {
                    ProgressView("かんがえちゅう・・・", value: 0.5)
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.vertical, 16)
                }
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.pink)
                        .background(.red)
                }
            }
            Spacer()
            HStack {
                TextField("なにかお困りですか", text: $text)
                    .disabled(viewModel.loading)
                Button(action: {
                    viewModel.onSubmit(text: text)
                    text = ""
                }) {
                    Text("送信")
                        .tracking(2)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.black, lineWidth: 3)
                        )
                }
                .disabled(viewModel.loading)
                .background(.white)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

