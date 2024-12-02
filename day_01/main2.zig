const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn main() !void {
    const input = @embedFile("input.txt");
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    //    var it = std.mem.tokenizeAny(u8, input, "\n");
    var list1 = ArrayList(u32).init(alloc);
    defer list1.deinit();
    var list2 = ArrayList(u32).init(alloc);
    defer list2.deinit();

    var readIter = std.mem.tokenize(u8, input, "\n");
    while (readIter.next()) |line| {
        const leftNum = try std.fmt.parseInt(u32, line[0..5], 10);
        const rightNum = try std.fmt.parseInt(u32, line[8..], 10);
        try list1.append(leftNum);
        try list2.append(rightNum);
    }

    std.sort.block(u32, list1.items, {}, std.sort.asc(u32));
    std.sort.block(u32, list2.items, {}, std.sort.asc(u32));

    //std.debug.print("List 1: {s}\n", list1.items);
    var total: u32 = 0;
    for (list1.items, list2.items) |left, right| {
        //d.debug.print("Left: {d} Right: {d} \n", .{ left, right });
        const diff = if (left > right) left - right else right - left;
        total += diff;
    }
    print("Total: {d}\n", .{total});

    var simScore: u32 = 0;
    for (list1.items) |left| {
        var occurs: u32 = 0;
        for (list2.items) |right| {
            if (left == right) occurs += 1;
        }
        simScore += left * occurs;
    }
    print("Total Similarity Score: {d}\n", .{simScore});
}
