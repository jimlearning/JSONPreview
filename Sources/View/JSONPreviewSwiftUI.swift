//
//  JSONPreviewSwiftUI.swift
//  JSONPreview
//
//  Created by Assistant on 2024/10/7.
//  Copyright © 2024 Rakuyo. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - JSONPreviewSwiftUI

/// A SwiftUI wrapper for JSONPreview
@available(iOS 13.0, tvOS 13.0, visionOS 1.0, *)
public struct JSONPreviewSwiftUI: UIViewRepresentable {

  // MARK: - Properties

  /// The JSON string to preview
  public let json: String

  /// The initial state of the rendering result
  public let initialState: JSONSlice.State

  /// Whether automatic wrapping is enabled
  public let automaticWrapEnabled: Bool

  /// Highlight style
  public let highlightStyle: HighlightStyle

  /// Whether to hide the line number view
  public let isHiddenLineNumber: Bool

  /// Whether scrolling is enabled
  public let isScrollEnabled: Bool

  /// Whether bounces is enabled
  public let bounces: Bool

  /// Whether to show horizontal scroll indicator
  public let showsHorizontalScrollIndicator: Bool

  /// Whether to show vertical scroll indicator
  public let showsVerticalScrollIndicator: Bool

  #if !os(tvOS)
    /// Whether scrolls to top is enabled
    public let scrollsToTop: Bool
  #endif

  /// Callback when URL is clicked
  public let onURLClick: ((URL) -> Bool)?

  /// Callback when slice state changes
  public let onSliceStateChange: ((JSONSlice, JSONDecorator) -> Void)?

  // MARK: - Initializers

  /// Initialize with JSON string and default configuration
  /// - Parameter json: The JSON string to preview
  public init(json: String) {
    self.init(
      json: json,
      initialState: .default,
      automaticWrapEnabled: true,
      highlightStyle: .default,
      isHiddenLineNumber: false,
      isScrollEnabled: true,
      bounces: true,
      showsHorizontalScrollIndicator: true,
      showsVerticalScrollIndicator: true,
      onURLClick: nil,
      onSliceStateChange: nil
    )
  }

  /// Initialize with full configuration
  /// - Parameters:
  ///   - json: The JSON string to preview
  ///   - initialState: The initial state of the rendering result
  ///   - automaticWrapEnabled: Whether automatic wrapping is enabled
  ///   - highlightStyle: Highlight style
  ///   - isHiddenLineNumber: Whether to hide the line number view
  ///   - isScrollEnabled: Whether scrolling is enabled
  ///   - bounces: Whether bounces is enabled
  ///   - showsHorizontalScrollIndicator: Whether to show horizontal scroll indicator
  ///   - showsVerticalScrollIndicator: Whether to show vertical scroll indicator
  ///   - onURLClick: Callback when URL is clicked
  ///   - onSliceStateChange: Callback when slice state changes
  public init(
    json: String,
    initialState: JSONSlice.State = .default,
    automaticWrapEnabled: Bool = true,
    highlightStyle: HighlightStyle = .default,
    isHiddenLineNumber: Bool = false,
    isScrollEnabled: Bool = true,
    bounces: Bool = true,
    showsHorizontalScrollIndicator: Bool = true,
    showsVerticalScrollIndicator: Bool = true,
    onURLClick: ((URL) -> Bool)? = nil,
    onSliceStateChange: ((JSONSlice, JSONDecorator) -> Void)? = nil
  ) {
    self.json = json
    self.initialState = initialState
    self.automaticWrapEnabled = automaticWrapEnabled
    self.highlightStyle = highlightStyle
    self.isHiddenLineNumber = isHiddenLineNumber
    self.isScrollEnabled = isScrollEnabled
    self.bounces = bounces
    self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
    self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
    #if !os(tvOS)
      self.scrollsToTop = true
    #endif
    self.onURLClick = onURLClick
    self.onSliceStateChange = onSliceStateChange
  }

