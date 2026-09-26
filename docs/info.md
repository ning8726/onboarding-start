<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This is the UWASIC onboarding project: an SPI-controlled PWM peripheral for Tiny Tapeout, clocked at 10 MHz.

A write-only SPI peripheral receives 16-bit transactions on the dedicated inputs (1 R/W bit + 7 address bits + 8 data bits, SPI mode 0) and stores the payload in five 8-bit registers. Read transactions and writes to addresses outside 0x00-0x04 are ignored.

| Address | Register | Description | Reset |
| ------- | -------- | ----------- | ----- |
| 0x00 | `en_reg_out_7_0` | Enable outputs on `uo_out[7:0]` | 0x00 |
| 0x01 | `en_reg_out_15_8` | Enable outputs on `uio_out[7:0]` | 0x00 |
| 0x02 | `en_reg_pwm_7_0` | Enable PWM for `uo_out[7:0]` | 0x00 |
| 0x03 | `en_reg_pwm_15_8` | Enable PWM for `uio_out[7:0]` | 0x00 |
| 0x04 | `pwm_duty_cycle` | PWM duty cycle (0x00 = 0%, 0xFF = 100%) | 0x00 |

Each of the 16 output pins (`uo_out` and `uio_out`) has an output-enable bit and a PWM-enable bit:

| Output enable | PWM enable | Result |
| ------------- | ---------- | ------ |
| 0 | X | Output 0 |
| 1 | 0 | Output 1 |
| 1 | 1 | Output PWM |

Output enable takes precedence over PWM mode. The PWM signal runs at roughly 3 kHz, derived from the 10 MHz clock, and each output pin can independently be a static level or a PWM signal.

## How to test

The Cocotb testbench in `test/` drives the SPI interface directly with `cd test && make`:

- `test_spi` writes each register and checks `uo_out` / `uio_out`, including invalid addresses and read transactions that must be ignored.
- `test_pwm_duty` sweeps the duty-cycle register from 0x00 to 0xFF and checks the measured duty cycle.
- `test_pwm_freq` measures the PWM period and checks the frequency.

In hardware, connect SCLK to `ui_in[0]`, COPI to `ui_in[1]` and nCS to `ui_in[2]`, then send 16-bit SPI transactions at about 100 kHz.

## External hardware

None.