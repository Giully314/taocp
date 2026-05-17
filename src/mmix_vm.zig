//! This module implements a virtual machine for MMIX ISA as described in TAOCP volume 1 and the supplement.
//! The ISA is a RISC with big endian.

const std = @import("std");

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

/// An instruction of MMIX is composed of OP and 3 bytes which can be used to refer to one of the 256 register
/// or to construct a number of 2/3 bytes.
/// For example: ADD $X,$Y,$Z means set the register number $X to the sum of registers $Y and $Z.
/// Or: JMP @+4*XYZ means to jump to next instruction by skipping XYZ tetrabytes.
const Instruction = packed struct {
    op: u8,
    x: u8,
    y: u8,
    z: u8,
};

/// Represent a machine which can execute MMIX instructions.
const VM = struct {
    registers: [256]Register = .{Register{ .value = 0 }} ** 256,
    instructions: std.ArrayList(Instruction),
};
