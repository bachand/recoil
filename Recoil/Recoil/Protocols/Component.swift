//
//  Component.swift
//  Recoil
//
//  Created by Leland Richardson on 12/12/17.
//  Copyright © 2017 Leland Richardson. All rights reserved.
//

// MARK: - Component

public protocol Component {

  var props: Props { get }
  var state: State { get }

  func componentWillReceiveProps(_ nextProps: Props)

  func componentWillUpdate(_ nextProps: Props, _ nextState: State)

  func componentDidUpdate(_ prevProps: Props, _ prevState: State)

  func shouldComponentUpdate(nextProps: Props, nextState: State) -> Bool

  func setState(_ updater: @escaping (_ prevState: State, _ props: Props) -> State, completion: () -> Void)

  func componentWillMount()

  func componentDidMount()

  func componentWillUnmount()

  func render() -> Element?
}

// MARK: Implementations

extension Component {

  public func setState(_ updater: @escaping (_ prevState: State, _ props: Props) -> State, completion: () -> Void) {
    // This is where React would do queueing, storing a series
    // of partialStates. The Updater would apply those in a batch later.
    // This is complicated so we won't do it today. Instead we'll update state
    // and then tell the reconciler this component needs to be updated, synchronously.
    guard let instance = instance else {
      fatalError()
    }

    if let pendingState = instance.pendingState {
      instance.pendingState = updater(pendingState, props)
    } else {
      instance.pendingState = updater(state, props)
    }

    Reconciler.performUpdateIfNecessary(instance: instance)
  }

  public func setState(_ stateExpression: @escaping @autoclosure () -> State, completion: () -> Void) {
    let marshallingUpdater: (State, Props) -> State = { (_, _) in
      return stateExpression()
    }
    setState(marshallingUpdater, completion: completion)
  }

  public func setState(_ updater: @escaping (_ prevState: State) -> State, completion: () -> Void) {
    let marshallingUpdater: (State, Props) -> State = { (prevState, _) in
      return updater(prevState)
    }
    setState(marshallingUpdater, completion: completion)
  }
}
