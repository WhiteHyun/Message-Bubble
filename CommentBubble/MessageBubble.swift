//
//  MessageBubble.swift
//  CommentBubble
//
//  Created by Hyun on 9/9/24.
//

import SwiftUI

// MARK: - MessageType

/// 메시지 타입을 정의하는 열거형
enum MessageType {
  case sent
  case received
}

// MARK: - TailPosition

enum TailPosition {
  case left
  case right
  case none
  case undefined
}

// MARK: - Message

struct Message: Identifiable, Hashable {
  let id: UUID
  var content: String
  let type: MessageType

  init(id: UUID = .init(), content: String, type: MessageType) {
    self.id = id
    self.content = content
    self.type = type
  }
}

// MARK: - MessageBubble

struct MessageBubble: View {
  @State private var textHeight: CGFloat = 0
  let message: Message
  let tail: TailPosition

  init(message: Message, tail: TailPosition = .undefined) {
    self.message = message
    self.tail = tail
  }

  var body: some View {
    ZStack {
      Text(message.content)
        .lineLimit(nil)
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .frame(minWidth: 34, minHeight: textHeight)
        .foregroundStyle(message.type == .sent ? .white : .primary)
        .background {
          BubbleShape(tailPosition: tailPosition)
            .fill(message.type == .sent ? .blue : Color(.windowBackgroundColor))
        }
      // 높이를 측정하기 위한 Text
      Text(".")
        .lineLimit(nil)
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
          // GeometryReader를 사용하여 크기 측정
          GeometryReader { geometry in
            Color.clear
              .onAppear {
              textHeight = geometry.size.height
            }
          }
        )
        .hidden() // 숨김 처리
    }
  }

  private var tailPosition: BubbleShape.Position {
    switch tail {
    case .left:
      .left
    case .right:
      .right
    case .none:
      .none
    case .undefined:
      message.type == .sent ? .right : .left
    }
  }
}

#Preview {
  @Previewable @State var flicking: String = ""
  VStack {
    HStack {
      Spacer()
      MessageBubble(message: .init(content: "Hey Sam, how's your day going so far?", type: .sent))
    }
    HStack {
      MessageBubble(message: .init(content: "Hey Sam, how's your day going so far?", type: .received))
      Spacer()
    }

    HStack {
      Spacer()
      MessageBubble(message: .init(content: flicking, type: .sent))
        .border(.green)
    }
  }
  .padding()
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.background)
  .onAppear {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
      flicking = flicking.isEmpty ? ".": ""
    }
  }
}
