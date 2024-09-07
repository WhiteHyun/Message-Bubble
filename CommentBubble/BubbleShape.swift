//
//  BubbleShape.swift
//  CommentBubble
//
//  Created by Hyun on 9/7/24.
//

import SwiftUI

struct BubbleShape: Shape {
  enum Position {
    case left
    case right
    case regular
  }

  private let tailPosition: Position

  init(tailPosition: Position) {
    self.tailPosition = tailPosition
  }

  func path(in rect: CGRect) -> Path {
    var path = Path()
    let gap: CGFloat = 16
    let tailWidth: CGFloat = 4
    let tailHeight: CGFloat = 4

    path.move(to: .init(x: rect.origin.x + gap, y: rect.origin.y))

    // top edge
    path.addLine(to: .init(x: rect.maxX - gap, y: rect.minY))
    // top right corner
    path.addQuadCurve(
      to: .init(x: rect.maxX, y: rect.minY + gap),
      control: .init(x: rect.maxX, y: rect.minY)
    )

    if tailPosition == .right {
      // Right edge with tail

      path.addLine(to: .init(x: rect.maxX, y: rect.maxY - 8))

      // right tail
      path.addQuadCurve(
        to: .init(x: rect.maxX + tailWidth, y: rect.maxY),
        control: .init(x: rect.maxX, y: rect.maxY)
      )

      // inner
      path.addQuadCurve(
        to: .init(x: rect.maxX - gap / 2, y: rect.maxY - tailHeight),
        control: .init(x: rect.maxX - gap / 2, y: rect.maxY)
      )

      // outer
      path.addQuadCurve(
        to: .init(x: rect.maxX - gap - tailWidth, y: rect.maxY),
        control: .init(x: rect.maxX - gap / 2, y: rect.maxY)
      )
    } else {
      // Right edge (straight)
      path.addLine(to: .init(x: rect.maxX, y: rect.maxY - gap))
      path.addQuadCurve(
        to: .init(x: rect.maxX - gap, y: rect.maxY),
        control: .init(x: rect.maxX, y: rect.maxY)
      )
    }

    if tailPosition == .left {
      path.addLine(to: .init(x: rect.minX + gap + tailWidth, y: rect.maxY))
      // inner 골짜기
      path.addQuadCurve(
        to: .init(x: rect.minX + gap / 2, y: rect.maxY - tailHeight),
        control: .init(x: rect.minX + gap / 2, y: rect.maxY)
      )

      // left tail
      path.addQuadCurve(
        to: .init(x: rect.minX - tailWidth, y: rect.maxY),
        control: .init(x: rect.minX + gap / 2, y: rect.maxY)
      )

      path.addQuadCurve(
        to: .init(x: rect.minX, y: rect.maxY - 8),
        control: .init(x: rect.minX, y: rect.maxY)
      )

    } else {
      path.addLine(to: .init(x: rect.minX + gap, y: rect.maxY))

      // bottom left corner
      path.addQuadCurve(
        to: .init(x: rect.minX, y: rect.maxY - gap),
        control: .init(x: rect.minX, y: rect.maxY)
      )
    }

    path.addLine(to: .init(x: rect.minX, y: rect.minY + gap))

    path.addQuadCurve(
      to: .init(x: rect.origin.x + gap, y: rect.origin.y),
      control: rect.origin
    )

    return path
  }
}

#Preview {
  VStack {
    Text("Hello, World!")
      .padding(.vertical, 6)
      .padding(.horizontal, 8)
      .overlay {
        BubbleShape(tailPosition: .left)
          .stroke(.yellow, lineWidth: 2)
      }

    HStack {
      Spacer()
      Text("Hey Sam, how's your day going so far?")
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .foregroundStyle(.white)
        .background {
          BubbleShape(tailPosition: .right)
            .fill(.blue)
        }
    }
    HStack {
      Text("Pretty good, thanks! Just finished a big project at work. How about you?")
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background {
          BubbleShape(tailPosition: .left)
            .fill(.windowBackground)
        }
      Spacer()
    }
  }
  .padding()
  .background(.background)
}
