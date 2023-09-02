const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around i32.
/// Also implements simple arithmetic operations, both
/// safe and unsafe.
pub const I32 = packed struct {
    inner: i32,

    pub fn new(value: i32) I32 {
        return I32{ .inner = value };
    }

    pub fn getInner(self: I32) i32 {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!I32 {
        if (!val.hasTag(ValTag.val_i32.repr())) {
            return error.ConversionError;
        }

        return I32.new(@intCast(val.getMajor()));
    }

    pub fn to_val(self: I32) Val {
        return Val.fromMajorMinorAndTag(@intCast(self.getInner()), 0, ValTag.val_i32);
    }

    pub fn add(self: I32, rhs: I32) I32 {
        @setRuntimeSafety(true);
        return I32{ .inner = self.inner + rhs.inner };
    }

    pub fn sub(self: I32, rhs: I32) I32 {
        @setRuntimeSafety(true);
        return I32{ .inner = self.inner - rhs.inner };
    }

    pub fn mul(self: I32, rhs: I32) I32 {
        @setRuntimeSafety(true);
        return I32{ .inner = self.inner * rhs.inner };
    }

    pub fn div(self: I32, rhs: I32) I32 {
        @setRuntimeSafety(true);
        return I32{ .inner = self.inner / rhs.inner };
    }

    pub fn add_unsafe(self: I32, rhs: I32) I32 {
        return I32{ .inner = self.inner + rhs.inner };
    }

    pub fn sub_unsafe(self: I32, rhs: I32) I32 {
        return I32{ .inner = self.inner - rhs.inner };
    }

    pub fn mul_unsafe(self: I32, rhs: I32) I32 {
        return I32{ .inner = self.inner * rhs.inner };
    }

    pub fn div_unsafe(self: I32, rhs: I32) I32 {
        return I32{ .inner = self.inner / rhs.inner };
    }
};

test "i32" {
    // TODO: test conversions
}
