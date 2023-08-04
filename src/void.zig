const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Void struct.
/// Only implements the conversion to Val
/// as it can't be passed to the contract.
pub const Void = struct {
    pub fn to_val() Val {
        return Val.fromBodyAndTag(0, ValTag.val_void);
    }
};
