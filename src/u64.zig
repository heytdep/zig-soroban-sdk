const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around u64 small enough to be fit in 56 bits.
/// Also implements simple arithmetic operations, both
/// safe and unsafe.
pub const U64Small = struct {};

test "u64" {
    // TODO: test conversions
}
