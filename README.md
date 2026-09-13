# ASIC Implementation of Low Power, High Speed ALU
## Using Booth Multiplier and Barrel Shifter

**Minor Project Review IV | KLE Technological University**

---

## 📋 Project Overview

This project presents the design and ASIC implementation of an optimized 32-bit Arithmetic Logic Unit (ALU) integrated with:
- **Booth Multiplier (Radix-2)** - for high-speed 32×32 multiplication
- **Barrel Shifter (5-stage MUX)** - for single-cycle shift operations
- **Shared Opcode Mechanism** - 3-bit selector + op_switch for efficient operation routing

### Key Achievements:
✅ 8 supported operations (ADD, SUB, AND, OR, XOR, NOT, SHIFT, MULTIPLY)
✅ 77% shift speedup (2.84ns → 0.66ns)
✅ 50% reduction in multiplier partial products
✅ 87.5% shift energy reduction (23.14pJ → 3.12pJ)
✅ 100% functional verification in Cadence SimVision

---

## 📁 Repository Structure

```
ALU-ASIC-Implementation/
│
├── README.md                    # This file
├── ALU_32bit.v                  # Top-level ALU module
├── barrel_shifter.v             # Barrel Shifter implementation
├── booth_multiplier.v           # Booth Multiplier implementation
├── tb_alu_32bit.v              # Testbench (8 test cases)
│
├── docs/
│   ├── ALU_Report_Extended.tex        # Full IEEE format report
│   ├── ALU_Comparison_Analysis.tex    # Comparison of 4 variants
│   ├── Comparison_Tables.tex          # Detailed comparison tables
│   └── Design_Specifications.txt      # Technical specifications
│
├── simulations/
│   ├── waveform_new.jpg         # Cadence SimVision waveforms
│   ├── synthesis_report.txt     # Cadence Genus synthesis results
│   └── power_analysis.txt       # Cadence Power Compiler results
│
└── presentations/
    ├── ALU_ReviewIV_Complete_Final.pptx
    └── Design_Comparison_Analysis.pptx
```

---

## 🔧 Module Descriptions

### **1. ALU_32bit.v (Top-Level Module)**

The main ALU module that integrates all sub-modules and implements operation selection.

**Ports:**
```verilog
input  [31:0] A              // 32-bit Operand A
input  [31:0] B              // 32-bit Operand B
input  [2:0]  sel            // 3-bit Operation Selector
input         op_switch      // SHIFT/MULTIPLY Selector
input  [4:0]  shamt          // 5-bit Shift Amount (0-31)
input  [1:0]  shift_mode     // Shift Mode (00=LSL, 01=LSR, 10=ASR)
output [31:0] Y              // 32-bit Result
output        carry          // Carry Flag
```

**Operation Mapping:**
| sel[2:0] | op_switch | Operation |
|----------|-----------|-----------|
| 000      | —         | ADD       |
| 001      | —         | SUB       |
| 010      | —         | AND       |
| 011      | —         | OR        |
| 100      | —         | XOR       |
| 101      | 0         | SHIFT     |
| 101      | 1         | MULTIPLY  |
| 110      | —         | NOT       |

---

### **2. barrel_shifter.v**

5-stage parallel multiplexer-based Barrel Shifter achieving single-cycle shift operations.

**Features:**
- ✓ Single-cycle execution for any shift (0-31 positions)
- ✓ Supports LSL (Logical Shift Left)
- ✓ Supports LSR (Logical Shift Right)  
- ✓ Supports ASR (Arithmetic Shift Right)
- ✓ Propagation delay: 0.66ns (77% faster than sequential shifter)

**Example:**
```verilog
A = 32'd8
shamt = 5'b00010    // Shift by 2 positions
shift_mode = 2'b00  // LSL
Y = 32'd32          // 8 << 2 = 32 ✓
```

---

### **3. booth_multiplier.v**

High-speed 32×32 multiplier using Radix-2 Booth encoding.

**Features:**
- ✓ Reduces partial products from 32 to 16 (50% reduction)
- ✓ Delay: 2.42ns for 32×32 multiplication
- ✓ Energy: 31.45pJ per operation
- ✓ Automatic synthesis by Cadence tools

