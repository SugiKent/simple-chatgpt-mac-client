//
//  ContentView.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/08.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ChatHistoryViewModel()
    
    var body: some View {
        NavigationSplitView() {
            ScrollView {
                List {
                    ForEach(viewModel.keys.indices, id: \.self) { keyIndex in
                        HistoryMenuItemView(title: viewModel.values[keyIndex].first?.content ?? "タイトルなし", subtitle: viewModel.values[keyIndex].count > 1 ? viewModel.values[keyIndex][1].content : "")
                    }
                }
            }
        } detail: {
            ChatView()
                .padding()
        }
        .onAppear {
            viewModel.loadHistory()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
