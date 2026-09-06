# RISC-V RV32I Single-Cycle CPU

A **32-bit RISC-V RV32I Single-Cycle CPU** designed and implemented from scratch using **Verilog HDL**. The processor implements the **complete RV32I base integer instruction set** and features a modular datapath and control architecture for instruction fetch, decode, execution, memory access, and write-back within a single clock cycle.

This project demonstrates practical understanding of **computer architecture, RISC-V ISA, RTL design, digital logic, and processor datapath/control implementation**.

---

## 🚀 Features

* **32-bit RV32I RISC-V processor**
* Complete **RV32I base integer instruction set**
* Single-cycle processor architecture
* Modular Verilog RTL implementation
* 32 × 32-bit general-purpose register file
* RISC-V `x0` register hardwired to zero
* ALU supporting arithmetic, logical, comparison, and shift operations
* Immediate generation for all RV32I instruction formats
* Instruction memory
* Data memory
* Branch and jump handling
* Load/store support
* Separate datapath and control logic
* Simulation-based functional verification

---

## 🏗️ Architecture

The CPU follows a conventional single-cycle RISC-V datapath:

```text
                         ┌──────────────────┐
                         │ Program Counter  │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │ Instruction      │
                         │ Memory           │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │ Instruction      │
                         │ Decode / Control │
                         └────────┬─────────┘
                                  │
                 ┌────────────────┼────────────────┐
                 │                │                │
                 ▼                ▼                ▼
          ┌────────────┐  ┌──────────────┐  ┌────────────┐
          │ Register   │  │  Immediate   │  │    ALU     │
          │    File    │  │  Generator   │  │            │
          └─────┬──────┘  └──────────────┘  └─────┬──────┘
                │                                 │
                │                                 ▼
                │                         ┌────────────────┐
                │                         │   Data Memory  │
                │                         └───────┬────────┘
                │                                 │
                └────────────────┬────────────────┘
                                 ▼
                         ┌──────────────────┐
                         │   Write Back     │
                         │     MUX          │
                         └────────┬─────────┘
                                  │
                                  ▼
                            Register File
```

Because this is a **single-cycle architecture**, each instruction completes its complete execution path within one clock cycle.

---

## 📚 RV32I Instruction Set

The processor implements the **complete RV32I base integer ISA**, covering all major RV32I instruction formats.

### R-Type — Register-Register Operations

```text
ADD    SUB
SLL    SLT    SLTU
XOR    SRL    SRA
OR     AND
```

### I-Type — Immediate Arithmetic & Logical Operations

```text
ADDI
SLTI
SLTIU
XORI
ORI
ANDI
SLLI
SRLI
SRAI
```

### Load Instructions

```text
LB
LH
LW
LBU
LHU
```

### Store Instructions

```text
SB
SH
SW
```

### Branch Instructions

```text
BEQ
BNE
BLT
BGE
BLTU
BGEU
```

### Upper Immediate Instructions

```text
LUI
AUIPC
```

### Jump Instructions

```text
JAL
JALR
```

Together, these instructions constitute the **complete RV32I base integer instruction set**.

---

## 🔄 Instruction Execution

Each instruction passes through the required operations during a single clock cycle.

### 1. Instruction Fetch

The **Program Counter (PC)** supplies the address of the instruction to the instruction memory.

### 2. Instruction Decode

The instruction fields are decoded to determine:

* Opcode
* Source registers (`rs1`, `rs2`)
* Destination register (`rd`)
* Immediate value
* Instruction type

The control unit generates the required control signals.

### 3. Execute

The ALU performs the required operation, including:

* Addition/subtraction
* Logical operations
* Comparisons
* Shift operations
* Address calculation
* Branch comparisons

### 4. Memory Access

Load and store instructions interact with the data memory.

The implementation supports different access widths required by RV32I, including:

* Byte
* Half-word
* Word

and handles signed/unsigned loads appropriately.

### 5. Write Back

Depending on the instruction, the result written to the register file can originate from:

* ALU result
* Data memory
* PC-related computation

### 6. PC Update

The next PC is selected according to the instruction:

```text
PC + 4
Branch Target
JAL Target
JALR Target
```

---

## 🧩 Main RTL Components

| Module                  | Function                                                       |
| ----------------------- | -------------------------------------------------------------- |
| **Program Counter**     | Stores and updates the current instruction address             |
| **Instruction Memory**  | Stores and provides instructions                               |
| **Register File**       | Implements 32 general-purpose 32-bit registers                 |
| **ALU**                 | Performs arithmetic, logical, comparison, and shift operations |
| **Immediate Generator** | Generates immediates for I, S, B, U, and J formats             |
| **Control Unit**        | Generates instruction-dependent control signals                |
| **Data Memory**         | Handles load and store operations                              |
| **Branch / Jump Logic** | Determines control-flow targets                                |
| **Multiplexers**        | Select appropriate datapath inputs and outputs                 |
| **PC Logic**            | Calculates and selects the next program counter value          |

---

## 🧠 RISC-V Instruction Formats

The immediate generation and decoding logic support all RV32I instruction formats:

```text
R-Type
I-Type
S-Type
B-Type
U-Type
J-Type
```

The processor correctly extracts and sign-extends immediate fields according to the corresponding instruction format.

---

## 🧪 Verification

The processor was verified through **RTL simulation and testbench-based instruction execution**.

Verification covered:

* Arithmetic instructions
* Logical instructions
* Shift operations
* Signed and unsigned comparisons
* Immediate instructions
* Load/store instructions
* Byte, half-word, and word accesses
* Signed and unsigned loads
* Conditional branches
* Unconditional jumps
* Register-indirect jumps
* Upper-immediate instructions
* PC-relative addressing
* Register write-back
* Program counter updates

Simulation waveforms were inspected to verify the interaction between the major datapath and control signals.

---

## 🛠️ Tools & Technologies

* **Verilog HDL**
* **RISC-V RV32I ISA**
* RTL Design
* Digital Logic Design
* Computer Architecture
* CPU Datapath Design
* Control Logic Design
* Functional Simulation
* Testbench Development
* Waveform Analysis

---
## 👨‍💻 Project Summary

**RISC-V RV32I Single-Cycle CPU**

A complete **RV32I processor implemented from scratch in Verilog**, covering the full base integer instruction set and integrating instruction fetch, decode, execution, memory access, write-back, and control-flow logic into a functional single-cycle CPU.

This project serves as a practical implementation of the concepts learned in **digital design, computer architecture, and RTL-based hardware development**.
