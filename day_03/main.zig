const std = @import("std");

const input = @embedFile("input.txt");

fn mult(multok: []const u8) !u32 {
    const tok1 = std.mem.sliceTo(multok[4..], ',');
    const num1 = try std.fmt.parseInt(u32, tok1, 10);
    const tok2 = std.mem.sliceTo(multok[5 + tok1.len ..], ')');
    const num2 = try std.fmt.parseInt(u32, tok2, 10);
    return num1 * num2;
}

fn part1() !void {
    var total: u32 = 0;
    var fileIter = std.mem.window(u8, input, 12, 1);
    while (fileIter.next()) |tok| {
        if (std.mem.eql(u8, tok[0..4], "mul(")) {
            total += mult(tok) catch continue;
        }
    }

    std.debug.print("Part 1 Total {d}\n", .{total});
}

pub fn main() !void {
    try part1();
}
