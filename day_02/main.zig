const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    const input = @embedFile("sample.txt");
    var it = std.mem.tokenizeAny(u8, input, "\n");
    while (it.next()) |line| {
        print("{s}\n", .{line});
    }
}
