# 4-Bit Arithmetic Logic Unit (ALU) ⚡

[![HDL - Verilog](https://img.shields.io/badge/HDL-Verilog_2001-blue.svg?style=for-the-badge&logo=microchip)](verilog/)
[![HDL - SystemVerilog](https://img.shields.io/badge/HDL-SystemVerilog_IEEE_1800-00599C.svg?style=for-the-badge&logo=cplusplus)](systemverilog/)
[![Simulator - ModelSim](https://img.shields.io/badge/Simulator-ModelSim_Intel_FPGA_2020.3-orange.svg?style=for-the-badge&logo=intel)](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-technology.html)
[![Verification - Simulation Passed](https://img.shields.io/badge/Verification-ModelSim_Simulated_%E2%9C%94-success.svg?style=for-the-badge)](systemverilog/alu4_tb.sv)
[![License - MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=for-the-badge)](LICENSE)

A dual-implementation **4-Bit Combinational Arithmetic Logic Unit (ALU)** written in **Verilog HDL** and **SystemVerilog**, fully verified and tested using the **Mentor Graphics / Intel FPGA ModelSim simulator**.

---

## 📌 Table of Contents
- [Overview](#-overview)
- [Repository Structure](#-repository-structure)
- [ALU Architecture & Hardware Specs](#-alu-architecture--hardware-specs)
- [Opcode & Functional Truth Table](#-opcode--functional-truth-table)
- [Verilog vs SystemVerilog Comparison](#-verilog-vs-systemverilog-comparison)
- [Simulation Guide (ModelSim)](#-simulation-guide-modelsim)
  - [SystemVerilog Simulation](#1-systemverilog-simulation)
  - [Verilog Simulation](#2-verilog-simulation)
- [Simulation Outputs & Verification Log](#-simulation-outputs--verification-log)
- [Status & Verification Summary](#-status--verification-summary)
- [Future Works & Roadmap](#-future-works--roadmap)
- [Author & License](#-author--license)

---

## 🔍 Overview

The **Arithmetic Logic Unit (ALU)** is the foundational computational core of any CPU / microprocessor. This project implements a **4-bit combinational ALU** capable of computing basic arithmetic operations (addition, subtraction) and logical bitwise operations (AND, OR, XOR), along with dedicated status flags (`carry_borrow` and `zero`).

> **Scope Note:**  
> This repository strictly documents the **RTL design and functional simulation performed using ModelSim**. No physical hardware synthesis or FPGA bitstream generation has been performed yet; those are planned under [Future Works & Roadmap](#-future-works--roadmap).

---

## 📁 Repository Structure

```text
4_bit_ALU/
├── verilog/
│   ├── alu4.v           # 4-bit ALU RTL implementation in Verilog HDL
│   └── alu4_tb.v        # Testbench in Verilog HDL
├── systemverilog/
│   ├── alu4.sv          # 4-bit ALU RTL implementation in SystemVerilog
│   └── alu4_tb.sv       # Testbench in SystemVerilog
├── .gitignore           # Clean exclusion of ModelSim artifacts (work, wlf, transcript, etc.)
└── README.md            # Project documentation & ModelSim simulation guide
```

---

## 📐 ALU Architecture & Hardware Specs

```
                       +-------------------------------+
                       |           4-Bit ALU           |
        A [3:0] =======>                               |
                       |   [3'b000] ADD (with Carry)   |=======> result [3:0]
        B [3:0] =======>   [3'b001] SUB (with Borrow)  |
                       |   [3'b010] Bitwise AND        |-------> carry_borrow
   opcode [2:0] =======>   [3'b011] Bitwise OR         |
                       |   [3'b100] Bitwise XOR        |-------> zero
                       +-------------------------------+
```

### Port List

| Port Name | Direction | Bit Width | Type | Description |
| :--- | :---: | :---: | :---: | :--- |
| `A` | Input | `[3:0]` | Operand | 4-bit first operand |
| `B` | Input | `[3:0]` | Operand | 4-bit second operand |
| `opcode` | Input | `[2:0]` | Control | 3-bit operation selector code |
| `result` | Output | `[3:0]` | Data | 4-bit computational output |
| `carry_borrow` | Output | `1-bit` | Flag | High on addition overflow (Carry) or if $A < B$ in subtraction (Borrow) |
| `zero` | Output | `1-bit` | Flag | High whenever `result == 4'b0000` |

---

## 📊 Opcode & Functional Truth Table

| Opcode (`[2:0]`) | Operation | Expression | Carry / Borrow Flag | Zero Flag |
| :---: | :--- | :--- | :---: | :---: |
| `3'b000` | **ADD** | `result = A + B` | `1` on 4-bit overflow (`temp[4]`) | `1` if `result == 0` |
| `3'b001` | **SUB** | `result = A - B` | `1` if $A < B$ (borrow condition) | `1` if `result == 0` |
| `3'b010` | **AND** | `result = A & B` | `0` | `1` if `result == 0` |
| `3'b011` | **OR** | `result = A \| B` | `0` | `1` if `result == 0` |
| `3'b100` | **XOR** | `result = A ^ B` | `0` | `1` if `result == 0` |
| `default` | **IDLE** | `result = 4'b0000` | `0` | `1` |

---

## ⚖️ Verilog vs SystemVerilog Comparison

<details>
<summary><b>Click to expand the side-by-side HDL comparison</b></summary>

| Feature | Verilog Implementation (`verilog/alu4.v`) | SystemVerilog Implementation (`systemverilog/alu4.sv`) |
| :--- | :--- | :--- |
| **Data Types** | `reg [3:0]` for outputs, `wire` for nets | Universal `logic [3:0]` for all ports and internal signals |
| **Procedural Block** | `always @(*)` (general sensitivity) | `always_comb` (compiler enforces purely combinational logic) |
| **Sensitization Rules** | Manual sensitivity checking | Automatic zero-time activation & sensitivity list generation |
| **Simulator Linter** | Permissive with accidental latches | Stricter static checks, preventing unintentional latches |
| **Testbench Syntax** | `reg` / `wire` separation | Unified `logic`, enhanced simulation formatting |

</details>

---

## 🚀 Simulation Guide (ModelSim)

This project has been tested and verified using **ModelSim - Intel FPGA Edition 2020.3 (`vlog` compiler & `vsim` engine)**.

### 1. SystemVerilog Simulation

<details open>
<summary><b>Run via ModelSim CLI (Command Prompt / PowerShell)</b></summary>

```bash
# Navigate to the systemverilog directory
cd systemverilog

# 1. Compile the SystemVerilog design and testbench
vlog alu4.sv alu4_tb.sv

# 2. Run simulation in batch mode
vsim -c alu4_tb -do "run -all; quit"
```

</details>

<details>
<summary><b>Run via ModelSim GUI</b></summary>

1. Open **ModelSim**.
2. Set Directory: `File -> Change Directory...` -> Select `systemverilog/`.
3. Create/Use work library: `vlib work` (if needed).
4. Compile: `Compile -> Compile...` -> Select both `alu4.sv` and `alu4_tb.sv` -> Click **Compile**.
5. Start Simulation: `Simulate -> Start Simulation...` -> Expand `work` -> Select `alu4_tb` -> Click **OK**.
6. View Waveforms: Add signals to wave via `add wave -r /*`.
7. Execute: In transcript, type `run -all`.

</details>

---

### 2. Verilog Simulation

<details open>
<summary><b>Run via ModelSim CLI (Command Prompt / PowerShell)</b></summary>

```bash
# Navigate to the verilog directory
cd verilog

# 1. Compile the Verilog design and testbench
vlog alu4.v alu4_tb.v

# 2. Run simulation in batch mode
vsim -c alu4_tb -do "run -all; quit"
```

</details>

---

## 📈 Simulation Outputs & Verification Log

Below are the actual simulation transcripts captured directly from ModelSim simulation runs:

### SystemVerilog Simulation Output (`alu4_tb.sv`)

```text
# Loading sv_std.std
# Loading work.alu4_tb
# Loading work.alu4
# run -all
# ==============================================
#        4-BIT ALU SYSTEMVERILOG SIMULATION
# ==============================================
# Time=0     | A=0101 | B=0011 | OP=000 | RESULT=1000 | C/B=0 | ZERO=0   (5 + 3 = 8)
# Time=20000 | A=1111 | B=0001 | OP=000 | RESULT=0000 | C/B=1 | ZERO=1   (15 + 1 = 16 -> Overflow Carry=1, Zero=1)
# Time=40000 | A=0101 | B=0011 | OP=001 | RESULT=0010 | C/B=0 | ZERO=0   (5 - 3 = 2)
# Time=60000 | A=0011 | B=0101 | OP=001 | RESULT=1110 | C/B=1 | ZERO=0   (3 - 5 = -2 -> Borrow=1)
# Time=80000 | A=0101 | B=0011 | OP=010 | RESULT=0001 | C/B=0 | ZERO=0   (5 & 3 = 1)
# Time=100000| A=0101 | B=0011 | OP=011 | RESULT=0111 | C/B=0 | ZERO=0   (5 | 3 = 7)
# Time=120000| A=0101 | B=0011 | OP=100 | RESULT=0110 | C/B=0 | ZERO=0   (5 ^ 3 = 6)
# Time=140000| A=0101 | B=0101 | OP=001 | RESULT=0000 | C/B=0 | ZERO=1   (5 - 5 = 0 -> Zero=1)
# ==============================================
#        SIMULATION COMPLETED
# ==============================================
# ** Note: $finish    : alu4_tb.sv(86)
```

### Verilog Simulation Output (`alu4_tb.v`)

```text
# Loading work.alu4_tb
# Loading work.alu4
# run -all
# ==============================================
#         4-BIT ALU SIMULATION
# ==============================================
# Time   A     B     OP      Result   Carry/Borrow Zero
# ------------------------------------------------------
#    0   0101   0011    000      1000          0        0
# 20000   1111   0001    000      0000          1        1
# 40000   0101   0011    001      0010          0        0
# 60000   0011   0101    001      1110          1        0
# 80000   0101   0011    010      0001          0        0
# 100000   0101   0011    011      0111          0        0
# 120000   0101   0011    100      0110          0        0
# 140000   0101   0101    001      0000          0        1
# ==============================================
#         SIMULATION COMPLETED
# ==============================================
```

---

## ✅ Status & Verification Summary

### What Has Been Completed & Verified:
- [x] **4-Bit Combinational ALU RTL**: Implemented in Verilog (`alu4.v`) and SystemVerilog (`alu4.sv`).
- [x] **Arithmetic Operations**: ADD with carry detection and SUB with borrow detection.
- [x] **Bitwise Logical Operations**: AND, OR, XOR.
- [x] **Status Flags**: Verified `carry_borrow` and `zero` generation.
- [x] **Automated Testbenches**: Created test vectors in `alu4_tb.v` and `alu4_tb.sv`.
- [x] **ModelSim Compilation & Execution**: Compiled with `vlog` and run with `vsim` (Zero errors, Zero warnings).
- [x] **Clean Repository Config**: `.gitignore` configured to ignore temporary ModelSim artifacts (`work/`, `vsim.wlf`, `transcript`, etc.).

---

## 🔮 Future Works & Roadmap

The following enhancements are planned for future development milestones:

- [ ] **FPGA Hardware Deployment**: Pin constraints assignment (`.qsf` / `.xdc`) and synthesis on an FPGA board (Intel DE10-Lite / Cyclone IV or Xilinx Basys 3).
- [ ] **Sequential & Registered ALU**: Add clock, reset, and accumulator register for synchronous pipeline stages.
- [ ] **Arithmetic Extension**: Implement multiplication, division, arithmetic shift right (ASR), and logical shifts (LSL/LSR).
- [ ] **Parametric Bit-Width**: Parameterize operand width `[N-1:0]` (e.g. 8-bit, 16-bit, 32-bit configurable ALU).
- [ ] **UVM Testbench**: Implement a Universal Verification Methodology (UVM) environment with constrained-random stimulus and functional coverage metrics.
- [ ] **CI Automation**: Setup GitHub Actions workflow with open-source EDA tools (Icarus Verilog + GTKWave / Verilator) for automatic pull-request verification.

---

## 👤 Author & License

- **Author**: Mugilan ([@mugilansp30](https://github.com/mugilansp30))
- **Repository**: [https://github.com/mugilansp30/4_bit_ALU.git](https://github.com/mugilansp30/4_bit_ALU.git)
- **License**: Released under the [MIT License](LICENSE).
