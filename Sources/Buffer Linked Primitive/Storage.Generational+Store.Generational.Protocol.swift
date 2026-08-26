public import Storage_Generational
public import Store_Primitive

extension Storage.Generational: Store.Generational.`Protocol`
where Allocation: ~Copyable, Element: ~Copyable {}
