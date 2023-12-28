const std = @import("std");

pub const SourceIterator = struct {};

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const cwd = std.fs.cwd();

    var source_dir = try cwd.openDir("../blog-source", .{ .iterate = true });
    defer source_dir.close();

    var output_dir = try cwd.openDir("../out", .{ .iterate = true });
    defer output_dir.close();

    var source_walker = try source_dir.walk(allocator);
    defer source_walker.deinit();

    while (try source_walker.next()) |entry| {
        if (entry.kind == .file and std.mem.endsWith(u8, entry.path, ".md")) {
            const output = try output_dir.createFile(entry.path, .{});
            defer output.close();

            const source = try entry.dir.readFileAlloc(allocator, entry.path, 90000);
            defer allocator.free(source);

            try output.writeAll(source);
        }
    }

    std.debug.print("Hello, world!", .{});
}

test "Compile markdown files to HTML" {
    // TODO
}

test "Copy non-md files to out" {
    // TODO
}

test "Deduce title from first H1 heading" {
    // TODO
}

test "Generate index.html" {
    // TODO
}
