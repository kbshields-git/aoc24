const std = @import("std");
const print = std.debug.print;

const rules = @embedFile("rules.txt");
const input = @embedFile("input.txt");

const Rule = struct {
    pre: u64,
    post: u64,
};

fn part1(ruleList: []const u8, inputList: []const u8) !i64 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    const ruleFile = try std.fs.cwd().statFile("day_05/rules.txt");
    const ruleSize = ruleFile.size;
    var ruleTable = try std.ArrayList(Rule).initCapacity(alloc, ruleSize);

    var ruleIter = std.mem.splitScalar(u8, ruleList, '\n');
    // var inputIter = std.mem.splitScalar(u8, inputList, '\n');
    _ = std.mem.splitScalar(u8, inputList, '\n');

    while (ruleIter.next()) |rule| {
        std.debug.print("Rule: {any}    ", .{rule});
        const left = try std.fmt.parseInt(u32, rule[0..1], 10);
        const right = try std.fmt.parseInt(u32, rule[3..4], 10);
        ruleTable.appendAssumeCapacity(.{ .pre = left, .post = right });

        print("pre: {d} post: {d}\n", .{ left, right });
    }
    return 0;
}

pub fn main() !void {
    const answer1 = try part1(rules, input);
    std.debug.print("Part 1: {d} \n", .{answer1});
}