  #if !os(tvOS)
    /// Initialize with full configuration including scrollsToTop
    /// - Parameters:
    ///   - json: The JSON string to preview
    ///   - initialState: The initial state of the rendering result
    ///   - automaticWrapEnabled: Whether automatic wrapping is enabled
    ///   - highlightStyle: Highlight style
    ///   - isHiddenLineNumber: Whether to hide the line number view
    ///   - isScrollEnabled: Whether scrolling is enabled
    ///   - bounces: Whether bounces is enabled
    ///   - showsHorizontalScrollIndicator: Whether to show horizontal scroll indicator
    ///   - showsVerticalScrollIndicator: Whether to show vertical scroll indicator
    ///   - scrollsToTop: Whether scrolls to top is enabled
    ///   - onURLClick: Callback when URL is clicked
    ///   - onSliceStateChange: Callback when slice state changes
    public init(
      json: String,
      initialState: JSONSlice.State = .default,
      automaticWrapEnabled: Bool = true,
      highlightStyle: HighlightStyle = .default,
      isHiddenLineNumber: Bool = false,
      isScrollEnabled: Bool = true,
      bounces: Bool = true,
      showsHorizontalScrollIndicator: Bool = true,
      showsVerticalScrollIndicator: Bool = true,
      scrollsToTop: Bool = true,
      onURLClick: ((URL) -> Bool)? = nil,
      onSliceStateChange: ((JSONSlice, JSONDecorator) -> Void)? = nil
    ) {
      self.json = json
      self.initialState = initialState
      self.automaticWrapEnabled = automaticWrapEnabled
      self.highlightStyle = highlightStyle
      self.isHiddenLineNumber = isHiddenLineNumber
      self.isScrollEnabled = isScrollEnabled
      self.bounces = bounces
      self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
      self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
      self.scrollsToTop = scrollsToTop
      self.onURLClick = onURLClick
      self.onSliceStateChange = onSliceStateChange
    }
  #endif

  // MARK: - UIViewRepresentable

  public func makeUIView(context: Context) -> JSONPreview {
    let jsonPreview = JSONPreview(automaticWrapEnabled: automaticWrapEnabled)

    // Configure the view
    jsonPreview.highlightStyle = highlightStyle
    jsonPreview.isHiddenLineNumber = isHiddenLineNumber
    jsonPreview.isScrollEnabled = isScrollEnabled
    jsonPreview.bounces = bounces
    jsonPreview.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
    jsonPreview.showsVerticalScrollIndicator = showsVerticalScrollIndicator

    #if !os(tvOS)
      jsonPreview.scrollsToTop = scrollsToTop
      jsonPreview.delegate = context.coordinator
    #endif

    // Preview the JSON
    jsonPreview.preview(json, initialState: initialState)

    return jsonPreview
  }

  public func updateUIView(_ uiView: JSONPreview, context: Context) {
    // Update properties if they changed
    if uiView.automaticWrapEnabled != automaticWrapEnabled {
      uiView.automaticWrapEnabled = automaticWrapEnabled
    }

    // Always update highlight style to ensure consistency
    uiView.highlightStyle = highlightStyle

    if uiView.isHiddenLineNumber != isHiddenLineNumber {
      uiView.isHiddenLineNumber = isHiddenLineNumber
    }

    if uiView.isScrollEnabled != isScrollEnabled {
      uiView.isScrollEnabled = isScrollEnabled
    }

    if uiView.bounces != bounces {
      uiView.bounces = bounces
    }

    if uiView.showsHorizontalScrollIndicator != showsHorizontalScrollIndicator {
      uiView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
    }

    if uiView.showsVerticalScrollIndicator != showsVerticalScrollIndicator {
      uiView.showsVerticalScrollIndicator = showsVerticalScrollIndicator
    }

    #if !os(tvOS)
      if uiView.scrollsToTop != scrollsToTop {
        uiView.scrollsToTop = scrollsToTop
      }
    #endif

    // Update delegate
    #if !os(tvOS)
      uiView.delegate = context.coordinator
    #endif
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(
      onURLClick: onURLClick,
      onSliceStateChange: onSliceStateChange
    )
  }
}

// MARK: - Coordinator

@available(iOS 13.0, tvOS 13.0, visionOS 1.0, *)
extension JSONPreviewSwiftUI {
  public class Coordinator: NSObject, JSONPreviewDelegate {
    let onURLClick: ((URL) -> Bool)?
    let onSliceStateChange: ((JSONSlice, JSONDecorator) -> Void)?

    init(
      onURLClick: ((URL) -> Bool)?,
      onSliceStateChange: ((JSONSlice, JSONDecorator) -> Void)?
    ) {
      self.onURLClick = onURLClick
      self.onSliceStateChange = onSliceStateChange
    }

    #if !os(tvOS)
      public func jsonPreview(_ view: JSONPreview, didClickURL url: URL, on textView: UITextView)
        -> Bool
      {
        return onURLClick?(url) ?? true
      }

      public func jsonPreview(
        _ view: JSONPreview, didChangeSliceState slice: JSONSlice, decorator: JSONDecorator
      ) {
        onSliceStateChange?(slice, decorator)
      }
    #endif
  }
}

// MARK: - Convenience Extensions

@available(iOS 13.0, tvOS 13.0, visionOS 1.0, *)
extension JSONPreviewSwiftUI {

