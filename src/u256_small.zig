const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around an u128 small enough to be fit in 56 bits.
pub const U256Small = struct {
    inner: u64,

    const tag = ValTag.val_u256_small;

    pub fn new(value: u64) U256Small {
        // TODO: implement is small check:
        // https://github.com/stellar/rs-soroban-env/blob/main/soroban-env-common/src/num.rs#L392

        return U256Small{ .inner = value };
    }

    pub fn getInner(self: U256Small) u64 {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!U256Small {
        if (!val.hasTag(tag.repr())) {
            return error.ConversionError;
        }

        return U256Small.new(val.getBody());
    }

    pub fn to_val(self: U256Small) Val {
        return Val.fromBodyAndTag(@intCast(self.getInner()), tag);
    }

    pub fn add(self: U256Small, rhs: U256Small) U256Small {
        @setRuntimeSafety(true);
        return U256Small{ .inner = self.inner + rhs.inner };
    }

    pub fn sub(self: U256Small, rhs: U256Small) U256Small {
        @setRuntimeSafety(true);
        return U256Small{ .inner = self.inner - rhs.inner };
    }

    pub fn mul(self: U256Small, rhs: U256Small) U256Small {
        @setRuntimeSafety(true);
        return U256Small{ .inner = self.inner * rhs.inner };
    }

    pub fn div(self: U256Small, rhs: U256Small) U256Small {
        @setRuntimeSafety(true);
        return U256Small{ .inner = self.inner / rhs.inner };
    }

    pub fn add_unsafe(self: U256Small, rhs: U256Small) U256Small {
        return U256Small{ .inner = self.inner + rhs.inner };
    }

    pub fn sub_unsafe(self: U256Small, rhs: U256Small) U256Small {
        return U256Small{ .inner = self.inner - rhs.inner };
    }

    pub fn mul_unsafe(self: U256Small, rhs: U256Small) U256Small {
        return U256Small{ .inner = self.inner * rhs.inner };
    }

    pub fn div_unsafe(self: U256Small, rhs: U256Small) U256Small {
        return U256Small{ .inner = self.inner / rhs.inner };
    }
};

test "u256 small" {
    // TODO: test conversions
}
