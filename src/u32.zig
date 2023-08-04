const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around u32.
/// Also implements simple arithmetic operations, both
/// safe and unsafe.
pub const U32 = struct {
    inner: u32,

    pub fn new(value: u32) U32 {
        return U32{ .inner = value };
    }

    pub fn getInner(self: U32) u32 {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!U32 {
        if (!val.hasTag(ValTag.val_u32.repr())) {
            return error.ConversionError;
        }

        return U32.new(val.getMajor());
    }

    pub fn to_val(self: U32) Val {
        return Val.fromMajorMinorAndTag(self.getInner(), 0, ValTag.val_u32);
    }

    pub fn add(self: U32, rhs: U32) U32 {
        @setRuntimeSafety(true);
        return U32{ .inner = self.inner + rhs.inner };
    }

    pub fn sub(self: U32, rhs: U32) U32 {
        @setRuntimeSafety(true);
        return U32{ .inner = self.inner - rhs.inner };
    }

    pub fn mul(self: U32, rhs: U32) U32 {
        @setRuntimeSafety(true);
        return U32{ .inner = self.inner * rhs.inner };
    }

    pub fn div(self: U32, rhs: U32) U32 {
        @setRuntimeSafety(true);
        return U32{ .inner = self.inner / rhs.inner };
    }

    pub fn add_unsafe(self: U32, rhs: U32) U32 {
        return U32{ .inner = self.inner + rhs.inner };
    }

    pub fn sub_unsafe(self: U32, rhs: U32) U32 {
        return U32{ .inner = self.inner - rhs.inner };
    }

    pub fn mul_unsafe(self: U32, rhs: U32) U32 {
        return U32{ .inner = self.inner * rhs.inner };
    }

    pub fn div_unsafe(self: U32, rhs: U32) U32 {
        return U32{ .inner = self.inner / rhs.inner };
    }
};

test "u32" {
    // TODO: test conversions
}
