const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around u64 small enough to be fit in 56 bits.
/// Also implements simple arithmetic operations, both
/// safe and unsafe.
pub const U64Small = struct {
    inner: u64,

    pub fn new(value: u64) U64Small {
        // TODO: implement is small check:
        // https://github.com/stellar/rs-soroban-env/blob/main/soroban-env-common/src/num.rs#L392

        return U64Small{ .inner = value };
    }

    pub fn getInner(self: U64Small) u64 {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!U64Small {
        if (!val.hasTag(ValTag.val_u64_small.repr())) {
            return error.ConversionError;
        }

        return U64Small.new(val.getBody());
    }

    pub fn to_val(self: U64Small) Val {
        return Val.fromBodyAndTag(@intCast(self.getInner()), ValTag.val_u64_small);
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
