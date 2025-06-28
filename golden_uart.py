// golden_uart.py 

# golden_uart.py

import sys

def decode_uart_tx(samples, baud_ticks=5208):  # 50 MHz / 9600 baud
    decoded_bytes = []
    i = 0
    while i < len(samples) - baud_ticks * 10:
        if samples[i] == 0:  # Start bit
            bits = []
            for j in range(1, 9):  # 8 data bits
                idx = i + j * baud_ticks
                bits.append(samples[idx])
            byte_val = 0
            for k in range(8):
                byte_val |= (bits[k] << k)
            decoded_bytes.append(chr(byte_val))
            i += baud_ticks * 10  # Skip 1 frame
        else:
            i += 1
    return decoded_bytes


if __name__ == "__main__":
    # Sample input: binary string of uart_tx over time
    # e.g., 1,1,1,0,1,1,... from a waveform or dump
    samples = [int(x.strip()) for x in open("uart_tx_trace.txt")]
    result = decode_uart_tx(samples)
    print("Decoded UART Bytes:", result)

