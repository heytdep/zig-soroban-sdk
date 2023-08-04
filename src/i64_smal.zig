const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around i64 small enough to be fit in 56 bits.
/// Also implements simple arithmetic operations, both
/// safe and unsafe.
pub const I64Small = struct {
    inner: i64,

    pub fn new(value: i64) I64Small {
        // TODO: implement is small check:
        // https://github.com/stellar/rs-soroban-env/blob/main/soroban-env-common/src/num.rs#L396

        return I64Small{ .inner = value };
    }

    pub fn getInner(self: I64Small) i64 {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!I64Small {
        if (!val.hasTag(ValTag.val_i64_small.repr())) {
            return error.ConversionError;
        }

        return I64Small.new(val.getSignedBody());
    }

    pub fn to_val(self: I64Small) Val {
        return Val.fromBodyAndTag(@intCast(self.getInner()), ValTag.val_i64_small);
    }

    pub fn add(self: I64Small, rhs: I64Small) I64Small {
        @setRuntimeSafety(true);
        return I64Small{ .inner = self.inner + rhs.inner };
    }

    pub fn sub(self: I64Small, rhs: I64Small) I64Small {
        @setRuntimeSafety(true);
        return I64Small{ .inner = self.inner - rhs.inner };
    }

    pub fn mul(self: I64Small, rhs: I64Small) I64Small {
        @setRuntimeSafety(true);
        return I64Small{ .inner = self.inner * rhs.inner };
    }

    pub fn div(self: I64Small, rhs: I64Small) I64Small {
        @setRuntimeSafety(true);
        return I64Small{ .inner = self.inner / rhs.inner };
    }

    pub fn add_unsafe(self: I64Small, rhs: I64Small) I64Small {
        return I64Small{ .inner = self.inner + rhs.inner };
    }

    pub fn sub_unsafe(self: I64Small, rhs: I64Small) I64Small {
        return I64Small{ .inner = self.inner - rhs.inner };
    }

    pub fn mul_unsafe(self: I64Small, rhs: I64Small) I64Small {
        return I64Small{ .inner = self.inner * rhs.inner };
    }

    pub fn div_unsafe(self: I64Small, rhs: I64Small) I64Small {
        return I64Small{ .inner = self.inner / rhs.inner };
    }
};

test "small i64" {
    // TODO: test conversions
}
