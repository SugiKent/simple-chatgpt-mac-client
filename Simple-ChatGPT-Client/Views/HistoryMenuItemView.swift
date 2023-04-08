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
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .padding(.bottom, 2)
                .font(.body)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}

struct HistoryMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryMenuItemView(title: "これはタイトルです", subtitle: "これはサブタイトルです。どんなに長くてもtrimされてほしいと思っています。")
    }
}
