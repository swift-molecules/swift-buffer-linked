public import Memory_Allocator_Pool
public import Memory_Allocator_Primitive
public import Memory
public import Ownership_Shared_Primitive
public import Storage_Generational
public import Store_Primitive

extension Ownership.Shared: Store.Generational.`Protocol`
where Element: ~Copyable, B == Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Element> {}
