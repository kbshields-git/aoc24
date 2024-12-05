const std = @import("std");

const file = std.mem.trimRight(u8, @embedFile("input.txt"), "\n");

const num_cols = 140;
const num_rows = 140;

const Pos = struct {
    x: usize,
    y: usize,
};

const Vector2 = struct {
    x: i64,
    y: i64,
};

const dirs = [_]Vector2{
    Vector2{ .x = -1, .y = -1 },
    Vector2{ .x = -1, .y = 0 },
    Vector2{ .x = -1, .y = 1 },
    Vector2{ .x = 0, .y = -1 },
    Vector2{ .x = 0, .y = 1 },
    Vector2{ .x = 1, .y = 1 },
    Vector2{ .x = 1, .y = 0 },
    Vector2{ .x = 1, .y = -1 },
};

const match = [4]u8{ 'X', 'M', 'A', 'S' };

fn part1(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var grid: [num_rows][num_cols]u8 = undefined;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var x_positions = try std.ArrayList(Pos).initCapacity(alloc, 140 * 140);
    defer x_positions.deinit();

    var x: usize = 0;
    while (lines.next()) |row| : (x += 1) {
        for (0.., row) |y, cell| {
            grid[x][y] = cell;
            if (cell == 'X') {
                x_positions.appendAssumeCapacity(.{ .x = x, .y = y });
            }
        }
    }
    var cnt: u64 = 0;
    for (x_positions.items) |x_pos| {
        dir: for (dirs) |dir| {
            const max_x = @as(i64, @intCast(x_pos.x)) + dir.x * 3;
            const max_y = @as(i64, @intCast(x_pos.y)) + dir.y * 3;
            if (max_x >= num_rows or max_y >= num_cols or max_x < 0 or max_y < 0) {
                continue;
            }
            for (0..4) |idx| {
                const x_grid = @as(usize, @intCast(@as(i64, @intCast(x_pos.x)) + dir.x * @as(i64, @intCast(idx))));
                const y_grid = @as(usize, @intCast(@as(i64, @intCast(x_pos.y)) + dir.y * @as(i64, @intCast(idx))));
                if (grid[x_grid][y_grid] == match[idx]) {
                    std.debug.print("Matched {c} with {c}\n", .{ grid[x_grid][y_grid], match[idx] });
                } else {
                    continue :dir;
                }
            }
            std.debug.print("MATCHED XMAS!\n", .{});
            cnt += 1;
        }
    }

    return cnt;
}

fn part2(input: []const u8) !u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var grid: [num_rows][num_cols]u8 = undefined;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var a_positions = try std.ArrayList(Pos).initCapacity(alloc, 140 * 140);
    defer a_positions.deinit();

    var x: usize = 0;
    while (lines.next()) |row| : (x += 1) {
        for (0.., row) |y, cell| {
            grid[x][y] = cell;
            if (cell == 'A') {
                a_positions.appendAssumeCapacity(.{ .x = x, .y = y });
            }
        }
    }

    var cnt: u64 = 0;
    for (a_positions.items) |a_pos| {
        // Check bounds
        if ((a_pos.x == 0 or a_pos.x == num_rows - 1) or
            (a_pos.y == 0 or a_pos.y == num_cols - 1))
        {
            continue;
        }
        // Right Slash
        const r1 = grid[a_pos.x + 1][a_pos.y - 1];
        const r2 = grid[a_pos.x - 1][a_pos.y + 1];
        // Left Slash
        const l1 = grid[a_pos.x - 1][a_pos.y - 1];
        const l2 = grid[a_pos.x + 1][a_pos.y + 1];
        if ((r1 == 'M' and r2 == 'S' or r1 == 'S' and r2 == 'M') and
            (l1 == 'M' and l2 == 'S' or l1 == 'S' and l2 == 'M'))
        {
            cnt += 1;
        }
    }

    cnt += 0;
    return cnt;
}

pub fn main() !void {
    const part1_ans: u64 = try part1(file);
    const part2_ans: u64 = try part2(file);
    std.debug.print("Part 1: {d}\n", .{part1_ans});
    std.debug.print("Part 2: {d}\n", .{part2_ans});
}
