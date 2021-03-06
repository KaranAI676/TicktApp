//
//  Bundle+Addition.swift
//  Tickt
//
//  Created by Admin on 08/03/21.
//

import UIKit

extension Bundle {
    func `class`<T: AnyObject>(ofType type: T.Type, named name: String? = nil) throws -> T.Type {
        let name = name ?? String(reflecting: type.self)

        guard name.components(separatedBy: ".").count > 1 else { throw ClassLoadError.moduleNotFound }
        guard let loadedClass = Bundle.main.classNamed(name) else { throw ClassLoadError.classNotFound }
        guard let castedClass = loadedClass as? T.Type else { throw ClassLoadError.invalidClassType(loaded: name, expected: String(describing: type)) }

        return castedClass
    }
}

extension Bundle {
    enum ClassLoadError: Error {
        case moduleNotFound
        case classNotFound
        case invalidClassType(loaded: String, expected: String)
    }
}
