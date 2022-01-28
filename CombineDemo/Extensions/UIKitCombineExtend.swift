//
//  UIKitCombineExtend.swift
//  CombineDemo
//
//  Created by xiabin on 2022/1/28.
//  Copyright © 2022 Koubei. All rights reserved.
//

import Foundation

public struct UIKitCombineExtension<ExtendedType> {
    public private(set) var type: ExtendedType
    
    public init(_ type: ExtendedType) {
        self.type = type
    }
}

public protocol UIKitCombineExtended {
    associatedtype ExtendedType
    
    static var uicb: UIKitCombineExtension<ExtendedType>.Type { get set }
    var uicb: UIKitCombineExtension<ExtendedType> { get set }
}

extension UIKitCombineExtended {
    public static var uicb: UIKitCombineExtension<Self>.Type {
        get { UIKitCombineExtension<Self>.self }
        set {}
    }
    
    public var uicb: UIKitCombineExtension<Self> {
        get { UIKitCombineExtension(self) }
        set {}
    }
}
