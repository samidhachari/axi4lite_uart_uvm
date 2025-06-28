// README.md 
Name : Samidha Chari
AXI4-Lite UART Peripheral with UVM Verification
Designed a synthesizable AXI4-Lite UART in SystemVerilog and verified it using a layered UVM testbench with constrained-random sequences, coverage collection, and assertions. Built a Python-based golden model to decode and validate TX output, and automated simulation using ModelSim and GTKWave.


This module is an AXI4-Lite slave connected to a simple UART TX + RX core. The host (e.g., CPU/SoC) can write/read data via AXI, and the UART sends/receives serial data accordingly.

       AXI4-Lite                     UART TX/RX
  +----------------+              +---------------+
  |   Host (CPU)   |              |               |
  |                |<--TX Data----|    UART TX     |
  |                |              |               |
  |                |----RX Data-->|    UART RX     |
  +----------------+              +---------------+
          ↑  ↓
       AXI Interface
       Control Registers


# AXI4-Lite UART Peripheral + UVM Testbench

This project implements a synthesizable **AXI4-Lite UART Peripheral** in SystemVerilog with a **fully layered UVM testbench**, complete with constrained-random verification, assertions, coverage, scoreboard checking, and a Python golden model.

---

## 📌 Features

- 🧠 RTL:
  - AXI4-Lite Slave interface
  - UART TX/RX with parameterized baud rate
  - Control/status registers (TXDATA, RXDATA, STATUS)

- ✅ UVM Testbench:
  - Complete layered environment (driver, sequencer, monitor, scoreboard)
  - Constrained-random stimulus generation
  - AXI read/write + coverage and assertion checks

- 🧪 Python Golden Model:
  - Bit-level UART decode logic
  - Verifies decoded characters from TX waveform dump

- 📈 Coverage:
  - Register access (ADDR)
  - TX character values
  - Read/Write split

- 🛠 Sim + Synthesis:
  - Simulated with ModelSim/Questa (or Verilator)
  - Synthesis via Yosys (optional)

---

## 📂 Directory Structure

View waveform:

bash
gtkwave axi_uart.vcd

Python decoding:

bash
python scripts/golden_uart.py