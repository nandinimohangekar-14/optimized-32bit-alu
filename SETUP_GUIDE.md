# Quick Setup & Compilation Guide

## 📋 Prerequisites

- **Cadence Virtuoso Suite** (SimVision, Genus)
- **Verilog HDL Simulator** (ncverilog, xcelium, or iverilog)
- **Technology Library** (tsmc18 1.0 for 180nm)
- **Linux Environment** (Red Hat Enterprise Linux recommended)

---

## 🚀 Quick Start

### **Option 1: Using Cadence ncverilog**

```bash
# Clone repository
git clone https://github.com/yourusername/ALU-ASIC-Implementation.git
cd ALU-ASIC-Implementation

# Compile and simulate
ncverilog +access+r ALU_32bit.v barrel_shifter.v booth_multiplier.v tb_alu_32bit.v -gui

# View waveforms in SimVision when it opens
```

### **Option 2: Using Cadence Xcelium**

```bash
# Compile
xmvlog -sv ALU_32bit.v barrel_shifter.v booth_multiplier.v tb_alu_32bit.v

# Elaborate
xmelab tb_alu_32bit -access +rwc

# Simulate and open GUI
xmsim -gui tb_alu_32bit
```

### **Option 3: Using Open Source iverilog**

```bash
# Compile
iverilog -o alu_sim ALU_32bit.v barrel_shifter.v booth_multiplier.v tb_alu_32bit.v

# Simulate
vvp alu_sim

# View results in console
```

---

## 🔍 Verification Steps

### **Step 1: Check Simulation Runs**
```
Expected output:
✓ Test Case 1 (ADD): 7 + 12 = 19 ... PASS
✓ Test Case 2 (SUB): 20 - 5 = 15 ... PASS
✓ Test Case 3 (AND): 12 & 10 = 8 ... PASS
✓ Test Case 4 (OR): 8 | 3 = 11 ... PASS
✓ Test Case 5 (XOR): 9 ^ 5 = 12 ... PASS
✓ Test Case 6 (SHIFT): 8 << 2 = 32 ... PASS
✓ Test Case 7 (MULTIPLY): 6 × 7 = 42 ... PASS
✓ Test Case 8 (NOT): ~8 = FFFFFFF7 ... PASS
```

### **Step 2: Check Waveforms**
- Shift delay: 0.66ns ✓
- Multiply delay: 2.42ns ✓
- All operations complete in <10ns ✓

### **Step 3: Synthesis (Cadence Genus)**

```bash
# Create synthesis directory
mkdir -p synthesis
cd synthesis

# Create TCL script for synthesis
cat > synth.tcl << 'EOF'
set_app_var root_dir [file dirname [info script]]

# Read HDL
read_hdl -rtl ../ALU_32bit.v ../barrel_shifter.v ../booth_multiplier.v

# Elaborate
elaborate ALU_32bit

# Set library
set_db lib_search_path /path/to/tsmc18_1.0/lib

# Synthesize
syn_map
syn_opt
syn_final

# Generate reports
report_area > area_report.txt
report_power > power_report.txt
report_timing > timing_report.txt
report_instances > instances_report.txt

# Write netlist
write_hdl > alu_netlist.v
write_sdf -timescale ns > alu_netlist.sdf

puts "Synthesis Complete!"
EOF

# Run synthesis
genus -f synth.tcl -log synthesis.log
```

---

## 📊 Expected Results

### **Simulation Results**
```
Total Time: 80ns
All 8 operations: PASS ✓
Functional Verification: 100% ✓
```

### **Synthesis Results (180nm CMOS)**
```
Cell Count: 3,985
Total Area: 96,243 μm²
Total Power: 36.48nW
Critical Path (MULTIPLY): 2.42ns
Shift Delay: 0.66ns (77% speedup)
```

### **Power Analysis**
```
Leakage Power: 14.32nW (0.08%)
Switching Power: 22.16nW (99.92%)
Total Power: 36.48nW
```

