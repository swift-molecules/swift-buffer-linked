public import Buffer

extension Buffer.Linked where S: ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case capacityExceeded
    }
}
