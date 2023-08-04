const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around u64 small enough to be fit in 56 bits.
/// Also implements simple arithmetic operations, both
/// safe and unsafe.
pub const U64Small = struct {
    inner: u32,

    pub fn new(value: u32) U64Small {
        return U64Small{ .inner = value };
    }

    pub fn getInner(self: U64Small) u32 {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!U64Small {
        if (!val.hasTag(ValTag.val_u64_small.repr())) {
            return error.ConversionError;
        }

        return U64Small.new(val.getMajor());
    }

    pub fn to_val(self: U64Small) Val {
        return Val.fromMajorMinorAndTag(self.getInner(), 0, ValTag.val_u64_small);
    }

    pub fn add(self: U64Small, rhs: U64Small) U64Small {
        @setRuntimeSafety(true);
        return U64Small{ .inner = self.inner + rhs.inner };
    }

    pub fn sub(self: U64Small, rhs: U64Small) U64Small {
        @setRuntimeSafety(true);
        return U64Small{ .inner = self.inner - rhs.inner };
    }

    pub fn mul(self: U64Small, rhs: U64Small) U64Small {
        @setRuntimeSafety(true);
        return U64Small{ .inner = self.inner * rhs.inner };
    }

    pub fn div(self: U64Small, rhs: U64Small) U64Small {
        @setRuntimeSafety(true);
        return U64Small{ .inner = self.inner / rhs.inner };
    }

    pub fn add_unsafe(self: U64Small, rhs: U64Small) U64Small {
        return U64Small{ .inner = self.inner + rhs.inner };
    }

    pub fn sub_unsafe(self: U64Small, rhs: U64Small) U64Small {
        return U64Small{ .inner = self.inner - rhs.inner };
    }

    pub fn mul_unsafe(self: U64Small, rhs: U64Small) U64Small {
        return U64Small{ .inner = self.inner * rhs.inner };
    }

    pub fn div_unsafe(self: U64Small, rhs: U64Small) U64Small {
        return U64Small{ .inner = self.inner / rhs.inner };
    }
};

test "small u64" {
    // TODO: test conversions
}
