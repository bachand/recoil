//
//  Traverse.swift
//  Recoil
//
//  Created by Leland Richardson on 12/14/17.
//  Copyright © 2017 Leland Richardson. All rights reserved.
//

import Foundation

let SEPARATOR = "."
let SUBSEPARATOR = ":"

typealias TraversalCallback<T> = (inout T, Element, String) -> Void

private func getKey(el: Element?, index: Int) -> String {
  // This is where we would use the key prop to generate a unique id that
  // persists across moves. However we're skipping that so we'll just use the
  // index.
  if let el = el {
    switch el {
    case let ElementEnum.host(hostElement):
      if let key = hostElement.key {
        return key.recoilKeyValue()
      }
    case let ElementEnum.component(componentElement):
      if let key = componentElement.key {
        return key.recoilKeyValue()
      }
      break
    case let ElementEnum.function(functionElement):
      if let key = functionElement.key {
        return key.recoilKeyValue()
      }
      break
    default:
      break
    }
  }
  return "\(index)"
}

private func traverseAllChildrenImpl<T>(
  _ children: Element?,
  _ nameSoFar: String,
  _ traverseContext: inout T,
  _ callback: @escaping TraversalCallback<T>
) -> Int {
  // TODO: support booleans
  guard let children = children else {
    return 0
  }

  switch children {
  case
    ElementEnum.host(_),
    ElementEnum.component(_),
    ElementEnum.function(_),
    ElementEnum.int(_),
    ElementEnum.double(_):
    // Handle a single child.
    // We'll treat this name as if it were a lone item in an array, as going from
    // a single child to an array is fairly common.

    // This callback gets called with traverseContext as an argument. This is
    // passed in from the reconciler and it used there to track the children.
    callback(&traverseContext, children, nameSoFar + SEPARATOR + getKey(el: children, index: 0))
    return 1
  case ElementEnum.string(let string):
    let el = ElementEnum.host(HostElement(type: TextLiteral.self, props: string, key: nil))
    callback(&traverseContext, el, nameSoFar + SEPARATOR + getKey(el: children, index: 0))
    return 1
  case ElementEnum.array(let elements):
    // Otherwise we have an array. React also supports iterators but we won't.
    // We need to return the number of children so start tracking that.
    // Note that this isn't simply children.length - since children can contain nested
    // arrays, we need to account for that too, as those are rendered at the same level.
    var subTreeCount = 0
    let nextNamePrefix = nameSoFar == "" ? SEPARATOR : nameSoFar + SUBSEPARATOR

    // Loop over all children, generate the next key prefix, and then recurse!
    for i in 0..<elements.count {
      let child = elements[i]
      let nextName = nextNamePrefix + getKey(el: child, index: i)
      subTreeCount += traverseAllChildrenImpl(
        child,
        nextName,
        &traverseContext,
        callback
      )
    }

    return subTreeCount

  default: fatalError()
  }
}

func traverseAllChildren<T>(
  _ children: Element?,
  _ traverseContext: inout T,
  _ callback: @escaping TraversalCallback<T>
) -> Int {
  return traverseAllChildrenImpl(children, "", &traverseContext, callback)
}
