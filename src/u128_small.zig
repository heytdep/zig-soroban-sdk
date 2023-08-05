const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around an u128 small enough to be fit in 56 bits.
pub const U128Small = struct {
    inner: u64,

    const tag = ValTag.val_u128_small;

    pub fn new(value: u64) U128Small {
        // TODO: implement is small check:
        // https://github.com/stellar/rs-soroban-env/blob/main/soroban-env-common/src/num.rs#L392

        return U128Small{ .inner = value };
    }

    pub fn getInner(self: U128Small) u64 {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!U128Small {
        if (!val.hasTag(tag.repr())) {
            return error.ConversionError;
        }

        return U128Small.new(val.getBody());
    }

    pub fn to_val(self: U128Small) Val {
        return Val.fromBodyAndTag(@intCast(self.getInner()), tag);
    }

    pub fn add(self: U128Small, rhs: U128Small) U128Small {
        @setRuntimeSafety(true);
        return U128Small{ .inner = self.inner + rhs.inner };
    }

    pub fn sub(self: U128Small, rhs: U128Small) U128Small {
        @setRuntimeSafety(true);
        return U128Small{ .inner = self.inner - rhs.inner };
    }

    pub fn mul(self: U128Small, rhs: U128Small) U128Small {
        @setRuntimeSafety(true);
        return U128Small{ .inner = self.inner * rhs.inner };
    }

    pub fn div(self: U128Small, rhs: U128Small) U128Small {
        @setRuntimeSafety(true);
        return U128Small{ .inner = self.inner / rhs.inner };
    }

    pub fn add_unsafe(self: U128Small, rhs: U128Small) U128Small {
        return U128Small{ .inner = self.inner + rhs.inner };
    }

    pub fn sub_unsafe(self: U128Small, rhs: U128Small) U128Small {
        return U128Small{ .inner = self.inner - rhs.inner };
    }

    pub fn mul_unsafe(self: U128Small, rhs: U128Small) U128Small {
        return U128Small{ .inner = self.inner * rhs.inner };
    }

    pub fn div_unsafe(self: U128Small, rhs: U128Small) U128Small {
        return U128Small{ .inner = self.inner / rhs.inner };
    }
};

test "u128 small" {
    // TODO: test conversions
}
