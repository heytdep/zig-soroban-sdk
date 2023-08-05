const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around timepoints (u64) small enough to be fit in 56 bits.
pub const TimepointSmall = struct {
    inner: u64,

    const tag = ValTag.val_timepoint_small;

    pub fn new(value: u64) TimepointSmall {
        // TODO: implement is small check:
        // https://github.com/stellar/rs-soroban-env/blob/main/soroban-env-common/src/num.rs#L392

        return TimepointSmall{ .inner = value };
    }

    pub fn getInner(self: TimepointSmall) u64 {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!TimepointSmall {
        if (!val.hasTag(tag.repr())) {
            return error.ConversionError;
        }

        return TimepointSmall.new(val.getBody());
    }

    pub fn to_val(self: TimepointSmall) Val {
        return Val.fromBodyAndTag(@intCast(self.getInner()), tag);
    }
};

test "timepoint small" {
    // TODO: test conversions
}
