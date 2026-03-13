# PUnC

**PUnC (Princeton University Computer)** is a simplified LC-3–style processor implemented in **Verilog**.  
The project demonstrates the design of a small instruction-set processor using a **datapath + control architecture**, along with supporting tools such as an assembler and example assembly programs.

This repository contains the full hardware design, ISA documentation, and utilities for assembling and testing programs.

---

## Description

PUnC is an educational processor designed to illustrate core computer architecture concepts such as:

- instruction set architecture (ISA)
- datapath design
- control logic and finite state machines
- register files and memory interaction
- assembly-level programming

The processor executes programs written in a simplified **LC-3 inspired instruction set**. Assembly programs are assembled into machine code and executed through the Verilog implementation of the processor.

The system is implemented in a modular way, separating the processor into independent hardware components including the **control unit, datapath, register file, and memory system**.

---

## Features

- Verilog implementation of a simplified processor
- Modular **datapath + control** architecture
- Register file and memory modules
- LC-3 inspired instruction set
- Assembly program support
- Processor simulation through Verilog testbenches
- Design documentation and control signal references

---

## Project Structure

```
PUnC/

PUnC.v              # Top-level processor module
PUnCControl.v       # Control FSM generating control signals
PUnCDatapath.v      # Datapath containing ALU and data routing

RegisterFile.v      # General-purpose register storage
Memory.v            # Instruction/data memory module

Defines.v           # Shared definitions and constants

PUnC.t.v            # Processor testbench

assembler/          # Assembly tools
SIPP/               # Processor design documentation
images/             # Diagrams and architecture visuals

LC3ISA.pdf          # Instruction set documentation
ver1.asm            # Example assembly program
```

---

## Architecture

The processor follows a classic **datapath and control architecture** commonly used in hardware systems.

### Control Unit

The control module implements a **finite state machine (FSM)** that:

- decodes instructions
- generates control signals
- sequences instruction execution stages

File: `PUnCControl.v`

### Datapath

The datapath performs computation and data movement between processor components.

Key elements include:

- ALU operations
- register reads and writes
- memory access
- multiplexers and data routing

File: `PUnCDatapath.v`

---

## Key Concepts Demonstrated

This project demonstrates several core concepts in computer architecture and hardware design:

- processor datapath design
- hardware finite state machines
- register-transfer level (RTL) design in Verilog
- instruction decoding and control signal generation
- interaction between memory, registers, and ALU
- execution of assembly programs on custom hardware

---

## Author

**Lucy Park**  
Princeton University  
Electrical and Computer Engineering