  /// Configure automatic wrapping
  /// - Parameter enabled: Whether to enable automatic wrapping
  /// - Returns: A new JSONPreviewSwiftUI with updated configuration
  public func automaticWrap(_ enabled: Bool) -> JSONPreviewSwiftUI {
    #if !os(tvOS)
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: enabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        scrollsToTop: scrollsToTop,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    #else
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: enabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    #endif
  }

  /// Configure highlight style
  /// - Parameter style: The highlight style to use
  /// - Returns: A new JSONPreviewSwiftUI with updated configuration
  public func highlightStyle(_ style: HighlightStyle) -> JSONPreviewSwiftUI {
    #if !os(tvOS)
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: style,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        scrollsToTop: scrollsToTop,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    #else
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: style,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    #endif
  }

  /// Hide or show line numbers
  /// - Parameter hidden: Whether to hide line numbers
  /// - Returns: A new JSONPreviewSwiftUI with updated configuration
  public func hideLineNumbers(_ hidden: Bool) -> JSONPreviewSwiftUI {
    #if !os(tvOS)
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: hidden,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        scrollsToTop: scrollsToTop,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    #else
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: hidden,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    #endif
  }

  /// Configure scrolling behavior
  /// - Parameter enabled: Whether scrolling is enabled
  /// - Returns: A new JSONPreviewSwiftUI with updated configuration
  public func scrollEnabled(_ enabled: Bool) -> JSONPreviewSwiftUI {
    #if !os(tvOS)
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: enabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        scrollsToTop: scrollsToTop,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    #else
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: enabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    #endif
  }

  /// Configure bounces behavior
  /// - Parameter enabled: Whether bounces is enabled
  /// - Returns: A new JSONPreviewSwiftUI with updated configuration
  public func bounces(_ enabled: Bool) -> JSONPreviewSwiftUI {
    #if !os(tvOS)
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: enabled,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        scrollsToTop: scrollsToTop,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    #else
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: enabled,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    #endif
  }

  /// Configure scroll indicators
  /// - Parameters:
  ///   - horizontal: Whether to show horizontal scroll indicator
  ///   - vertical: Whether to show vertical scroll indicator
  /// - Returns: A new JSONPreviewSwiftUI with updated configuration
  public func scrollIndicators(horizontal: Bool, vertical: Bool) -> JSONPreviewSwiftUI {
    #if !os(tvOS)
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: horizontal,
        showsVerticalScrollIndicator: vertical,
        scrollsToTop: scrollsToTop,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    #else
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: horizontal,
        showsVerticalScrollIndicator: vertical,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    #endif
  }

  #if !os(tvOS)
    /// Configure scrolls to top behavior
    /// - Parameter enabled: Whether scrolls to top is enabled
    /// - Returns: A new JSONPreviewSwiftUI with updated configuration
    public func scrollsToTop(_ enabled: Bool) -> JSONPreviewSwiftUI {
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        scrollsToTop: enabled,
        onURLClick: onURLClick,
        onSliceStateChange: onSliceStateChange
      )
    }
  #endif

  /// Configure URL click callback
  /// - Parameter callback: Callback when URL is clicked
  /// - Returns: A new JSONPreviewSwiftUI with updated configuration
  public func onURLClick(_ callback: @escaping (URL) -> Bool) -> JSONPreviewSwiftUI {
    #if !os(tvOS)
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        scrollsToTop: scrollsToTop,
        onURLClick: callback,
        onSliceStateChange: onSliceStateChange
      )
    #else
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        onURLClick: callback,
        onSliceStateChange: onSliceStateChange
      )
    #endif
  }

  /// Configure slice state change callback
  /// - Parameter callback: Callback when slice state changes
  /// - Returns: A new JSONPreviewSwiftUI with updated configuration
  public func onSliceStateChange(_ callback: @escaping (JSONSlice, JSONDecorator) -> Void)
    -> JSONPreviewSwiftUI
  {
    #if !os(tvOS)
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        scrollsToTop: scrollsToTop,
        onURLClick: onURLClick,
        onSliceStateChange: callback
      )
    #else
      return JSONPreviewSwiftUI(
        json: json,
        initialState: initialState,
        automaticWrapEnabled: automaticWrapEnabled,
        highlightStyle: highlightStyle,
        isHiddenLineNumber: isHiddenLineNumber,
        isScrollEnabled: isScrollEnabled,
        bounces: bounces,
        showsHorizontalScrollIndicator: showsHorizontalScrollIndicator,
        showsVerticalScrollIndicator: showsVerticalScrollIndicator,
        onURLClick: onURLClick,
        onSliceStateChange: callback
      )
    #endif
  }
}
