//
//  Element.swift
//  Recoil
//
//  Created by Leland Richardson on 12/12/17.
//  Copyright © 2017 Leland Richardson. All rights reserved.
//

import Foundation

public protocol Key {
  func recoilKeyValue() -> String
}

extension String: Key {
  public func recoilKeyValue() -> String { return self }
}

extension Int: Key {
  public func recoilKeyValue() -> String { return "\(self)" }
}



public enum ElementEnum: Element {
  case host(HostElement)
  case component(ComponentElement)
  case function(FunctionalElement)
  case array(Array<Element?>)
  case string(String)
  case double(Double)
  case int(Int)
}

public struct ComponentElement {
  let type: Component.Type
  let props: Props
  let key: Key?
}

public struct FunctionalElement {
  let type: (Any) -> Element?
  let realType: Any
  let props: Props
  let key: Key?
}

public struct HostElement {
  let type: HostComponentProtocol.Type
  let props: Props
  internal let key: Key?
}

public func ==(lhs: Element, rhs: Element) -> Bool {
  switch (lhs, rhs) {
  case let (ElementEnum.host(a), ElementEnum.host(b)):
    return a == b
  case let (ElementEnum.component(a), ElementEnum.component(b)):
    return a == b
  case let (ElementEnum.string(a), ElementEnum.string(b)):
    return a == b
  case let (ElementEnum.double(a), ElementEnum.double(b)):
    return a == b
  case let (ElementEnum.int(a), ElementEnum.int(b)):
    return a == b
  case (ElementEnum.array, ElementEnum.array):
    return false
  default:
    return false
  }
}

public func ==(lhs: ComponentElement, rhs: ComponentElement) -> Bool {
  // TODO: How should we implement this? :(
  return false
}

public func ==(lhs: HostElement, rhs: HostElement) -> Bool {
  // TODO: How should we implement this? :(
  return false
}

public func ==(lhs: FunctionalElement, rhs: FunctionalElement) -> Bool {
  // TODO: How should we implement this? :(
  return false
}

public func !=(lhs: HostElement, rhs: HostElement) -> Bool {
  return !(lhs == rhs)
}

public func !=(lhs: ComponentElement, rhs: ComponentElement) -> Bool {
  return !(lhs == rhs)
}

public func !=(lhs: FunctionalElement, rhs: FunctionalElement) -> Bool {
  return !(lhs == rhs)
}

public func !=(lhs: Element, rhs: Element) -> Bool {
  return !(lhs == rhs)
}
