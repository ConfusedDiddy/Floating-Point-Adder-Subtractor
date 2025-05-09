# Floating Point Adder/Subtractor in Verilog HDL

## Overview

This repository contains a fully functional IEEE 754 single-precision **Floating Point Adder/Subtractor** implemented in Verilog HDL. The design is modular, and handles a wide range of edge cases, including NaNs, Infinities, and Zero results. This project was inspired by principles and methodologies found in *Computer Arithmetic: Algorithms and Hardware Designs* by Behrooz Parhami.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Modules](#modules)
- [Special Case Handling](#special-case-handling)
- [Verification](#verification)
- [Simulation Results](#simulation-results)
- [References](#references)

---

## Features

- Conforms to IEEE 754 single-precision floating-point format.
- Handles addition and subtraction operations.
- Supports rounding (Round to Nearest Even).
- Detects and handles:
  - NaNs (Quiet NaNs supported)
  - Positive/Negative Infinity
  - Positive/Negative Zero
- Designed with modular structure and pipelined datapath.
- Optimized using a 32-bit Ladner-Fischer Parallel Prefix Adder.

---

## Modules

| Module Name         | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `Unpack`            | Extracts sign, exponent, and significand; detects special cases.            |
| `ExponentSub`       | Compares exponents and determines operand alignment.                        |
| `SCPS`              | Selective Complement and Possible Swap logic for subtraction cases.         |
| `AlignSignificands` | Shifts significands for alignment based on exponent difference.             |
| `CPA`               | Performs binary addition using Ladner-Fischer Adder.                        |
| `Normalize_1`       | Normalizes the result post-addition and prepares for rounding.              |
| `Round`             | Applies rounding based on GRS bits and LSB.                                 |
| `Normalize_2`       | Handles potential overflows caused by rounding.                             |
| `ControlUnit`       | Orchestrates control signals across modules and manages final outputs.      |
| `Pack`              | Reconstructs the IEEE 754 formatted result from sign, exponent, and mantissa. |
| `TopModule`         | Integrates all submodules into a complete floating point adder/subtractor.  |
| `Testbench`         | Includes corner-case validation, golden model comparison, and waveform tracing. |

---

## Special Case Handling

The design robustly handles IEEE 754 special cases, including:

- **NaN**: Propagates Quiet NaNs by forcing MSB of mantissa to 1.
- **Infinity**: Supports operations like `inf + inf`, `inf - inf`, with results per standard.
- **Zero**: Handles signed zero, such as `+0 - +0 = -0`.
- **Overflow and Underflow**: Detected and managed in the normalization and rounding stages.

---

## Verification

The design was thoroughly verified using:

1. **Handwritten Verilog Testbench** with corner cases.
2. **Golden Model** in C++ using type-punning for IEEE 754 comparison.
3. **SystemVerilog Testbench** using `shortreal` to run **1 million test cases**.
4. **Simulation Waveforms** for visual trace of signal transitions.

> ⚠️ **Note**: Subnormal inputs and outputs are not supported in this implementation.

---

## Simulation Results

- **Critical Path Delay** and **Utilization Reports** provided for FPGA synthesis.
- Simulation waveform snapshots and logs available.
- 100% pass rate on supported test cases via SystemVerilog automation.

---

## References

1. B. Parhami, *Computer Arithmetic: Algorithms and Hardware Designs*, 2nd ed., Oxford University Press, 2010.
2. Ahmad Essam AbdelAty, *Final Project Report – Floating Point Adder/Subtractor*, STMicroelectronics Training, 2025.
3. S. Roy, *Advanced Digital System Design: A Practical Guide to Verilog Based FPGA and ASIC Implementation*, Springer, 2023.
4. Instructor Slides by Eng. Ahmed Abdelsalam, STMicroelectronics.

---

## License

This project is released under the MIT License.

---

## Author

**Ahmad Essam AbdelAty**  
Computer Arithmetic Training  
STMicroelectronics  
Date: March 4, 2025
