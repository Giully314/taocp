//! Define the instructions of MMIX language.

/// An instruction of MMIX is composed of OP and 3 bytes which can be used to refer to one of the 256 register
/// or to construct a number of 2/3 bytes.
/// For example: ADD $X,$Y,$Z means set the register number $X to the sum of registers $Y and $Z.
/// Or: JMP @+4*XYZ means to jump to next instruction by skipping XYZ tetrabytes.
const Instruction = packed struct {
    op: u8,
    x: u8,
    y: u8,
    z: u8,

    // TODO: do we need endianess conversion here?
};

const Op = struct {
    pub fn add(x: u8, y: u8, z: u8) Instruction {
        return .{ .op = 0x20, .x = x, .y = y, .z = z };
    }

    pub fn addi(x: u8, y: u8, z: u8) Instruction {
        return .{ .op = 0x21, .x = x, .y = y, .z = z };
    }

    // ********** LOAD - STORE OP **********
    // The memory address for loading and storing is computed as:
    // A = (u($Y) + u($Z)) mod 2^64
    // For example LDB $X,$Y,$Z
    // s($X) <- s(M_1[A])
    // where u(x) is the unsigned representation of the binary x.
    // s(x) is the signed representation in 2-complement of x.
    // These instructions bring data from memory into register $X, changing the data
    // from a signed byte, wyde, tetra, octa to a signed octabyte of the same value.

    /// Load byte.
    pub fn ldb(x: u8, y: u8, z: u8) Instruction {
        return .{ .op = 0x80, .x = x, .y = y, .z = z };
    }

    pub fn ldbi(x: u8, y: u8, z: u8) Instruction {
        return .{ .op = 0x81, .x = x, .y = y, .z = z };
    }

    /// Load wyde.
    pub fn ldw(x: u8, y: u8, z: u8) Instruction {
        return .{ .op = 0x20, .x = x, .y = y, .z = z };
    }

    /// Load tetra-byte.
    pub fn ldt(x: u8, y: u8, z: u8) Instruction {
        return .{ .op = 20, .x = x, .y = y, .z = z };
    }

    /// Load octa-byte.
    pub fn ldo(x: u8, y: u8, z: u8) Instruction {
        return .{ .op = 20, .x = x, .y = y, .z = z };
    }
};
