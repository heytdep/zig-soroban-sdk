const soroban_sdk = @import("soroban_sdk");
const Val = soroban_sdk.Val;
const U32 = soroban_sdk.U32;
const I32 = soroban_sdk.I32;
const U64Small = soroban_sdk.U64Small;
const I64Small = soroban_sdk.I64Small;
const Bool = soroban_sdk.Bool;
const Void = soroban_sdk.Void;
const U128Small = soroban_sdk.U128Small;
const I128Small = soroban_sdk.I128Small;
const U256Small = soroban_sdk.U256Small;
const I256Small = soroban_sdk.I256Small;

fn assert_bool_return_void(value_: Val) Val {
    if ((Bool.from_val(value_) catch unreachable).getInner()) {
        return Void.to_val();
    } else {
        return Bool.new(false).to_val();
    }
}

fn multiply(a_: Val, b_: Val, c_: Val, d_: Val) Val {
    @setRuntimeSafety(true);
    const a = U32.from_val(a_) catch unreachable;
    const b = U32.from_val(b_) catch unreachable;
    const c = U32.from_val(c_) catch unreachable;
    const d = U32.from_val(d_) catch unreachable;

    return a.mul(b).mul(c).mul(d).to_val();
}

export fn multiply_i32(a_: Val, b_: Val) Val {
    @setRuntimeSafety(true);
    const a = I32.from_val(a_) catch unreachable;
    const b = I32.from_val(b_) catch unreachable;

    return a.mul(b).to_val();
}

fn multiply_u64small(a_: Val, b_: Val) Val {
    @setRuntimeSafety(true);
    const a = U64Small.from_val(a_) catch unreachable;
    const b = U64Small.from_val(b_) catch unreachable;

    return a.mul(b).to_val();
}

fn multiply_i64small(a_: Val, b_: Val) Val {
    @setRuntimeSafety(true);
    const a = I64Small.from_val(a_) catch unreachable;
    const b = I64Small.from_val(b_) catch unreachable;

    return a.mul(b).to_val();
}

fn multiply_u128small(a_: Val, b_: Val) Val {
    @setRuntimeSafety(true);
    const a = U128Small.from_val(a_) catch unreachable;
    const b = U128Small.from_val(b_) catch unreachable;

    return a.mul(b).to_val();
}

fn multiply_i128small(a_: Val, b_: Val) Val {
    @setRuntimeSafety(true);
    const a = I128Small.from_val(a_) catch unreachable;
    const b = I128Small.from_val(b_) catch unreachable;

    return a.mul(b).to_val();
}

export fn multiply_u256small(a_: Val, b_: Val) Val {
    @setRuntimeSafety(true);
    const a = U256Small.from_val(a_) catch unreachable;
    const b = U256Small.from_val(b_) catch unreachable;

    return a.mul(b).to_val();
}

export fn multiply_i256small(a_: Val, b_: Val) Val {
    @setRuntimeSafety(true);
    const a = I256Small.from_val(a_) catch unreachable;
    const b = I256Small.from_val(b_) catch unreachable;

    return a.mul(b).to_val();
}
