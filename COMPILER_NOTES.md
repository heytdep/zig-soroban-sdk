# Compiler Notes

#### Compiler stuff I need to look better into

Note: all this assumes `ReleaseSmall` as target optimization mode.


### 0. Unoptimized unreachable

It seems that the compiler chooses to represent various unreachables as various loops, instead of which creating a label for a single unreachable all unreachable code should goto.

For instance, here's the compiled wasm with zig:

```
export memory memory(initial: 16, max: 0);

global g_a:int = 1048576;

export function multiply(a:long, b:long, c:long, d:long):long {
  if ((a & 255L) != 4L) goto B_c;
  if ((b & 255L) != 4L) goto B_b;
  if ((c & 255L) != 4L) goto B_a;
  if ((d & 255L) != 4L) goto B_d;
  a = i64_extend_i32_u(i32_wrap_i64(a >> 32L)) *
      i64_extend_i32_u(i32_wrap_i64(b >> 32L));
  if (eqz(i32_wrap_i64(a >> 32L))) goto B_e;
  loop L_f {
    unreachable;
    continue L_f;
  }
  label B_e:
  a = i64_extend_i32_u(i32_wrap_i64(a)) *
      i64_extend_i32_u(i32_wrap_i64(c >> 32L));
  if (eqz(i32_wrap_i64(a >> 32L))) goto B_g;
  loop L_h {
    unreachable;
    continue L_h;
  }
  label B_g:
  a = i64_extend_i32_u(i32_wrap_i64(a)) *
      i64_extend_i32_u(i32_wrap_i64(d >> 32L));
  if (eqz(i32_wrap_i64(a >> 32L))) goto B_i;
  loop L_j {
    unreachable;
    continue L_j;
  }
  label B_i:
  return i64_extend_i32_u(i32_wrap_i64(a)) << 32L | 4L;
  label B_d:
  loop L_k {
    unreachable;
    continue L_k;
  }
  label B_c:
  loop L_l {
    unreachable;
    continue L_l;
  }
  label B_b:
  loop L_m {
    unreachable;
    continue L_m;
  }
  label B_a:
  return loop L_n {
           unreachable;
           continue L_n;
         }
}
```

And the same program compiled with rust:

```
export memory memory(initial: 16, max: 0);

global g_a:int = 1048576;
export global data_end:int = 1048576;
export global heap_base:int = 1048576;

export function multiply(a:long, b:long, c:long, d:long):long {
  if ((a & 255L) != 4L) goto B_a;
  if ((b & 255L) != 4L) goto B_a;
  if ((c & 255L) != 4L) goto B_a;
  if ((d & 255L) != 4L) goto B_a;
  a = i64_extend_i32_u(i32_wrap_i64(a >> 32L)) *
      i64_extend_i32_u(i32_wrap_i64(b >> 32L));
  if (i32_wrap_i64(a >> 32L)) goto B_a;
  a = i64_extend_i32_u(i32_wrap_i64(a)) *
      i64_extend_i32_u(i32_wrap_i64(c >> 32L));
  if (i32_wrap_i64(a >> 32L)) goto B_a;
  a = i64_extend_i32_u(i32_wrap_i64(a)) *
      i64_extend_i32_u(i32_wrap_i64(d >> 32L));
  if (i32_wrap_i64(a >> 32L)) goto B_a;
  return i64_extend_i32_u(i32_wrap_i64(a)) << 32L | 4L;
  label B_a:
  unreachable;
  return unreachable;
}

export function () {
}

```

Also when using wasm-opt multiple unreachable are placed as instructions:

```
export memory memory(initial: 16, max: 0);

export function multiply(a:long, b:long, c:long, d:long):long {
  if ((a & 255L) == 4L) {
    if ((b & 255L) != 4L) goto B_b;
    if ((c & 255L) != 4L) goto B_a;
    if ((d & 255L) == 4L) {
      a = (a >> 32L) * (b >> 32L);
      if (eqz(eqz(a >> 32L))) { unreachable }
      a = i64_extend_i32_u(i32_wrap_i64(a)) * (c >> 32L);
      if (eqz(eqz(a >> 32L))) { unreachable }
      a = i64_extend_i32_u(i32_wrap_i64(a)) * (d >> 32L);
      if (eqz(eqz(a >> 32L))) { unreachable }
      return i64_extend_i32_u(i32_wrap_i64(a)) << 32L | 4L;
    }
    unreachable;
  }
  unreachable;
  label B_b:
  unreachable;
  label B_a:
  return unreachable;
}
```

#### This makes for a more efficient binary

It would seem that even if the code section is slightly bigger on the zig compiled binary, it beats the rust compiled binary (both wasm optimized):
- zig compiled:

```
cpu ins consumed: 863250
cpu mem bytes consumed: 1186928
2023-08-04T11:53:23.141382Z  INFO soroban_cli::log::event: log="[Diagnostic Event] topics:[fn_call, Bytes(0000000000000000000000000000000000000000000000000000000000000001), multiply], data:[1294967295, 2, 1, 1]"
2023-08-04T11:53:23.141400Z  INFO soroban_cli::log::event: log="[Diagnostic Event] contract:0000000000000000000000000000000000000000000000000000000000000001, topics:[fn_return, multiply], data:2589934590"
2589934590
```

- rust compiled:

```
cpu ins consumed: 880134
cpu mem bytes consumed: 1188363
2023-08-04T11:51:22.394287Z  INFO soroban_cli::log::event: log="[Diagnostic Event] topics:[fn_call, Bytes(0000000000000000000000000000000000000000000000000000000000000001), multiply], data:[1294967295, 2, 1, 1]"
2023-08-04T11:51:22.394300Z  INFO soroban_cli::log::event: log="[Diagnostic Event] contract:0000000000000000000000000000000000000000000000000000000000000001, topics:[fn_return, multiply], data:2589934590"
2589934590
```

Although I suspect the discepancy to be because zig wasm size is still smaller than rusts.
