// Some helpers
const WORD_BITS: usize = 64;
const TAG_BITS: usize = 8;
const ONE: u64 = 1;
const TAG_MASK: u64 = (ONE << TAG_BITS) - 1;
const BODY_BITS: usize = WORD_BITS - TAG_BITS;

const MAJOR_BITS: u32 = 32;
const MINOR_BITS: u32 = 24;

const MAJOR_MASK: u64 = (ONE << MAJOR_BITS) - 1;
const MINOR_MASK: u64 = (ONE << MINOR_BITS) - 1;

pub const Val = packed struct {
    inner: u64,

    fn getTagU8(self: Val) u8 {
        return @intCast(self.inner & TAG_MASK);
    }

    fn hasTag(self: Val, tag: u8) bool {
        return getTagU8(self) == tag;
    }

    fn getBody(self: Val) u64 {
        return self.inner >> TAG_BITS;
    }

    fn getSignedBody(self: Val) i64 {
        return @as(i64, @intCast(self.inner)) >> TAG_BITS;
    }

    fn fromBodyAndTag(body: u64, tag: ValTag) Val {
        return Val{ .inner = (body << TAG_BITS) | @as(u64, @intCast(tag.repr())) };
    }

    fn fromMajorMinorAndTag(major: u32, minor: u32, tag: ValTag) Val {
        return Val.fromBodyAndTag((@as(u64, major) << MINOR_BITS) | @as(u64, minor), tag);
    }

    fn getMajor(self: Val) u32 {
        return @intCast(self.getBody() >> MINOR_BITS);
    }
};

test "tag assetions" {
    const expect = @import("std").testing.expect;

    // value for u32: 42
    const sc_value_u32_42 = 12884901892;

    try expect(Val.hasTag(Val{ .inner = sc_value_u32_42 }, ValTag.val_u32.repr()));
    try expect(!Val.hasTag(Val{ .inner = sc_value_u32_42 }, ValTag.val_i32.repr()));
}

/// Code values for the 8 `tag` bits in the bit-packed representation
/// of [Val]. These don't coincide with tag numbers in the Val XDR
/// but cover all those cases as well as some optimized refinements for
/// special cases (boolean true and false, small-value forms).
/// https://github.com/stellar/rs-soroban-env/blob/main/soroban-env-common/src/val.rs#L46
const ValTag = enum(u8) {
    val_false = 0,
    val_true = 1,
    val_void = 2,
    val_error = 3,
    val_u32 = 4,
    val_i32 = 5,
    val_u64_small = 6,
    val_i64_small = 7,
    val_timepoint_small = 8,
    val_duration_small = 9,
    val_u128_small = 10,
    val_i128_small = 11,
    val_u256_small = 12,
    val_i256_small = 13,
    val_small_symbol = 14,
    val_ledger_key_contract_executable = 15,
    val_small_code_upper_bound = 16,
    val_object_code_lower_bound = 63,
    val_u64_object = 64,
    val_i64_object = 65,
    val_timepoint_object = 66,
    val_duration_object = 67,
    val_u128_object = 68,
    val_i128_object = 69,
    val_u256_object = 70,
    val_i256_object = 71,
    val_bytes_object = 72,
    val_string_object = 73,
    val_symbol_object = 74,
    val_vec_object = 75,
    val_map_object = 76,
    val_address_object = 77,
    val_ledger_key_nonce_object = 79,
    val_object_code_upper_bound = 80,

    pub fn repr(self: ValTag) u8 {
        return @intFromEnum(self);
    }
};

test "enum representation" {
    const expect = @import("std").testing.expect;
    try expect(ValTag.val_u32.repr() == 4);
}

pub const U32 = struct {
    inner: u32,

    pub fn new(value: u32) U32 {
        return U32{ .inner = value };
    }

    pub fn getInner(self: U32) u32 {
        return self.inner;
    }

    pub fn from_val(val: Val) error{ConversionError}!U32 {
        if (!val.hasTag(ValTag.val_u32.repr())) {
            return error.ConversionError;
        }

        return U32.new(val.getMajor());
    }

    pub fn to_val(self: U32) Val {
        return Val.fromMajorMinorAndTag(self.getInner(), 0, ValTag.val_u32);
    }

    pub fn add(self: U32, rhs: U32) U32 {
        @setRuntimeSafety(true);
        return U32{ .inner = self.inner + rhs.inner };
    }

    pub fn sub(self: U32, rhs: U32) U32 {
        @setRuntimeSafety(true);
        return U32{ .inner = self.inner - rhs.inner };
    }

    pub fn mul(self: U32, rhs: U32) U32 {
        @setRuntimeSafety(true);
        return U32{ .inner = self.inner * rhs.inner };
    }

    pub fn div(self: U32, rhs: U32) U32 {
        @setRuntimeSafety(true);
        return U32{ .inner = self.inner / rhs.inner };
    }

    pub fn add_unsafe(self: U32, rhs: U32) U32 {
        return U32{ .inner = self.inner + rhs.inner };
    }

    pub fn sub_unsafe(self: U32, rhs: U32) U32 {
        return U32{ .inner = self.inner - rhs.inner };
    }

    pub fn mul_unsafe(self: U32, rhs: U32) U32 {
        return U32{ .inner = self.inner * rhs.inner };
    }

    pub fn div_unsafe(self: U32, rhs: U32) U32 {
        return U32{ .inner = self.inner / rhs.inner };
    }
};

test "u32" {
    //const a = U32
}