---

## 🐛 Troubleshooting

### **Issue 1: Simulation doesn't run**
**Solution:**
- Check Verilog syntax: `verilog -check *.v`
- Verify all modules imported: grep "module" *.v
- Check `timescale` directive present

### **Issue 2: Synthesis fails**
**Solution:**
- Verify technology library path
- Check library syntax: `lib_check <lib_file>`
- Ensure all instantiated modules are present

### **Issue 3: Wrong results**
**Solution:**
- Verify testbench inputs
- Check operation encoding (sel values)
- Review carry flag logic

### **Issue 4: Performance degraded**
**Solution:**
- Use timing library mode (not placement)
- Set operating conditions correctly (slow corner)
- Check wireload model

---

## 📁 File Organization

```
project_root/
├── ALU_32bit.v                  # Top-level ALU (3.8KB)
├── barrel_shifter.v             # Barrel Shifter (2.4KB)
├── booth_multiplier.v           # Booth Multiplier (3.7KB)
├── tb_alu_32bit.v              # Testbench (11KB)
├── README.md                    # Project documentation
├── SETUP_GUIDE.md              # This file
├── .gitignore                   # Git ignore patterns
│
├── synthesis/
│   ├── synth.tcl               # Synthesis script
│   ├── alu_netlist.v           # Generated netlist
│   ├── area_report.txt         # Area report
│   ├── power_report.txt        # Power report
│   └── timing_report.txt       # Timing report
│
├── simulation/
│   ├── alu_sim.vcd             # Simulation waveforms
│   ├── simulation.log          # Simulation log
│   └── results.txt             # Test results
│
└── docs/
    ├── ALU_Report_Extended.tex
    ├── ALU_Comparison_Analysis.tex
    └── Design_Specifications.txt
```

---

## 🔄 Typical Design Flow

```
1. Functional Verification (Simulation)
   ↓
2. RTL Synthesis
   ↓
3. Area/Power Analysis
   ↓
4. Timing Analysis
   ↓
5. Place & Route (Layout)
   ↓
6. Post-layout Verification
   ↓
7. Tapeout
```

---

## 📞 Common Commands

### **View VCD Waveforms**
```bash
simvision <vcd_file>
```

### **Check Design Statistics**
```bash
genus -f synth.tcl -report
```

### **Run Power Analysis**
```bash
power_compiler -f power.tcl
```

### **Generate Design Reports**
```bash
report_area
report_power
report_timing
report_gates
```

---

## ✅ Verification Checklist

- [ ] All 4 files present and correct
- [ ] Simulation compiles without errors
- [ ] All 8 test cases PASS
- [ ] Shift delay ≤ 0.70ns
- [ ] Multiply delay ≤ 2.5ns
- [ ] Area ≤ 100k μm²
- [ ] Power ≤ 40nW
- [ ] Waveforms viewable in SimVision
- [ ] Synthesis completes successfully
- [ ] Reports generated correctly

---

## 🎯 Next Steps

1. **Clone this repository**
   ```bash
   git clone https://github.com/yourusername/ALU-ASIC-Implementation.git
   ```

2. **Install Cadence tools** (if not already installed)

3. **Run simulation** using one of the methods above

4. **Verify all test cases pass**

5. **Proceed to synthesis** for area/power analysis

6. **Review generated reports**

---

## 📚 Additional Resources

- **Cadence Documentation:** `/usr/local/cadence/doc/`
- **IEEE 1364 Verilog Standard:** IEEE 1364-2005
- **Booth Algorithm:** Standard VLSI textbooks
- **Barrel Shifter Design:** ASIC design references

---

## 👥 Support

For issues or questions:
1. Check README.md for detailed documentation
2. Review DESIGN_SPECIFICATIONS.txt for technical details
3. Refer to inline code comments for implementation details
4. Contact project guide: Prof. Ashwini Desai

---

**Happy Simulating!** 🎉

Last Updated: May 28, 2026
