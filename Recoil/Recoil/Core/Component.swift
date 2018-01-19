//
//  Component.swift
//  Recoil
//
//  Created by Leland Richardson on 12/12/17.
//  Copyright © 2017 Leland Richardson. All rights reserved.
//

public final class Component<Props: PropsProtocol, State: StateProtocol>: ComponentProtocol {

  // MARK: Lifecycle

  public init(props: Props) {
    self.props = props
    state = State.initialState()
  }

  // MARK: Internal

  internal weak var instance: RecoilCompositeInstance<Props, State>?
  internal var state: State
  internal private(set) var props: Props

  public func componentWillReceiveProps(_ nextProps: Props) {
  }

  public func componentWillUpdate(_ nextProps: Props, _ nextState: State) {
  }

  public func componentDidUpdate(_ prevProps: Props, _ prevState: State) {
  }

  public func shouldComponentUpdate(nextProps: Props, nextState: State) -> Bool {
    return true
  }

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

  public func componentWillMount() {

  }

  public func componentDidMount() {

  }

  public func componentWillUnmount() {

  }

  public func render() -> Element? {
    return nil
  }
}
