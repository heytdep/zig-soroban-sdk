pub const Val = @import("val.zig").Val;

// TYPE to VAL and VAL to TYPE conversions.
// Below are defined and implemented wrapper
// types designed to interact with Soroban.
// These types implement conversions from and to Val.

pub const U32 = @import("./u32.zig").U32;
pub const Bool = @import("./bool.zig").Bool;
pub const Void = @import("./void.zig").Void;
pub const I32 = @import("./i32.zig").I32;
pub const U64Small = @import("./u64_small.zig").U64Small;
pub const I64Small = @import("./i64_small.zig").I64Small;
pub const TimepointSmall = @import("/timepoint_small.zig").TimepointSmall;
pub const DurationSmall = @import("/duration_small.zig").DurationSmall;
pub const U128Small = @import("./u128_small.zig").U128Small;
pub const I128Small = @import("./i128_small.zig").I128Small;
pub const U256Small = @import("./u256_small.zig").U256Small;
pub const I256Small = @import("./i256_small.zig").I256Small;
