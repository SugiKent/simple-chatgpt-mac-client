//
//  ContentView.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/08.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel = ChatHistoryViewModel()
    @ObservedObject var chatViewModel = ChatViewModel()
    @State private var cancellable: AnyCancellable?
    
    @State private var apiKeyField = OpenAIAPIClient.shared.apiKey
    @State private var temperature = OpenAIAPIClient.shared.temperature
    @State private var isShowSettingSheet = false
    
    var body: some View {
        VStack {
            NavigationSplitView() {
                List {
                    ForEach(viewModel.menuItems) { menuItem in
                        Button(action: {
                            chatViewModel.setup(by: menuItem.id)
                        }) {
                            HistoryMenuItemView(title: menuItem.title, subtitle: menuItem.subTitle)
                        }
                        .contextMenu(menuItems: {
                            Button(action: {
                                viewModel.removeHistory(by: menuItem.id)
                            }, label: {
                                Text("削除")
                            })
                        })
                        .buttonStyle(.plain)
                        .padding(.bottom, 4)
                    }
                }
                .onAppear {
                    viewModel.loadHistory()
                    cancellable = ChatHistoryStore.shared.updateHistorySubject.receive(on: DispatchQueue.main)
                        .sink { val in
                            if val {
                                viewModel.loadHistory()
                            }
                        }
                }
            } detail: {
                ChatView(viewModel: chatViewModel)
                    .padding()
            }
            .toolbar {
                ToolbarItemGroup {
                    Button(action: {
                        chatViewModel.buildNew()
                    }, label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 16, height: 16)
                    })
                    Spacer()
                    Button(action: {
                        isShowSettingSheet = true
                    }, label: {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 18, height: 18)
                    })
                    .sheet(isPresented: $isShowSettingSheet, content: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("API Key")
                                TextField("sk-****", text: $apiKeyField)
                                    .frame(width: 200)
                            }
                            HStack {
                                Text("Temperaature")
                                TextField("between 0.0 and 2.0", text: $temperature)
                                    .frame(width: 200)
                            }
                            Button(action: {
                                OpenAIAPIClient.shared.saveSetting(apiKey: apiKeyField, temperature: temperature)
                                isShowSettingSheet = false
                            }) {
                                Text("Save")
                            }
                        }
                        .padding(60)
                    })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .environmentObject(ChatHistoryEnvironment())
    }
}
