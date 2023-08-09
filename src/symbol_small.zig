const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around an u128 small enough to be fit in 56 bits.
pub const SymbolSmall = struct {
    inner: innertype,

    const innertype = []const u8;
    const tag = ValTag.val_small_symbol;

    pub fn new(value: innertype) SymbolSmall {
        return SymbolSmall{ .inner = value };
    }

    pub fn getInner(self: SymbolSmall) innertype {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!SymbolSmall {
        if (!val.hasTag(tag.repr())) {
            return error.ConversionError;
        }

        var result: [9]u8 = [_]u8{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
        const codeBits = 6;
        var val_sym: u64 = 0;
        var body = val.getBody();

        for (0..10) |n| {
            val_sym = body & 63;
            body = body >> codeBits;

            if (val_sym == 1) {
                val_sym = 95;
            } else if (val_sym > 1 and val_sym < 12) {
                val_sym += 46;
            } else if (val_sym > 11 and val_sym < 38) {
                val_sym += 53;
            } else if (val_sym > 37 and val_sym < 64) {
                val_sym += 59;
            } else if (val_sym == 0) {
                break;
            }

            result[8 - n] = @intCast(val_sym);
        }

        return SymbolSmall.new(result[0..9]);
    }

    pub fn to_val(self: SymbolSmall) Val {
        return Val.fromBodyAndTag(@intCast(self.getInner()), tag);
    }
};

test "symbol small" {
    const print = @import("std").debug.print;

    const test_symbol: Val = Val{ .inner = 3870177550 };

    const sym = SymbolSmall.from_val(test_symbol) catch @panic("conversion");

    print("calculated symbol: \"{s}\" \n", .{sym.getInner()});
}
