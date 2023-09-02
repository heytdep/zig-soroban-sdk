const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around an u128 small enough to be fit in 56 bits.
pub const Object = struct {
    fn is(value: Val) bool {
        const tag = Val.getTagU8(value);
        return tag > @as(u8, @intCast(ValTag.val_object_code_lower_bound)) and tag < @as(u8, @intCast(ValTag.val_object_code_upper_bound));
    }

    pub fn get_handle(value: Val) error{ConversionError}!u64 {
        if (!is(value)) {
            return error.ConversionError;
        }

        Val.getBody(value);
    }

    pub fn from_object(tag: ValTag, handle: u64) error{ConversionError}!Val {
        return Val.fromBodyAndTag(handle, tag);
    }
};