**Booth Encoding Principle:**
- Examines multiplier in 2-bit overlapping groups
- Generates control signals: 0×A, ±A, ±2×A
- Results in fewer partial products and faster accumulation

**Example:**
```verilog
A = 32'd6           // Multiplicand
B = 32'd7           // Multiplier
Y = 32'd42          // 6 × 7 = 42 ✓
```

---

### **4. tb_alu_32bit.v (Testbench)**

Comprehensive testbench with 8 test cases covering all operations.

**Test Cases:**
| # | Time | Operation | A | B | Expected | Result |
|---|------|-----------|---|---|----------|--------|
| 1 | 0-10ns | ADD | 7 | 12 | 19 | ✓ |
| 2 | 10-20ns | SUB | 20 | 5 | 15 | ✓ |
| 3 | 20-30ns | AND | 12 | 10 | 8 | ✓ |
| 4 | 30-40ns | OR | 8 | 3 | 11 | ✓ |
| 5 | 40-50ns | XOR | 9 | 5 | 12 | ✓ |
| 6 | 50-60ns | SHIFT | 8 | - | 32 | ✓ |
| 7 | 60-70ns | MULTIPLY | 6 | 7 | 42 | ✓ |
| 8 | 70-80ns | NOT | 8 | - | FFFFFFF7 | ✓ |

---

## 🚀 How to Use

### **Simulation with Cadence**

```bash
# 1. Compile all Verilog files
ncverilog ALU_32bit.v barrel_shifter.v booth_multiplier.v tb_alu_32bit.v

# 2. Run simulation
# Simulation runs for 80ns with waveforms saved to VCD file

# 3. View waveforms in SimVision
simvision <vcd_file>
```

### **Synthesis with Cadence Genus**

```bash
# 1. Read Verilog files
read_hdl -rtl ALU_32bit.v barrel_shifter.v booth_multiplier.v

# 2. Elaborate design
elaborate ALU_32bit

# 3. Set constraints
set_constraint -scenario "typical" -library tsmc18_1.0

# 4. Synthesize
syn_map
syn_opt

# 5. Generate reports
report_area > area_report.txt
report_power > power_report.txt
report_timing > timing_report.txt

# 6. Write netlist
write_hdl > alu_netlist.v
```

### **Power Analysis with Cadence Power Compiler**

```bash
# 1. Read synthesized netlist and SDFs
read_design alu_netlist.v

# 2. Read activity file (VCD from simulation)
read_activity tb_activity.vcd

# 3. Perform power analysis
analyze_power

# 4. Generate power report
report_power > power_analysis.txt
```

---

## 📊 Performance Results

### **Synthesis Results (180nm CMOS)**

| Metric | Normal ALU | +Booth | +Barrel | **+Both (Proposed)** |
|--------|-----------|--------|---------|-----|
| **Cell Count** | 1,638 | 2,869 | 3,573 | **3,985** |
| **Area (μm²)** | 52,451 | 67,619 | 92,243 | **96,243** |
| **Power (nW)** | 14.14 | 19.76 | 31.49 | **36.48** |
| **Shift Delay** | 2.84ns | 2.85ns | 0.65ns | **0.66ns** |
| **Multiply** | — | 2.41ns | — | **2.42ns** |
| **Operations** | 6 | 7 | 7 | **8** |

### **Energy Efficiency**

| Operation | Normal ALU | +Booth | +Barrel | **+Both** | Reduction |
|-----------|-----------|--------|---------|--------|-----------|
| **SHIFT** | 23.14pJ | 23.45pJ | 2.89pJ | **3.12pJ** | **-87.5%** |
| **MULTIPLY** | — | 29.87pJ | — | **31.45pJ** | — |
| **ADD** | 12.67pJ | 18.03pJ | 28.09pJ | **33.38pJ** | — |

---

## 🎯 Comparison: Why +Both (Proposed) is Best

### **Normal ALU Issues:**
- ❌ Cannot multiply (no capability)
- ❌ Slow shift (2.84ns, sequential)
- ✓ Minimal area/power

### **+Booth Only Issues:**
- ✓ Fast multiply (2.41ns)
- ❌ No fast shift (still 2.85ns)
- ✓ Good for multiply-heavy workloads

