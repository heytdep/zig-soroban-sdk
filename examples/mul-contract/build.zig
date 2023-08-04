const std = @import("std");
const Mode = std.builtin.Mode;

const sdk_path = "../../src/main.zig";

pub fn build(b: *std.Build) !void {
    const lib = b.addSharedLibrary(.{ .name = "soroban_multiplier", .root_source_file = .{ .path = "src/contract.zig" }, .version = .{ .major = 1, .minor = 0, .patch = 0 }, .target = .{ .cpu_arch = .wasm32, .os_tag = .freestanding }, .optimize = Mode.ReleaseSmall });

    lib.rdynamic = true;

    //_ = b.addModule("soroban_sdk", std.build.CreateModuleOptions{ .source_file = std.Build.LazyPath{ .path = sdk_path } });

    lib.addAnonymousModule("soroban_sdk", std.build.CreateModuleOptions{ .source_file = std.Build.LazyPath{ .path = sdk_path } });

    b.installArtifact(lib);
}
