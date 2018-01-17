//
//  BaseComponent.swift
//  Recoil
//
//  Created by Michael Bachand on 1/17/18.
//  Copyright © 2018 Leland Richardson. All rights reserved.
//

public final class BaseComponent<P: Props, S: State> {

  // MARK: Lifcycle

  init(props: P, state: S) {
    _props = props
    _state = state
  }

  // MARK: Public

  public weak var instance: RecoilCompositeInstance?

  public func setPropsInternal(props: P) {
    _props = props
  }

  public func setStateInternal(state: S) {
    _state = state
  }

  public func getStateInternal() -> S {
    return _state
  }

  // MARK: Private

  private var _props: P
  private var _state: S
}

// MARK: Component

extension BaseComponent: Component {

  public var props: Props { return _props }

  public var state: State { return _state }

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
