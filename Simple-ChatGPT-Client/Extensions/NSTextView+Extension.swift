//
//  NSTextView+Extension.swift
//  Simple-ChatGPT-Client
//
//  Created by Kento Sugita on 2023/04/09.
//

import Foundation
import AppKit

extension NSTextView {
  open override var frame: CGRect {
    didSet {
      backgroundColor = .clear
      drawsBackground = true
    }
  }
}
