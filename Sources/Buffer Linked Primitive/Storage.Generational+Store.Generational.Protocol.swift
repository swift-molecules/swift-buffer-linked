public import Storage
public import Store

extension Storage.Generational: Store.Generational.`Protocol`
where Allocation: ~Copyable, Element: ~Copyable {}
