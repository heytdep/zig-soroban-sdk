const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around duration (u64) small enough to be fit in 56 bits.
pub const DurationSmall = struct {
    inner: u64,

    const tag = ValTag.val_duration_small;

    pub fn new(value: u64) DurationSmall {
        // TODO: implement is small check:
        // https://github.com/stellar/rs-soroban-env/blob/main/soroban-env-common/src/num.rs#L392

        return DurationSmall{ .inner = value };
    }

    pub fn getInner(self: DurationSmall) u64 {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!DurationSmall {
        if (!val.hasTag(tag.repr())) {
            return error.ConversionError;
        }

        return DurationSmall.new(val.getBody());
    }

    pub fn to_val(self: DurationSmall) Val {
        return Val.fromBodyAndTag(@intCast(self.getInner()), tag);
    }
};

test "u128 small" {
    // TODO: test conversions
}
