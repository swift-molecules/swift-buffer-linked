public import Memory_Allocator_Pool
public import Memory_Allocator
public import Memory
public import Ownership_Shared_Primitive
public import Storage
public import Store

extension Ownership.Shared: Store.Generational.`Protocol`
where Element: ~Copyable, B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {}
