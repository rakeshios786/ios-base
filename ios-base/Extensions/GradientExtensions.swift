//
//  GeneralHelper.swift
//  swift-base
//
//  Created by TopTier labs on 2/19/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

public enum GradientDirection: Double {
  case topToBottom = 90.0
  case bottomToTop = 270.0
  case leftToRight = 180.0
  case rightToLeft = 0.0
}

extension Array where Element: UIView {
  
  func addGradient(withColors colors: [UIColor], direction: GradientDirection = .topToBottom, locations: [Int] = []) {
    for view in self {
      _ = view.addGradient(colors: colors, direction: direction, locations: locations)
    }
  }
  
  func addGradient(colors: [UIColor], angle: Double, locations: [Int] = []) {
    for view in self {
      _ = view.addGradient(colors: colors, angle: angle, locations: locations)
    }
  }
}

extension UIView {
  func addGradient(colors: [UIColor], direction: GradientDirection = .topToBottom, locations: [Int] = []) -> CAGradientLayer {
    return addGradient(colors: colors, startPoint: gradientStartPointFor(direction.rawValue), endPoint: gradientEndPointFor(direction.rawValue), locations: locations)
  }
  
  func addGradient(colors: [UIColor], angle: Double, locations: [Int] = []) -> CAGradientLayer {
    return addGradient(colors: colors, startPoint: gradientStartPointFor(angle), endPoint: gradientEndPointFor(angle), locations: locations)
  }
  
  func addGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint, locations: [Int] = []) -> CAGradientLayer {
    return layer.addGradient(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
  }
}

extension CALayer {
  func addGradient(colors: [UIColor], direction: GradientDirection = .topToBottom, locations: [Int] = []) -> CAGradientLayer {
    return addGradient(colors: colors, startPoint: gradientStartPointFor(direction.rawValue), endPoint: gradientEndPointFor(direction.rawValue), locations: locations)
  }
  
  //  Angle param is measured anti-clockwise
  func addGradient(colors: [UIColor], angle: Double, locations: [Int] = []) -> CAGradientLayer {
    return addGradient(colors: colors, startPoint: gradientStartPointFor(angle), endPoint: gradientEndPointFor(angle), locations: locations)
  }
  
  //  This method will add a gradien layer in background with the given colors,
  //  points and locations of stops(in percents %) for the colors provided.
  func addGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint, locations: [Int] = []) -> CAGradientLayer {
    var gradient: CAGradientLayer
    if let current = sublayers?.first as? CAGradientLayer {
      gradient = current
    } else {
      gradient = CAGradientLayer()
      insertSublayer(gradient, at: 0)
    }
    gradient.frame = bounds
    gradient.colors = colors.map {$0.cgColor}
    
    gradient.startPoint = startPoint
    gradient.endPoint = endPoint
    if !locations.isEmpty {
      gradient.locations = locations.map { NSNumber(value: Float($0)/100.0 as Float)}
    }
    return gradient
  }
}

//MARK: Helper methods

fileprivate func gradientStartPointFor(_ angle: Double) -> CGPoint {
  
  if let defaultDirection = GradientDirection.init(rawValue: angle) {
    switch defaultDirection {
    case .topToBottom: return CGPoint(x: 0.5, y: 0.0)
    case .bottomToTop: return CGPoint(x: 0.5, y: 1.0)
    case .leftToRight: return CGPoint(x: 0.0, y: 0.5)
    default:
      return CGPoint(x: 1.0, y: 0.5)
    }
  }
  return pointWithAngle(angle)
}

fileprivate func gradientEndPointFor(_ angle: Double) -> CGPoint {
  if let defaultDirection = GradientDirection.init(rawValue: angle) {
    switch defaultDirection {
    case .topToBottom: return CGPoint(x: 0.5, y: 1.0)
    case .bottomToTop: return CGPoint(x: 0.5, y: 0.0)
    case .leftToRight: return CGPoint(x: 1.0, y: 0.5)
    default:
      return CGPoint(x: 0.0, y: 0.5)
    }
  }
  return pointWithAngle(angle, needStart: false)
}

///  **pointWithAngle**: Helper for CAGradientLayer's start and endPoint given anlge in degrees
///  - Parameter **angle** The desired angle in degrees and measured anti-clockwise.
///  - Parameter **needStart** A boolean indicating what point you need.
///  - Returns: The start and end CGPoints of a CAGradientLayer within the Unit Cordinate System.
fileprivate func pointWithAngle(_ angle: Double, needStart: Bool = true) -> CGPoint {
  //  negative angles not allowed
  var positiveAngle = angle<0 ? angle * -1.0 : angle
  
  var y1: Double, y2: Double, x1: Double, x2: Double
  // ranges when we know Y values
  if (positiveAngle >= 45 && positiveAngle <= 135) || (positiveAngle >= 225 && positiveAngle <= 315) {
    y1 = positiveAngle < 180 ? 0.0 : 1.0
    y2 = 1.0-y1 //opposite to start Y
    x1 = positiveAngle>=45 && positiveAngle <= 135 ? 1.5 - (positiveAngle/90) : abs(2.5 - (positiveAngle/90))
    x2 = 1.0-x1 //opposite to start X
  } else { // ranges when we know X values
    x1 = positiveAngle < 45 || positiveAngle >= 315 ? 1.0 : 0.0
    x2 = 1.0-x1
    if positiveAngle > 135 && positiveAngle < 225 {
      y2 = abs(2.5 - (positiveAngle/90))
      y1 = 1.0-y2
    } else { // Range 0-45 315-360
      //Turn this ranges into one single 90 degrees range
      positiveAngle = positiveAngle >= 0 && positiveAngle <= 45 ? 45.0-positiveAngle : 360-positiveAngle+45
      y1 = positiveAngle/90
      y2 = 1.0-y1
    }
  }
  return needStart ? CGPoint(x: x1, y: y1) : CGPoint(x: x2, y: y2)
}
