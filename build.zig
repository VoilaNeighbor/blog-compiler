const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "blog-compiler",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const exe_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // This line makes sure the exe gets compiled with `zig build`.
    b.installArtifact(exe);

    addNamedRunStep(b, exe, "run", .{
        .description = "Run the blog compiler with conventional blog input",
    });

    addNamedRunStep(b, exe_unit_tests, "test", .{
        .description = "Run the blog compiler unit tests",
    });
}

/// In Zig, it is two distinct steps between running an executable and user calling a command.
/// This function creates two steps as a shortcut.
fn addNamedRunStep(
    b: *std.Build,
    exe: *std.Build.CompileStep,
    name: []const u8,
    optional: struct {
        description: []const u8 = "",
    },
) void {
    const run = b.addRunArtifact(exe);
    const cmd = b.step(name, optional.description);
    run.step.dependOn(b.getInstallStep());
    cmd.dependOn(&run.step);
}
