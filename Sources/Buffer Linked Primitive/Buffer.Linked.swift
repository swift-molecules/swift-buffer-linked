public import Buffer
public import Memory
public import Memory_Allocator
public import Memory_Allocator_Pool
public import Ownership_Shared_Primitive
internal import Storage
public import Store

extension Buffer where S: ~Copyable {

    @frozen
    public struct Linked<let N: Int>: ~Copyable {

        @usableFromInline
        package var storage: S

        @usableFromInline
        package var head: Store.Generational.Handle?

        @usableFromInline
        package var tail: Store.Generational.Handle?

        @usableFromInline
        package var _count: Int

        @usableFromInline
        package var _capacity: Int

        @inlinable
        package init(storage: consuming S, capacity: Int) {
            self.storage = storage
            self.head = nil
            self.tail = nil
            self._count = 0
            self._capacity = capacity
        }
    }
}

extension Buffer.Linked where S: ~Copyable {

    @inlinable
    public var count: Int { _count }

    @inlinable
    public var isEmpty: Bool { _count == 0 }

    @inlinable
    public var capacity: Int { _capacity }

    @inlinable
    public var isFull: Bool { _count == _capacity }
}

extension Buffer.Linked: Copyable where S: Copyable {}

extension Buffer.Linked: @unchecked Sendable where S: Sendable {}

extension Buffer.Linked where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable>(minimumCapacity: Index<E>.Count)
    where S == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Node<E, N>> {
        precondition(minimumCapacity > .zero, "capacity must be positive")
        let count = Int(bitPattern: minimumCapacity)
        self.init(
            storage: S.create(slotCapacity: Index<Node<E, N>>.Count(UInt(count))),
            capacity: count
        )
    }

    @inlinable
    package mutating func _growTo<E: ~Copyable>(_ minimumCapacity: Int)
    where S == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Node<E, N>> {
        guard _capacity < minimumCapacity else { return }
        let newCapacity = Swift::max(minimumCapacity, Swift::max(_capacity * 2, 4))
        storage.grow(to: Index<Node<E, N>>.Count(UInt(newCapacity)))
        _capacity = newCapacity
    }

    @inlinable
    public mutating func ensureCapacity<E: ~Copyable>(_ minimumCapacity: Int)
    where S == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Node<E, N>> {
        _growTo(minimumCapacity)
    }

    @inlinable
    public mutating func reserveAdditionalCapacity<E: ~Copyable>(_ additional: Int)
    where S == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Node<E, N>> {
        _growTo(_count + additional)
    }
}

extension Buffer.Linked where S: ~Copyable {

    @inlinable
    public init<E>(minimumCapacity: Index<E>.Count)
    where
        S == Ownership.Shared<
            Node<E, N>, Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Node<E, N>>
        >
    {
        precondition(minimumCapacity > .zero, "capacity must be positive")
        let count = Int(bitPattern: minimumCapacity)
        let store = Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Node<E, N>>.create(
            slotCapacity: Index<Node<E, N>>.Count(UInt(count))
        )
        self.init(storage: Ownership.Shared(store), capacity: count)
    }

    @inlinable
    public init<E: ~Copyable>(minimumCapacity: Index<E>.Count)
    where
        S == Ownership.Shared<
            Node<E, N>, Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Node<E, N>>
        >
    {
        precondition(minimumCapacity > .zero, "capacity must be positive")
        let count = Int(bitPattern: minimumCapacity)
        let store = Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Node<E, N>>.create(
            slotCapacity: Index<Node<E, N>>.Count(UInt(count))
        )
        self.init(storage: Ownership.Shared(store), capacity: count)
    }

    @inlinable
    package mutating func _growTo<E: ~Copyable>(_ minimumCapacity: Int)
    where
        S == Ownership.Shared<
            Node<E, N>, Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Node<E, N>>
        >
    {
        guard _capacity < minimumCapacity else { return }
        let newCapacity = Swift::max(minimumCapacity, Swift::max(_capacity * 2, 4))
        storage.grow(to: Index<Node<E, N>>.Count(UInt(newCapacity)))
        _capacity = newCapacity
    }

    @inlinable
    public mutating func ensureCapacity<E: ~Copyable>(_ minimumCapacity: Int)
    where
        S == Ownership.Shared<
            Node<E, N>, Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Node<E, N>>
        >
    {
        _growTo(minimumCapacity)
    }

    @inlinable
    public mutating func reserveAdditionalCapacity<E: ~Copyable>(_ additional: Int)
    where
        S == Ownership.Shared<
            Node<E, N>, Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Node<E, N>>
        >
    {
        _growTo(_count + additional)
    }
}

extension Buffer.Linked where S: ~Copyable {

    @inlinable
    public func makeIterator<E: Copyable>() -> [E].Iterator
    where S: Store.Generational.`Protocol`, S.Element == Node<E, N> {
        var elements: [E] = []
        forEach { (element: borrowing E) in elements.append(copy element) }
        return elements.makeIterator()
    }

    @inlinable
    public func first<E: Copyable>() -> E?
    where S: Store.Generational.`Protocol`, S.Element == Node<E, N> {
        peekFront { (element: borrowing E) in copy element }
    }

    @inlinable
    public func last<E: Copyable>() -> E?
    where S: Store.Generational.`Protocol`, S.Element == Node<E, N> {
        peekBack { (element: borrowing E) in copy element }
    }
}
