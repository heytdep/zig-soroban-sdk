const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around an u128 small enough to be fit in 56 bits.
pub const I128Small = struct {
    inner: i64,

    const tag = ValTag.val_i128_small;

    pub fn new(value: i64) I128Small {
        // TODO: implement is small check:
        // https://github.com/stellar/rs-soroban-env/blob/main/soroban-env-common/src/num.rs#L392

        return I128Small{ .inner = value };
    }

    pub fn getInner(self: I128Small) i64 {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!I128Small {
        if (!val.hasTag(tag.repr())) {
            return error.ConversionError;
        }

        return I128Small.new(val.getSignedBody());
    }

    pub fn to_val(self: I128Small) Val {
        return Val.fromBodyAndTag(@intCast(self.getInner()), tag);
    }

    pub fn add(self: I128Small, rhs: I128Small) I128Small {
        @setRuntimeSafety(true);
        return I128Small{ .inner = self.inner + rhs.inner };
    }

    pub fn sub(self: I128Small, rhs: I128Small) I128Small {
        @setRuntimeSafety(true);
        return I128Small{ .inner = self.inner - rhs.inner };
    }

    pub fn mul(self: I128Small, rhs: I128Small) I128Small {
        @setRuntimeSafety(true);
        return I128Small{ .inner = self.inner * rhs.inner };
    }

    pub fn div(self: I128Small, rhs: I128Small) I128Small {
        @setRuntimeSafety(true);
        return I128Small{ .inner = self.inner / rhs.inner };
    }

    pub fn add_unsafe(self: I128Small, rhs: I128Small) I128Small {
        return I128Small{ .inner = self.inner + rhs.inner };
    }

    pub fn sub_unsafe(self: I128Small, rhs: I128Small) I128Small {
        return I128Small{ .inner = self.inner - rhs.inner };
    }

    pub fn mul_unsafe(self: I128Small, rhs: I128Small) I128Small {
        return I128Small{ .inner = self.inner * rhs.inner };
    }

    pub fn div_unsafe(self: I128Small, rhs: I128Small) I128Small {
        return I128Small{ .inner = self.inner / rhs.inner };
    }
};

test "i128 small" {
    // TODO: test conversions
}
