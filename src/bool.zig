const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Implements needed Val conversions.
pub const Bool = struct {
    inner: bool,

    pub fn new(value: bool) Bool {
        return Bool{ .inner = value };
    }

    pub fn getInner(self: Bool) bool {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!Bool {
        if (!(val.hasTag(ValTag.val_true.repr()) or val.hasTag(ValTag.val_false.repr()))) {
            return error.ConversionError;
        }

        return Bool.new(val.hasTag(ValTag.val_true.repr()));
    }

    pub fn to_val(self: Bool) Val {
        if (self.getInner()) {
            return Val.fromBodyAndTag(0, ValTag.val_true);
        } else {
            return Val.fromBodyAndTag(0, ValTag.val_false);
        }
    }
};
