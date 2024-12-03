const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const Direction = enum {
    increment,
    decrement,
    pub fn find(curr: u8, next: u8) ?Direction {
        return switch (std.math.order(curr, next)) {
            .eq => null,
            .gt => .decrement,
            .lt => .increment,
        };
    }
    pub fn isSafe(self: Direction, curr: u8, next: u8) bool {
        return switch (self) {
            .increment => curr < next and next - curr <= 3,
            .decrement => curr > next and curr - next <= 3,
        };
    }
};

pub fn checkReport(report: []const u8) !bool {
    var reportIter = std.mem.splitScalar(u8, report, ' ');
    var current = try std.fmt.parseInt(u8, reportIter.next().?, 10);
    var next = try std.fmt.parseInt(u8, reportIter.peek().?, 10);
    const dir = Direction.find(current, next) orelse return false;
    if (!dir.isSafe(current, next)) return false;
    while (reportIter.next()) |sequ| {
        current = try std.fmt.parseInt(u8, sequ, 10);
        const peekNextLev = reportIter.peek() orelse return true;
        next = try std.fmt.parseInt(u8, peekNextLev, 10);
        const newDir = Direction.find(current, next) orelse return false;
        if (newDir != dir) return false;
        if (!dir.isSafe(current, next)) return false;
    }
    return true;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    var safeCnt: u32 = 0;
    var unsafeCnt: u32 = 0;
    var readIter = std.mem.tokenizeScalar(u8, input, '\n');
    while (readIter.next()) |line| {
        print("{s}\n", .{line});
        if (try checkReport(line)) safeCnt += 1 else unsafeCnt += 1;
    }
    print("Safe: {d} Unsafe: {d}\n", .{ safeCnt, unsafeCnt });
}
