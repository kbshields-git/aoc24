const std = @import("std");
const print = std.debug.print;

const input = std.mem.trimRight(u8, @embedFile("input.txt"), "\n");

fn countDigits(n: u64) u64 {
    return std.math.log10_int(n) + 1;
}

fn splitDigits(n: usize) !struct { left: usize, right: usize } {
    var b: [32]u8 = undefined;
    const str = try std.fmt.bufPrint(&b, "{d}", .{n});
    const len = str.len;
    const mid = len / 2;

    const left_str = str[0..mid];
    const left = try std.fmt.parseInt(usize, left_str, 10);

    var right_str = str[mid..];
    var i: usize = 0;
    while (i < right_str.len and right_str[i] == '0') {
        i += 1;
    }

    right_str = right_str[i..];
    const right = if (right_str.len > 0) try std.fmt.parseInt(u32, right_str, 10) else 0;

    return .{ .left = left, .right = right };
}

fn part1(inputs: []const u8) !u64 {
    var count: u64 = 0;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const alloc = arena.allocator();

    var stones = std.ArrayList(usize).init(alloc);
    defer stones.deinit();
    var stoneIter = std.mem.splitScalar(u8, inputs, ' ');
    while (stoneIter.next()) |stone| {
        print("{any}\n", .{stone});
        const nextStone = try std.fmt.parseInt(usize, stone, 10);

        try stones.append(nextStone);
    }
    print("stones: {any}\n", .{stones});
    for (0..25) |_| {
        var oldStones = try stones.clone();
        defer oldStones.deinit();
        stones.clearRetainingCapacity();
        for (oldStones.items) |stone| {
            print("stone: {d}\n", .{stone});
            if (stone == 0) {
                try stones.append(1);
            } else if (countDigits(stone) % 2 == 0) {
                const splitStones = try splitDigits(stone);
                try stones.append(splitStones.left);
                try stones.append(splitStones.right);
            } else {
                try stones.append(stone * 2024);
            }
        }
    }
    count = stones.items.len;
    return count;
}

fn part2(inputs: []const u8) !u64 {
    var count: u64 = 0;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const alloc = arena.allocator();

    var stones = std.ArrayList(usize).init(alloc);
    defer stones.deinit();
    var stoneIter = std.mem.splitScalar(u8, inputs, ' ');
    while (stoneIter.next()) |stone| {
        print("{any}\n", .{stone});
        const nextStone = try std.fmt.parseInt(usize, stone, 10);

        try stones.append(nextStone);
    }
    print("stones: {any}\n", .{stones});
    for (0..75) |_| {
        var oldStones = try stones.clone();
        defer oldStones.deinit();
        stones.clearRetainingCapacity();
        for (oldStones.items) |stone| {
            //print("stone: {d}\n", .{stone});
            if (stone == 0) {
                try stones.append(1);
            } else if (countDigits(stone) % 2 == 0) {
                const splitStones = try splitDigits(stone);
                try stones.append(splitStones.left);
                try stones.append(splitStones.right);
            } else {
                try stones.append(stone * 2024);
            }
        }
    }
    count = stones.items.len;
    return count;
}

pub fn main() !void {
    const part1_ans = try part1(input);
    print("Part 1: {any}\n", .{part1_ans});
    const part2_ans = try part2(input);
    print("Part 2: {any}\n", .{part2_ans});
}
