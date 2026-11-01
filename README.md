# 4-Bit Arithmetic Logic Unit (ALU) in Verilog

A 4-bit Arithmetic Logic Unit (ALU) design implemented in Verilog HDL with a comprehensive testbench for simulation in ModelSim / QuestaSim.

## Features

- **Data Width**: 4-bit operands (`A`, `B`) and 4-bit `result`.
- **Status Flags**:
  - `carry_borrow`: Indicates carry-out during addition or borrow during subtraction ($A < B$).
  - `zero`: Set to `1` when the operation result is `4'b0000`.
- **Supported Operations**:
  - Arithmetic: Addition (`ADD`), Subtraction (`SUB`)
  - Logical: Bitwise `AND`, `OR`, `XOR`

## Operation Table

| Opcode (`opcode[2:0]`) | Operation | Description | Flags Affected |
| :---: | :---: | :--- | :--- |
| `000` | **ADD** | `result = A + B` | Carry-out (`temp[4]`), Zero |
| `001` | **SUB** | `result = A - B` | Borrow (`A < B`), Zero |
| `010` | **AND** | `result = A & B` | Zero |
| `011` | **OR**  | `result = A | B` | Zero |
| `100` | **XOR** | `result = A ^ B` | Zero |
| `Others` | **DEFAULT** | `result = 0` | Zero = 1 |

## Pin Configuration

| Port | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `A` | Input | 4 | First operand |
| `B` | Input | 4 | Second operand |
| `opcode` | Input | 3 | Operation select code |
| `result` | Output | 4 | 4-bit ALU output |
| `carry_borrow` | Output | 1 | Carry out or borrow flag |
| `zero` | Output | 1 | High when `result == 4'b0000` |

## Project Structure

```
├── alu4.v         # Verilog module for the 4-bit ALU
├── alu4_tb.v      # Testbench verifying all operations and flags
├── .gitignore     # Git ignore rules for ModelSim simulation files
└── README.md      # Documentation
```

## How to Run in ModelSim

1. Open ModelSim and create a new project or change directory to the project folder:
   ```tcl
   cd <path-to-folder>
   ```
2. Create work library and compile files:
   ```tcl
   vlib work
   vlog alu4.v alu4_tb.v
   ```
3. Run simulation:
   ```tcl
   vsim work.alu4_tb
   run -all
   ```
