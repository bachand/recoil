//
//  Component+Convenience.swift
//  Recoil
//
//  Created by Michael Bachand on 1/18/18.
//  Copyright © 2018 Leland Richardson. All rights reserved.
//

extension Component {

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
