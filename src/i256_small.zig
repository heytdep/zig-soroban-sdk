const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around an u128 small enough to be fit in 56 bits.
pub const I256Small = struct {
    inner: i64,

    const tag = ValTag.val_i256_small;

    pub fn new(value: i64) I256Small {
        // TODO: implement is small check:
        // https://github.com/stellar/rs-soroban-env/blob/main/soroban-env-common/src/num.rs#L392

        return I256Small{ .inner = value };
    }

    pub fn getInner(self: I256Small) i64 {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!I256Small {
        if (!val.hasTag(tag.repr())) {
            return error.ConversionError;
        }

        return I256Small.new(val.getSignedBody());
    }

    pub fn to_val(self: I256Small) Val {
        return Val.fromBodyAndTag(@intCast(self.getInner()), tag);
    }

    pub fn add(self: I256Small, rhs: I256Small) I256Small {
        @setRuntimeSafety(true);
        return I256Small{ .inner = self.inner + rhs.inner };
    }

    pub fn sub(self: I256Small, rhs: I256Small) I256Small {
        @setRuntimeSafety(true);
        return I256Small{ .inner = self.inner - rhs.inner };
    }

    pub fn mul(self: I256Small, rhs: I256Small) I256Small {
        @setRuntimeSafety(true);
        return I256Small{ .inner = self.inner * rhs.inner };
    }

    pub fn div(self: I256Small, rhs: I256Small) I256Small {
        @setRuntimeSafety(true);
        return I256Small{ .inner = self.inner / rhs.inner };
    }

    pub fn add_unsafe(self: I256Small, rhs: I256Small) I256Small {
        return I256Small{ .inner = self.inner + rhs.inner };
    }

    pub fn sub_unsafe(self: I256Small, rhs: I256Small) I256Small {
        return I256Small{ .inner = self.inner - rhs.inner };
    }

    pub fn mul_unsafe(self: I256Small, rhs: I256Small) I256Small {
        return I256Small{ .inner = self.inner * rhs.inner };
    }

    pub fn div_unsafe(self: I256Small, rhs: I256Small) I256Small {
        return I256Small{ .inner = self.inner / rhs.inner };
    }
};

test "i256 small" {
    // TODO: test conversions
}
