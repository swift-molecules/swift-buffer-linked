# swift-buffer-linked

Use this package when you need elements, copyable or not, held in linked nodes in a pooled generational store, with insertion and removal at both ends and no shifting of the other elements. Start from `Buffer<S>.Linked<N>`. Set `N` to 2 for a doubly-linked buffer or 1 for a singly-linked one. Set `S` to `Storage<Memory.Allocator<Memory.Heap>.Pool>.Generational<Node<E, N>>` when the buffer has a single owner, or to `Ownership.Shared` over that storage when copies must behave as independent values. For a list with collection semantics, use swift-list-linked. For a first-in, first-out queue, use swift-queue-linked. For contiguous elements, use swift-buffer-linear, and for a circular buffer, swift-buffer-ring.

## Laws

- Capacity is a hard ceiling counted in nodes. Inserting into a full buffer throws and leaves the count and contents unchanged. The buffer never grows by itself.
- Only `ensureCapacity` and `reserveAdditionalCapacity` grow the buffer, and capacity never shrinks. A request at or below the current capacity does nothing. Otherwise the new capacity is the largest of the request, twice the current capacity, and 4. Growth keeps every element in its order.
- In a node, `links[0]` points to the next node toward the back. When `N >= 2`, `links[1]` points to the previous node toward the front. No other link is ever set.
- With `N == 1`, `removeBack` walks from the head to find the new tail, so it takes linear time. `forEachReversed` traps unless `N >= 2`.
- `removeFront` and `removeBack` hand the element to the caller, who then owns it and destroys it. When the buffer is torn down, it destroys each element still in it exactly once. After `removeAll`, the buffer is empty and accepts new inserts.
- Over `Ownership.Shared`, every insert, removal and growth first gives the buffer its own copy of shared storage. A copy and its original never see each other's inserts, removals or growth, including any change to `capacity`.
- `makeIterator` copies every element into an array when it is called. Later mutation of the buffer does not affect the iterator. `first` and `last` return copies.
