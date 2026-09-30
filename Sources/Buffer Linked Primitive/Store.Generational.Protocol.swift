public import Storage
public import Store

public protocol __StoreGenerationalProtocol: ~Copyable {

    associatedtype Element: ~Copyable

    mutating func unshare()

    mutating func insert(_ element: consuming Element) -> Store.Generational.Handle

    mutating func remove(_ handle: Store.Generational.Handle) -> Element?

    subscript(_ handle: Store.Generational.Handle) -> Element { get set }
}

extension Store.Generational {

    public typealias `Protocol` = __StoreGenerationalProtocol
}
