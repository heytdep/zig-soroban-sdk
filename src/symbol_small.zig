const val_mod = @import("./val.zig");
const Val = val_mod.Val;
const ValTag = val_mod.ValTag;

/// Wrapper around an u128 small enough to be fit in 56 bits.
pub const SmallSymbol = struct {
    inner: innertype,

    const innertype = []const u8;
    const tag = ValTag.val_small_symbol;

    pub fn new(value: innertype) SmallSymbol {
        return SmallSymbol{ .inner = value };
    }

    pub fn getInner(self: SmallSymbol) innertype {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!SmallSymbol {
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

        return SmallSymbol.new(result[0..9]);
    }

    pub fn to_val(self: SmallSymbol) error{ConversionError}!Val {
        const str = self.getInner();
        if (str.len > 9) {
            return error.ConversionError;
        }

        const code_bits = 6;
        var val: u64 = 0;

        for (0..str.len) |n| {
            const charcode = str[n];
            if (charcode >= 48 and charcode <= 122) {
                val <<= code_bits;
                var v: u64 = 0;
                if (charcode == 95) {
                    v = 1;
                } else if (charcode >= 48 and charcode <= 57) {
                    v = 2 + ((@as(u64, @intCast(charcode))) - 48);
                } else if (charcode >= 65 and charcode <= 90) {
                    v = 12 + ((@as(u64, @intCast(charcode))) - 65);
                } else if (charcode >= 97 and charcode <= 122) {
                    v = 38 + ((@as(u64, @intCast(charcode))) - 97);
                } else {
                    return error.ConversionError;
                }

                val |= v;
            }
        }

        return Val.fromBodyAndTag(val, tag);
    }
};

test "conversion" {
    const print = @import("std").debug.print;

    const str = "test";

    const small_symbol = SmallSymbol.new(str);
    const val = small_symbol.to_val() catch @panic("conversion");

    print("\nval for \"{s}\" is {}\n", .{ str, val.get_inner() });

    const test_symbol: Val = Val{ .inner = 3870177550 };

    const sym = SmallSymbol.from_val(test_symbol) catch @panic("conversion");

    print("symbol for {}: \"{s}\" \n", .{ test_symbol.get_inner(), sym.getInner() });
}
