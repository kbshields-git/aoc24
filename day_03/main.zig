const std = @import("std");

const input = @embedFile("sample.txt");

fn mult(multok: []const u8) !usize {
    const tok1 = std.mem.sliceTo(multok[4..], ',');
    const num1 = try std.fmt.parseInt(u32, tok1, 10);
    const tok2 = std.mem.sliceTo(multok[5 + tok1.len ..], ')');
    const num2 = try std.fmt.parseInt(u32, tok2, 10);
    return num1 * num2;
}

fn part1() !void {
    var total: usize = 0;
    var fileIter = std.mem.window(u8, input, 12, 1);
    while (fileIter.next()) |tok| {
        if (std.mem.eql(u8, tok[0..4], "mul(")) {
            total += mult(tok) catch continue;
        }
    }

    std.debug.print("Part 1 Total {d}\n", .{total});
}

fn part2() !void {
    var total: usize = 0;
    var doing: bool = true;
    var fileIter = std.mem.window(u8, input, 12, 1);
    while (fileIter.next()) |tok| {
        if (std.mem.eql(u8, tok[0..4], "do()")) {
            doing = true;
        }
        if (std.mem.eql(u8, tok[0..7], "don't()")) {
            doing = false;
        }
        if (std.mem.eql(u8, tok[0..4], "mul(")) {
            if (doing) {
                total += mult(tok) catch continue;
            }
        }
    }

    std.debug.print("Part 2 Total {d}\n", .{total});
}

pub fn main() !void {
    try part1();
    try part2();
}