### **+Barrel Only Issues:**
- ✓ Fast shift (0.65ns)
- ❌ No multiply support
- ✓ Good for shift-heavy workloads

### **+Both (PROPOSED) - BEST:**
- ✓✓✓ **Fast multiply (2.42ns)**
- ✓✓✓ **Fast shift (0.66ns)**
- ✓✓✓ **All 8 operations supported**
- ✓✓✓ **Matches RISC-V, ARM, x86 requirements**
- ✓✓✓ **Only 7.7% extra area vs Barrel-only**

---

## 📈 Key Innovations

1. **Shared Opcode Mechanism**
   - 3-bit sel[2:0] + op_switch control
   - Reduces decoder complexity
   - Both SHIFT and MULTIPLY share sel=101

2. **5-Stage Parallel Barrel Shifter**
   - Single-cycle execution
   - Any shift (0-31) in one cycle
   - 77% speedup over sequential shifter

3. **Radix-2 Booth Multiplier**
   - 50% reduction in partial products
   - Automatic synthesis by tools
   - 30-40% delay improvement

---

## 📝 Design Specifications

**Technology:** 180nm CMOS (tsmc18 1.0)
**Operand Width:** 32-bit
**Operations:** 8 (ADD, SUB, AND, OR, XOR, NOT, SHIFT, MULTIPLY)
**Clock Frequency:** 1GHz (assumed)
**Area:** 96,243 μm²
**Power:** 36.48nW (at slow corner)
**Timing:** 0.66ns (shift), 2.42ns (multiply)

---

## 🏆 Team Members

| Name | Roll No | Role |
|------|---------|------|
| Akshaya Goudar | 02FE23BEC029 | ALU Core Design |
| Nandini Mohangekar | 02FE23BEC048 | Barrel Shifter, Integration |
| Aditya Dhaded | 02FE23BEC051 | Booth Multiplier, Verification |
| Deepak Kajagar | 02FE23BEC066 | Synthesis, Analysis |

**Guide:** Prof. Ashwini Desai
**Co-Guide:** Prof. Tejaswini Kutre

**Department:** Electronics and Communication Engineering
**Institution:** KLE Technological University, Belagavi

---

## 📚 Documentation

- **IEEE Technical Report:** `ALU_Report_Extended.tex` (6 pages)
- **Comparison Analysis:** `ALU_Comparison_Analysis.tex` (detailed comparison)
- **Design Specifications:** `Design_Specifications.txt`
- **Cadence Reports:** `synthesis_report.txt`, `power_analysis.txt`

---

## 🔗 Related Presentations

- **PPT Presentation:** `ALU_ReviewIV_Complete_Final.pptx` (24 slides with tables)
- **Comparison Analysis:** `Design_Comparison_Analysis.pptx`

---

## 📞 Contact

For questions or clarifications:
- Email: ashwinidesai@kletechuni.ac.in
- Department: ECE, KLE Technological University
- Review Date: May 28, 2026

---

## 📄 License

This project is part of academic minor project at KLE Technological University.
Educational use permitted with proper attribution.

---

## 🎓 References

1. V.V.N. Phanindrakumar and K.A. Jyotsna, "Design of Low Power High Performance 32-Bit ALU Using Different Adders in 45nm Technology," *International Journal of Electronics and Communication Engineering*, Vol. 10, Issue 10, Oct. 2017.

2. Rakshith C and B.G. Shivaleelavathi, "Verilog Implementation of Low Power, High Speed Arithmetic and Logical Unit using 32-Bit Barrel Shifter," *International Journal of VLSI System Design and Communication Systems*, Vol. 3, Issue 3, Jun. 2015.

3. Jaya Sai Deepak Vudatha et al., "VLSI Design of Low Power 8×4 Barrel Shifter using 90nm TG Technology," *IEEE Conference on VLSI Design and Test*, 2021.

4. Wen-Chang Yeh and Chein-Wei Jen, "High-Speed Booth Encoded Parallel Multiplier Design," *IEEE Transactions on Computers*, Vol. 49, No. 7, Jul. 2000.

---

**Last Updated:** May 28, 2026
**Status:** ✓ Complete - Ready for Submission
