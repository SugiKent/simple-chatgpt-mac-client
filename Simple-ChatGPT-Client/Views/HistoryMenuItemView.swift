//
//  HistoryMenuItemView.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/08.
//

import SwiftUI

struct HistoryMenuItemView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title3)
            Text(subtitle)
                .font(.caption)
        }
        .padding()
    }
}

struct HistoryMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryMenuItemView(title: "これはタイトルです", subtitle: "これはサブタイトルです。どんなに長くてもtrimされてほしいと思っています。")
    }
}
