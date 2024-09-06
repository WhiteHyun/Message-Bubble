//
//  ContentView.swift
//  CommentBubble
//
//  Created by Hyun on 9/6/24.
//

import SwiftUI

struct ContentView: View {
  @State private var texts: [String] = []
  @State private var typingText: String = ""
  init(texts: [String] = []) {
    self._texts = State(wrappedValue: texts)
  }

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(texts, id: \.self) {
        Text($0)
      }
      TextField("", text: $typingText)
        .textFieldStyle(.squareBorder)
        .onSubmit {
          texts.append(typingText)
          typingText = ""
        }

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    .safeAreaPadding(30)
  }
}

private extension [String] {
  static var mock: Self { ["Hello, World!", "My name is SeungHyun", "It's lorem Ipsum"] }
}

#Preview {
  ContentView(texts: .mock)
}
