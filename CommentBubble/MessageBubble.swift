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
  let id: UUID = .init()
  let content: String
  let type: MessageType
}

// MARK: - MessageBubble

struct MessageBubble: View {
  let message: Message
  let tail: TailPosition

  init(message: Message, tail: TailPosition = .undefined) {
    self.message = message
    self.tail = tail
  }

  var body: some View {
    Text(message.content)
      .lineLimit(nil)
      .padding(.vertical, 6)
      .padding(.horizontal, 10)
      .frame(minWidth: 34)
      .foregroundStyle(message.type == .sent ? .white : .primary)
      .background {
        BubbleShape(tailPosition: tailPosition)
          .fill(message.type == .sent ? .blue : Color(.windowBackgroundColor))
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
      MessageBubble(message: .init(content: ".", type: .sent))
    }
  }
  .padding()
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.background)
}
