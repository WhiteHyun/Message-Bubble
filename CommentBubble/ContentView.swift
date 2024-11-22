//
//  ContentView.swift
//  CommentBubble
//
//  Created by Hyun on 9/6/24.
//

import SwiftUI

struct ContentView: View {
  @State private var messages: [Message] = []
  @State private var typingText: String = ""
  @State private var isTextEmpty = true

  @Namespace private var chattingMovingNameSpace

  var body: some View {
    GeometryReader { proxy in
      VStack(alignment: .leading, spacing: 2) {
        chattingsView(messages)
          .frame(maxWidth: proxy.size.width / 2, alignment: .leading)

        showingChatBubble
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
      MessageBubble(message: message, tail: messages.last?.id == message.id ? .left : .none)
        .transition(
          .asymmetric(
            insertion: .move(edge: .bottom),
            removal: .opacity
          )
        )
    }
  }

  private var showingChatBubble: some View {
    MessageBubble(message: .init(content: typingText, type: .sent), tail: .left)
      .opacity(isTextEmpty ? 0 : 1)
  }

  private var chattingTextField: some View {
    TextField("", text: $typingText)
      .textFieldStyle(.roundedBorder)
      .onChange(of: typingText) { _, newValue in
        if newValue.isEmpty, !isTextEmpty {
          // 텍스트를 모두 지웠을 때 (fade out)
          withAnimation(.easeOut(duration: 0.3)) {
            isTextEmpty = true
          }
        } else if !newValue.isEmpty, isTextEmpty {
          // 텍스트를 입력하기 시작했을 때 (fade in)
          withAnimation(.easeIn(duration: 0.3)) {
            isTextEmpty = false
          }
        }
      }
      .onSubmit {
        guard !typingText.isEmpty else { return }
        Task {
          let message = Message(content: typingText, type: .sent)
          typingText = ""
          isTextEmpty = true
          withAnimation {
            messages.append(message)
          }

          try? await Task.sleep(for: .seconds(60))
          withAnimation {
            messages.removeAll { $0.id == message.id }
          }
        }
      }
  }
}

#Preview {
  ContentView()
}
