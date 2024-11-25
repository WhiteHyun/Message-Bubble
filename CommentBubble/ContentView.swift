//
//  ContentView.swift
//  CommentBubble
//
//  Created by Hyun on 9/6/24.
//

import SwiftUI

struct ContentView: View {
  @State private var messages: [Message] = [.init(content: "", type: .sent)]
  @State private var typingText: String = ""

  var body: some View {
    GeometryReader { proxy in
      VStack(alignment: .leading, spacing: 2) {
        chattingsView(messages)
          .frame(maxWidth: proxy.size.width / 2, alignment: .leading)

        // MARK: - User Input View

        Divider()
          .padding(.vertical)

        chattingTextField
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
      .safeAreaPadding(30)
    }
  }

  private func chattingsView(_ messages: [Message]) -> some View {
    ForEach(messages) { message in
      MessageBubble(message: message, tail: messages.last?.id == message.id || messages.suffix(2).first?.id == message.id && messages.last?.content.isEmpty == true ? .left : .none)
        .animation(.default) {
          $0.opacity(message.content.isEmpty ? 0 : 1)
        }
    }
  }

  private var chattingTextField: some View {
    TextField("", text: $typingText)
      .textFieldStyle(.roundedBorder)
      .onChange(of: typingText) { _, newValue in
        messages[messages.count - 1].content = newValue

      }
      .onSubmit {
        guard !typingText.isEmpty else { return }
        Task {
          let lastMessage = messages.last
          let message = Message(content: "", type: .sent)
          withAnimation {
          messages.append(message)
          typingText = ""
          }

          try? await Task.sleep(for: .seconds(10))
          withAnimation {
            messages.removeAll { $0.id == lastMessage?.id }
          }
        }
      }
  }
}

#Preview {
  ContentView()
}
