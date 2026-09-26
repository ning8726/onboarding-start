/*
 * Copyright (c) 2024 Ning
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_uwasic_onboarding_ning8726 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All 8 bidirectional pins are driven as outputs
  assign uio_oe = 8'hFF;

  // Register values coming from the SPI peripheral
  wire [7:0] en_reg_out_7_0;   // 0x00 : output enable for uo_out[7:0]
  wire [7:0] en_reg_out_15_8;  // 0x01 : output enable for uio_out[7:0]
  wire [7:0] en_reg_pwm_7_0;   // 0x02 : PWM enable for uo_out[7:0]
  wire [7:0] en_reg_pwm_15_8;  // 0x03 : PWM enable for uio_out[7:0]
  wire [7:0] pwm_duty_cycle;   // 0x04 : PWM duty cycle

  // TEMPORARY: the SPI peripheral is not written yet, so hold every register at 0.
  // Replace these five assigns with the SPI instance once src/spi_peripheral.v exists.
  assign en_reg_out_7_0  = 8'h00;
  assign en_reg_out_15_8 = 8'h00;
  assign en_reg_pwm_7_0  = 8'h00;
  assign en_reg_pwm_15_8 = 8'h00;
  assign pwm_duty_cycle  = 8'h00;

  // PWM peripheral (provided in src/pwm_peripheral.v)
  pwm_peripheral pwm_peripheral_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en_reg_out_7_0(en_reg_out_7_0),
    .en_reg_out_15_8(en_reg_out_15_8),
    .en_reg_pwm_7_0(en_reg_pwm_7_0),
    .en_reg_pwm_15_8(en_reg_pwm_15_8),
    .pwm_duty_cycle(pwm_duty_cycle),
    .out({uio_out, uo_out})
  );

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in[7:3], uio_in, 1'b0};

endmodule