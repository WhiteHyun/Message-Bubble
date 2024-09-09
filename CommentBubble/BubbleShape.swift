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
    Path { path in

      path.move(to: .init(x: rect.minX + cornerRadius, y: rect.minY))

      addTopRightEdge(to: &path, in: rect)
      addBottomRightEdge(to: &path, in: rect)
      addBottomLeftEdge(to: &path, in: rect)
      addTopLeftEdge(to: &path, in: rect)
    }
  }

  private func addTopRightEdge(to path: inout Path, in rect: CGRect) {
    path.addLine(to: .init(x: rect.maxX - cornerRadius, y: rect.minY))
    path.addQuadCurve(
      to: .init(x: rect.maxX, y: rect.minY + cornerRadius),
      control: .init(x: rect.maxX, y: rect.minY)
    )
  }

  private func addBottomRightEdge(to path: inout Path, in rect: CGRect) {
    // make tail
    if tailPosition == .right {
      path.addLine(to: .init(x: rect.maxX, y: rect.maxY - tailCurveControlOffset))
      addRightTail(to: &path, in: rect)
    } else {
      // just make edge
      path.addLine(to: .init(x: rect.maxX, y: rect.maxY - cornerRadius))
      path.addQuadCurve(
        to: .init(x: rect.maxX - cornerRadius, y: rect.maxY),
        control: .init(x: rect.maxX, y: rect.maxY)
      )
    }
  }

  private func addRightTail(to path: inout Path, in rect: CGRect) {
    path.addQuadCurve(
      to: .init(x: rect.maxX + tailWidth, y: rect.maxY),
      control: .init(x: rect.maxX, y: rect.maxY)
    )

    path.addQuadCurve(
      to: .init(x: rect.maxX - cornerRadius / 3, y: rect.maxY - tailHeight),
      control: .init(x: rect.maxX - cornerRadius / 3, y: rect.maxY)
    )

    path.addQuadCurve(
      to: .init(x: rect.maxX - cornerRadius - tailWidth, y: rect.maxY),
      control: .init(x: rect.maxX - cornerRadius / 3, y: rect.maxY)
    )
  }

  private func addBottomLeftEdge(to path: inout Path, in rect: CGRect) {
    // make tail
    if tailPosition == .left {
      path.addLine(to: .init(x: rect.minX + cornerRadius + tailWidth, y: rect.maxY))
      addLeftTail(to: &path, in: rect)
    } else {
      // just make edge
      path.addLine(to: .init(x: rect.minX + cornerRadius, y: rect.maxY))
      path.addQuadCurve(
        to: .init(x: rect.minX, y: rect.maxY - cornerRadius),
        control: .init(x: rect.minX, y: rect.maxY)
      )
    }
  }

  private func addLeftTail(to path: inout Path, in rect: CGRect) {
    path.addQuadCurve(
      to: .init(x: rect.minX + cornerRadius / 3, y: rect.maxY - tailHeight),
      control: .init(x: rect.minX + cornerRadius / 3, y: rect.maxY)
    )

    path.addQuadCurve(
      to: .init(x: rect.minX - tailWidth, y: rect.maxY),
      control: .init(x: rect.minX + cornerRadius / 3, y: rect.maxY)
    )

    path.addQuadCurve(
      to: .init(x: rect.minX, y: rect.maxY - tailCurveControlOffset),
      control: .init(x: rect.minX, y: rect.maxY)
    )
  }

  private func addTopLeftEdge(to path: inout Path, in rect: CGRect) {
    path.addLine(to: .init(x: rect.minX, y: rect.minY + cornerRadius))
    path.addQuadCurve(
      to: .init(x: rect.origin.x + cornerRadius, y: rect.origin.y),
      control: rect.origin
    )
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
