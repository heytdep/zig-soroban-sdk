# zig-soroban-sdk

Zig SDK for writing [Soroban](https://soroban.stellar.org/) contracts.

## Why a Zig SDK for Soroban?

Introducing a Zig SDK offers distinct advantages: zig provides an exceptional level of control over their code (for example carefully choosing performance or safety for every operation depending on the needs). Moreover, Zig's first-class WebAssembly compilation compatibility aligns perfectly with the Soroban virtual machine. Lastly, this SDK expands the language options for Soroban developers contributing to a more adaptable ecosystem. 

## Progress

Ultimately I aim to make the sdk complete (all conversions, support for host functions) and make it ergonomic. This is the current progress:

- conversions
    - bool
    - void
    - u32, i32
    - u64Small, i64small

- host functions
    - none

Also, there is no spec generation for the contracts currently (although it's a P1 feature), so you'll either have to first write the contract's interface in rust and then manually inject WASM bytecode from the rust contract's wasm custom section to Zig's wasm, or you can use the RPC (or js soroban client) instead of the CLI and only inject the contract env meta (so you don't have to write the rust contract).

## About The Types

Given rust's ability to generate conversions thorugh macros, contracts built with the rust sdk can directly interact with the host using the already `Val`-decoded types: decoding and encoding from and to `Val` is already taken care of. 

Zig promotes a clarity and predictability approach to metaprogramming: `comptime`. This means that it might be possible to have a similar style to the rust sdk, but I haven't explored a solution yet also since it seems that `comptime` parameters are not allowed on exported wasm fns due to C-ABI compatibility.

This means that I'm currently writing the SDK around wrapper types that implement `Val` conversions. For example, a multiplier contract currently looks like:

```zig
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

```
