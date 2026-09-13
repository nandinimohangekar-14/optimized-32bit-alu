# ASIC Implementation of Optimized Low-Power High-Speed 32-Bit ALU

## 📌 Project Overview

This project presents the design and ASIC-oriented implementation of an optimized **32-bit Arithmetic Logic Unit (ALU)** focused on improving **speed and power efficiency**.

The proposed ALU integrates arithmetic and logical operations with a **Booth multiplier** and a **barrel shifter**. A shared opcode/control mechanism is used to select the required operation.

> **Note:** This repository contains the project documentation, architecture diagrams, implementation figures, and simulation/waveform results. The original Verilog HDL source files are not included because they are not currently available.

## 🎯 Objectives

- Design an optimized 32-bit ALU architecture.
- Improve arithmetic operation performance using a Booth multiplier.
- Implement efficient shifting using a barrel shifter.
- Reduce unnecessary hardware/resource usage through shared control.
- Verify the proposed design through simulation.
- Study the design from an ASIC implementation perspective.

## 🏗️ Architecture

The major blocks of the proposed design include:

- 32-bit ALU
- Booth multiplier
- Barrel shifter
- Arithmetic and logical operation units
- Opcode/control logic
- Output selection and verification logic

![Architecture / Design](images/image.png)

## 🔢 Booth Multiplier

Booth multiplication is used to perform signed multiplication efficiently by reducing the number of partial products generated during multiplication.

![Booth Multiplier](images/booth_multiplier.png.png)

![Booth Multiplier Implementation](images/booth_multiplier1.png.png)

## ↔️ Barrel Shifter

A barrel shifter provides efficient shifting operations by allowing multiple-bit shifts to be performed through a combinational shifting structure.

![Barrel Shifter](images/barrel_shifter.png.png)

![Barrel Shifter Implementation](images/barrel_shifter1.png.png)

## 🔄 Design Flow

The project follows an RTL-to-ASIC-oriented design and verification flow. The architecture, RTL design, simulation, and implementation-related analysis are documented in the accompanying project material.

![Design Flow](images/flowdiagram.png.jpeg)

## 🧪 Simulation / Verification

The project includes simulation results demonstrating the operation of the designed ALU architecture.

![Simulation Waveform](images/waveform.png.jpeg)

## 📄 Project Documentation

The project paper/documentation is available in the [`docs`](docs/) directory.

- [`main.tex`](docs/main.tex) — LaTeX source of the project document

## 🛠️ Tools & Technologies

- Verilog HDL / RTL design
- Cadence design and verification environment
- ASIC-oriented digital design methodology
- Booth multiplication
- Barrel shifting
- 32-bit ALU architecture

## 📊 Key Focus Areas

| Area | Focus |
|---|---|
| Word size | 32-bit |
| Main block | ALU |
| Multiplication | Booth multiplier |
| Shifting | Barrel shifter |
| Design goal | Low power + high speed |
| Implementation | ASIC-oriented |
| Verification | Simulation / waveform analysis |

## 📁 Repository Structure

```text
optimized-32bit-alu/
├── README.md
├── .gitignore
├── docs/
│   └── main.tex
└── images/
    ├── image.png
    ├── waveform.png.jpeg
    ├── flowdiagram.png.jpeg
    ├── booth_multiplier.png.png
    ├── booth_multiplier1.png.png
    ├── barrel_shifter.png.png
    └── barrel_shifter1.png.png
```

## ⚠️ Source Code Availability

The Verilog RTL and testbench files are **not included in this repository** because the original source files are not currently available to the project authors. The repository is therefore intended as a **project documentation and results repository**, not as a complete reproducible RTL repository.

## 👩‍💻 Project

**Project:** ASIC Implementation of Optimized Low-Power High-Speed 32-Bit ALU

This repository was prepared to document the project architecture, methodology, and results for academic and portfolio purposes.
