const soroban_sdk = @import("soroban_sdk");
const Val = soroban_sdk.val.Val;
const U32 = soroban_sdk.val.U32;

export fn multiply(a_: Val, b_: Val, c_: Val, d_: Val) Val {
    const a = U32.from_val(a_) catch unreachable;
    const b = U32.from_val(b_) catch unreachable;
    const c = U32.from_val(c_) catch unreachable;
    const d = U32.from_val(d_) catch unreachable;

    return a.mul(b).mul(c).mul(d).to_val();
}
