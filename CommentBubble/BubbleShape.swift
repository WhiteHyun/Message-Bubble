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
    case none
  }

  private let tailPosition: Position

  private let cornerRadius: CGFloat = 16
  private let tailWidth: CGFloat = 5
  private let tailHeight: CGFloat = 4
  private let tailCurveControlOffset: CGFloat = 8

  init(tailPosition: Position) {
    self.tailPosition = tailPosition
  }

  func path(in rect: CGRect) -> Path {
    Path { path in
      let safeCornerRadius = min(cornerRadius, min(rect.width, rect.height) / 2)

      path.move(to: .init(x: rect.minX + safeCornerRadius, y: rect.minY))

      addTopRightEdge(to: &path, in: rect, safeCornerRadius: safeCornerRadius)
      addBottomRightEdge(to: &path, in: rect, safeCornerRadius: safeCornerRadius)
      addBottomLeftEdge(to: &path, in: rect, safeCornerRadius: safeCornerRadius)
      addTopLeftEdge(to: &path, in: rect, safeCornerRadius: safeCornerRadius)
    }
  }

  private func addTopRightEdge(to path: inout Path, in rect: CGRect, safeCornerRadius: CGFloat) {
    path.addLine(to: .init(x: rect.maxX - safeCornerRadius, y: rect.minY))
    path.addQuadCurve(
      to: .init(x: rect.maxX, y: rect.minY + safeCornerRadius),
      control: .init(x: rect.maxX, y: rect.minY)
    )
  }

  private func addBottomRightEdge(to path: inout Path, in rect: CGRect, safeCornerRadius: CGFloat) {
    // make tail
    if tailPosition == .right {
      path.addLine(to: .init(x: rect.maxX, y: rect.maxY - tailCurveControlOffset))
      addRightTail(to: &path, in: rect, safeCornerRadius: safeCornerRadius)
    } else {
      // just make edge
      path.addLine(to: .init(x: rect.maxX, y: rect.maxY - safeCornerRadius))
      path.addQuadCurve(
        to: .init(x: rect.maxX - safeCornerRadius, y: rect.maxY),
        control: .init(x: rect.maxX, y: rect.maxY)
      )
    }
  }

  private func addRightTail(to path: inout Path, in rect: CGRect, safeCornerRadius: CGFloat) {
    path.addQuadCurve(
      to: .init(x: rect.maxX + tailWidth, y: rect.maxY),
      control: .init(x: rect.maxX, y: rect.maxY)
    )

    path.addQuadCurve(
      to: .init(x: rect.maxX - safeCornerRadius / 3, y: rect.maxY - tailHeight),
      control: .init(x: rect.maxX - safeCornerRadius / 3, y: rect.maxY)
    )

    path.addQuadCurve(
      to: .init(x: rect.maxX - safeCornerRadius - tailWidth, y: rect.maxY),
      control: .init(x: rect.maxX - safeCornerRadius / 3, y: rect.maxY)
    )
  }

  private func addBottomLeftEdge(to path: inout Path, in rect: CGRect, safeCornerRadius: CGFloat) {
    // make tail
    if tailPosition == .left {
      path.addLine(to: .init(x: rect.minX + safeCornerRadius + tailWidth, y: rect.maxY))
      addLeftTail(to: &path, in: rect, safeCornerRadius: safeCornerRadius)
    } else {
      // just make edge
      path.addLine(to: .init(x: rect.minX + safeCornerRadius, y: rect.maxY))
      path.addQuadCurve(
        to: .init(x: rect.minX, y: rect.maxY - safeCornerRadius),
        control: .init(x: rect.minX, y: rect.maxY)
      )
    }
  }

  private func addLeftTail(to path: inout Path, in rect: CGRect, safeCornerRadius: CGFloat) {
    path.addQuadCurve(
      to: .init(x: rect.minX + safeCornerRadius / 3, y: rect.maxY - tailHeight),
      control: .init(x: rect.minX + safeCornerRadius / 3, y: rect.maxY)
    )

    path.addQuadCurve(
      to: .init(x: rect.minX - tailWidth, y: rect.maxY),
      control: .init(x: rect.minX + safeCornerRadius / 3, y: rect.maxY)
    )

    path.addQuadCurve(
      to: .init(x: rect.minX, y: rect.maxY - tailCurveControlOffset),
      control: .init(x: rect.minX, y: rect.maxY)
    )
  }

  private func addTopLeftEdge(to path: inout Path, in rect: CGRect, safeCornerRadius: CGFloat) {
    path.addLine(to: .init(x: rect.minX, y: rect.minY + safeCornerRadius))
    path.addQuadCurve(
      to: .init(x: rect.origin.x + safeCornerRadius, y: rect.origin.y),
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
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.background)
}
