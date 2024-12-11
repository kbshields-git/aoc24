const std = @import("std");
const print = std.debug.print;

const input = std.mem.trimRight(u8, @embedFile("input.txt"), "\n");

const X = @Vector(2, u8){ 1, 0 };
const Y = @Vector(2, u8){ 0, 1 };

fn part1(file: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, file, '\n');
    const grid_size = std.mem.count(u8, file, "\n");
    var grid: [58][58]u8 = undefined;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var trailHeads = try std.ArrayList(@Vector(2, u8)).initCapacity(alloc, grid_size * grid_size);
    defer trailHeads.deinit();

    var x: usize = 0;
    while (lines.next()) |row| : (x += 1) {
        for (0.., row) |y, cell| {
            grid[x][y] = try std.fmt.parseInt(u8, &[_]u8{cell}, 10);
            if (cell == '0') {
                try trailHeads.append(.{ @intCast(x), @intCast(y) });
            }
        }
    }
    var searchList = try std.ArrayList(@Vector(2, u8)).initCapacity(alloc, grid_size * grid_size);
    defer searchList.deinit();

    var count: u64 = 0;
    for (trailHeads.items) |head| {
        try searchList.append(head);
        defer searchList.clearRetainingCapacity();
        for (1..9) |next| {
            var oldList = try searchList.clone();
            defer oldList.deinit();
            searchList.clearRetainingCapacity();
            for (oldList.items) |pathStep| {
                if (pathStep[0] > 0 and grid[pathStep[0] - 1][pathStep[1]] == next)
                    try searchList.append(pathStep - X);
                if (pathStep[0] < grid_size and grid[pathStep[0] + 1][pathStep[1]] == next)
                    try searchList.append(pathStep + X);
                if (pathStep[1] > 0 and grid[pathStep[0]][pathStep[1] - 1] == next)
                    try searchList.append(pathStep - Y);
                if (pathStep[1] < grid_size and grid[pathStep[0]][pathStep[1] + 1] == next)
                    try searchList.append(pathStep + Y);
            }
        }
        var uniquePeaks = std.AutoHashMap(@Vector(2, u8), void).init(alloc);
        for (searchList.items) |pathStep| {
            if (pathStep[0] > 0 and grid[pathStep[0] - 1][pathStep[1]] == 9)
                uniquePeaks.put(pathStep - X, {}) catch {};
            if (pathStep[0] < grid_size and grid[pathStep[0] + 1][pathStep[1]] == 9)
                uniquePeaks.put(pathStep + X, {}) catch {};
            if (pathStep[1] > 0 and grid[pathStep[0]][pathStep[1] - 1] == 9)
                uniquePeaks.put(pathStep - Y, {}) catch {};
            if (pathStep[1] < grid_size and grid[pathStep[0]][pathStep[1] + 1] == 9)
                uniquePeaks.put(pathStep + Y, {}) catch {};
        }
        count += @intCast(uniquePeaks.count());
    }

    return @intCast(count);
}

fn part2(file: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, file, '\n');
    const grid_size = std.mem.count(u8, file, "\n");
    var grid: [58][58]u8 = undefined;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var trailHeads = try std.ArrayList(@Vector(2, u8)).initCapacity(alloc, grid_size * grid_size);
    defer trailHeads.deinit();

    var x: usize = 0;
    while (lines.next()) |row| : (x += 1) {
        for (0.., row) |y, cell| {
            grid[x][y] = try std.fmt.parseInt(u8, &[_]u8{cell}, 10);
            if (cell == '0') {
                try trailHeads.append(.{ @intCast(x), @intCast(y) });
            }
        }
    }
    var searchList = try std.ArrayList(@Vector(2, u8)).initCapacity(alloc, grid_size * grid_size);
    defer searchList.deinit();

    var count: u64 = 0;
    for (trailHeads.items) |head| {
        try searchList.append(head);
        defer searchList.clearRetainingCapacity();
        for (1..10) |next| {
            var oldList = try searchList.clone();
            defer oldList.deinit();
            searchList.clearRetainingCapacity();
            for (oldList.items) |pathStep| {
                if (pathStep[0] > 0 and grid[pathStep[0] - 1][pathStep[1]] == next)
                    try searchList.append(pathStep - X);
                if (pathStep[0] < grid_size and grid[pathStep[0] + 1][pathStep[1]] == next)
                    try searchList.append(pathStep + X);
                if (pathStep[1] > 0 and grid[pathStep[0]][pathStep[1] - 1] == next)
                    try searchList.append(pathStep - Y);
                if (pathStep[1] < grid_size and grid[pathStep[0]][pathStep[1] + 1] == next)
                    try searchList.append(pathStep + Y);
            }
        }
        count += @intCast(searchList.items.len);
    }
    return @intCast(count);
}

pub fn main() !void {
    const part1_ans: u64 = try part1(input);
    print("Part 1: {d}\n", .{part1_ans});
    const part2_ans: u64 = try part2(input);
    print("Part 2: {d}\n", .{part2_ans});
}
