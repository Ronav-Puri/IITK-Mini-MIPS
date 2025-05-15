# IITK-Mini-MIPS
A mini project, part of the course CS220: Introduction to Computer Organization, during my fourth semester at IITK.

**Group No.:** 19  
**Group Members:** Ronav Puri (230815), Marisha Thorat (230637)

---

## PDS1: Decide the registers and their usage protocol

We have decided to keep the same usage protocol of the registers as in the MIPS ISA.

| Register Number | Register Function     | Register Number | Register Function        |
|------------------|------------------------|------------------|----------------------------|
| 0                | $zero                 | 26 - 27          | $k0 - $k1                  |
| 1                | $at                   | 28               | $gp                        |
| 2 - 3            | $v0 - $v1             | 29               | $sp                        |
| 4 - 7            | $a0 - $a3             | 30               | $fp                        |
| 8 - 15           | $t0 - $t7             | 31               | $ra                        |
| 16 - 23          | $s0 - $s7             |                  |                            |
| 24 - 25          | $t8 - $t9             | Floating point   | $f0 - $f31                 |

---

## PDS2: Decide upon the size for instruction and data memory

We have decided to keep both instruction memory and data memory to be of 512 words each. Hence, the size of both memories is `512 × 32 bits`.

---

## PDS3: Instruction Layout Design and Encoding Methodologies

- **R-type:** `00 (2 bits)` - `opcode (5 bits)` - `rs (5 bits)` - `rt (5 bits)` - `rd (5 bits)` - `shamt (10 bits)`  
- **I-type:** `01 (2 bits)` - `opcode (5 bits)` - `rs (5 bits)` - `rt (5 bits)` - `immediate (15 bits)`  
- **J-type:** `10 (2 bits)` - `opcode (1 bit)` - `address (29 bits)`  
- **FP-type:** `11 (2 bits)` - `opcode (4 bits)` - `r0 (5 bits)` - `f0 (5 bits)` - `f1 (5 bits)` - `f2 (5 bits)` - `cc (5 bits)` - `(1 bit)`

---

## Opcodes and Operations

### R-type Instructions (Prefix: 00)

| Opcode | Instruction     | Description                      |
|--------|------------------|----------------------------------|
| 0      | add r0, r1, r2   | Integer addition                 |
| 1      | sub r0, r1, r2   | Integer subtraction              |
| 2      | addu r0, r1, r2  | Unsigned addition                |
| 3      | subu r0, r1, r2  | Unsigned subtraction             |
| 4      | madd r0, r1      | Multiply & add with HI/LO        |
| 5      | maddu r0, r1     | Unsigned version of madd         |
| 6      | mul r0, r1       | Multiply, result split into HI/LO|
| 7      | and r0, r1, r2   | Bitwise AND                      |
| 8      | or r0, r1, r2    | Bitwise OR                       |
| 9      | not r0, r1       | Bitwise NOT                      |
| 10     | xor r0, r1, r2   | Bitwise XOR                      |
| 11     | sll r0, r1, 10   | Shift left logical               |
| 12     | srl r0, r1, 10   | Shift right logical              |
| 13     | sla r0, r1, 10   | Arithmetic shift left            |
| 14     | sra r0, r1, 10   | Shift right arithmetic           |
| 15     | jr r0            | Jump to address in register      |
| 16     | slt r0, r1, r2   | Set if less than                 |

---

### I-type Instructions (Prefix: 01)

| Opcode | Instruction         | Description                    |
|--------|----------------------|--------------------------------|
| 1      | addi r0, r1, 1000    | Add immediate                  |
| 2      | addiu r0, r1, 1000   | Unsigned add immediate         |
| 3      | andi r0, r1, 1000    | AND immediate                  |
| 4      | ori r0, r1, 1000     | OR immediate                   |
| 5      | xori r0, r1, 1000    | XOR immediate                  |
| 6      | slti r0, r1, 100     | Set less than immediate        |
| 7      | seq r0, r1, 100      | Set equal                      |
| 8      | lw r0, 10(r1)        | Load word                      |
| 9      | sw r0, 10(r1)        | Store word                     |
| 10     | lui r0, 1000         | Load upper immediate           |
| 11     | beq r0, r1, 10       | Branch if equal                |
| 12     | bne r0, r1, 10       | Branch if not equal            |
| 13     | bgt r0, r1, 10       | Branch if greater than         |
| 14     | bgte r0, r1, 10      | Branch if greater or equal     |
| 15     | ble r0, r1, 10       | Branch if less than            |
| 16     | bleq r0, r1, 10      | Branch if less or equal        |
| 17     | bleu r0, r1, 10      | Branch if less or equal (unsig)|
| 18     | bgtu r0, r1, 10      | Branch if greater than (unsig) |

---

### J-type Instructions (Prefix: 10)

| Opcode | Instruction | Description                       |
|--------|-------------|-----------------------------------|
| 1      | j 10        | Jump to address 10                |
| 2      | jal 10      | Jump and link (store return addr) |

---

### Floating Point (FP) Instructions (Prefix: 11)

| Opcode | Instruction          | Comment                          |
|--------|----------------------|----------------------------------|
| 1      | mfcl r0, f0          | r0 = f0                          |
| 2      | mtcl r0, f0          | f0 = r0                          |
| 3      | add.s f0, f1, f2     | f0 = f1 + f2                     |
| 4      | sub.s f0, f1, f2     | f0 = f1 - f2                     |
| 5      | c.eq.s cc f0, f1     | cc = 1 if f0 == f1               |
| 6      | c.le.s cc f0, f1     | cc = 1 if f0 <= f1               |
| 7      | c.lt.s cc f0, f1     | cc = 1 if f0 < f1                |
| 8      | c.ge.s cc f0, f1     | cc = 1 if f0 >= f1               |
| 9      | c.gt.s cc f0, f1     | cc = 1 if f0 > f1                |
| 10     | mov.s f0, f1         | f0 = f1                          |

---

## Files Contained

- `test_module.v` – Testbench for running the complete processor  
- `cpu.v` – Top-level module integrating all components  
- `memory_wrapper.v` – Xilinx memory IP instantiation (instruction + data memory)  
- `pc.v` – Handles program counter incrementation  
- `decode.v` – Decodes and extracts parameters from instructions  
- `regfile.v` – General-purpose register file  
- `fp_regfile.v` – Floating-point register file  
- `alu.v` – Integer ALU  
- `fpu.v` – Floating-point ALU  
- `control.v` – Control unit of the processor  
- `dist_mem_gen_0.xci` – Xilinx memory IP (dual-port RAM) implementation

---
