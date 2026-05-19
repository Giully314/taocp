//! This module implements a virtual machine for MMIX ISA as described in TAOCP volume 1 and the supplement.
//! The ISA is a RISC with big endian.

const std = @import("std");
const mmix_instructions = @import("mmix_instructions.zig");

/// The register class stores the value of a single register and allows correct conversion from value to bytes.
/// This is required because the host machine of the vm is little endian while mmix operates in big endian.
const Register = struct {
    value: u64,

    pub fn toBytes(self: Register) [8]u8 {
        var bytes: [8]u8 = undefined;
        std.mem.writeInt(u64, &bytes, self.value, .big);
        return bytes;
    }

    pub fn fromBytes(bytes: [8]u8) Register {
        return .{ .value = std.mem.readInt(u64, &bytes, .big) };
    }

    pub fn signed(self: Register) i64 {
        return @bitCast(self.value);
    }

    pub fn setFromSigned(v: i64) Register {
        return .{ .value = @bitCast(v) };
    }
};

/// Represent a machine which can execute MMIX instructions.
const VM = struct {
    registers: [256]Register = .{Register{ .value = 0 }} ** 256,
    instructions: std.ArrayList(mmix_instructions.Instruction),

    // Note: access to the memory M_t[x] requires to ignore the lg(t) least significan bits of x,
    // to access the aligned memory based on the word size.
};
