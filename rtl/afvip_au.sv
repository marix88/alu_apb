// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_au
// HDL        : System Verilog
// Author     : Nicolae Nicoara
// Description: This module implements an arithmetic unit. Supports only Addition and Multiplication operations.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------
`timescale 1ns/1ps
module afvip_au#(
  parameter TP = 1   // Time Propagation
)(
// System and Control Interface
  input             clk                            , // Clock
  input             rst_n                          , // Asynchronous Reset - Active low
  output            afvip_intr                     , // Interrupt level
// RW registers fields
  input      [31:0] work_reg00                     , // Reg00
  input      [31:0] work_reg01                     , // Reg01
  input      [31:0] work_reg02                     , // Reg02
  input      [31:0] work_reg03                     , // Reg03
  input      [31:0] work_reg04                     , // Reg04
  input      [31:0] work_reg05                     , // Reg05
  input      [31:0] work_reg06                     , // Reg06
  input      [31:0] work_reg07                     , // Reg07
  input      [31:0] work_reg08                     , // Reg08
  input      [31:0] work_reg09                     , // Reg09
  input      [31:0] work_reg0A                     , // Reg10
  input      [31:0] work_reg0B                     , // Reg11
  input      [31:0] work_reg0C                     , // Reg12
  input      [31:0] work_reg0D                     , // Reg13
  input      [31:0] work_reg0E                     , // Reg14
  input      [31:0] work_reg0F                     , // Reg15
  input      [31:0] work_reg10                     , // Reg16
  input      [31:0] work_reg11                     , // Reg17
  input      [31:0] work_reg12                     , // Reg18
  input      [31:0] work_reg13                     , // Reg19
  input      [31:0] work_reg14                     , // Reg20
  input      [31:0] work_reg15                     , // Reg21
  input      [31:0] work_reg16                     , // Reg22
  input      [31:0] work_reg17                     , // Reg23
  input      [31:0] work_reg18                     , // Reg24
  input      [31:0] work_reg19                     , // Reg25
  input      [31:0] work_reg1A                     , // Reg26
  input      [31:0] work_reg1B                     , // Reg27
  input      [31:0] work_reg1C                     , // Reg28
  input      [31:0] work_reg1D                     , // Reg29
  input      [31:0] work_reg1E                     , // Reg30
  input      [31:0] work_reg1F                     , // Reg31
  output     [ 0:0] ip_we_work_reg00               , // Reg00
  output     [ 0:0] ip_we_work_reg01               , // Reg01
  output     [ 0:0] ip_we_work_reg02               , // Reg02
  output     [ 0:0] ip_we_work_reg03               , // Reg03
  output     [ 0:0] ip_we_work_reg04               , // Reg04
  output     [ 0:0] ip_we_work_reg05               , // Reg05
  output     [ 0:0] ip_we_work_reg06               , // Reg06
  output     [ 0:0] ip_we_work_reg07               , // Reg07
  output     [ 0:0] ip_we_work_reg08               , // Reg08
  output     [ 0:0] ip_we_work_reg09               , // Reg09
  output     [ 0:0] ip_we_work_reg0A               , // Reg10
  output     [ 0:0] ip_we_work_reg0B               , // Reg11
  output     [ 0:0] ip_we_work_reg0C               , // Reg12
  output     [ 0:0] ip_we_work_reg0D               , // Reg13
  output     [ 0:0] ip_we_work_reg0E               , // Reg14
  output     [ 0:0] ip_we_work_reg0F               , // Reg15
  output     [ 0:0] ip_we_work_reg10               , // Reg16
  output     [ 0:0] ip_we_work_reg11               , // Reg17
  output     [ 0:0] ip_we_work_reg12               , // Reg18
  output     [ 0:0] ip_we_work_reg13               , // Reg19
  output     [ 0:0] ip_we_work_reg14               , // Reg20
  output     [ 0:0] ip_we_work_reg15               , // Reg21
  output     [ 0:0] ip_we_work_reg16               , // Reg22
  output     [ 0:0] ip_we_work_reg17               , // Reg23
  output     [ 0:0] ip_we_work_reg18               , // Reg24
  output     [ 0:0] ip_we_work_reg19               , // Reg25
  output     [ 0:0] ip_we_work_reg1A               , // Reg26
  output     [ 0:0] ip_we_work_reg1B               , // Reg27
  output     [ 0:0] ip_we_work_reg1C               , // Reg28
  output     [ 0:0] ip_we_work_reg1D               , // Reg29
  output     [ 0:0] ip_we_work_reg1E               , // Reg30
  output     [ 0:0] ip_we_work_reg1F               , // Reg31
  output     [31:0] ip_wdata_work_reg00            , // Reg00
  output     [31:0] ip_wdata_work_reg01            , // Reg01
  output     [31:0] ip_wdata_work_reg02            , // Reg02
  output     [31:0] ip_wdata_work_reg03            , // Reg03
  output     [31:0] ip_wdata_work_reg04            , // Reg04
  output     [31:0] ip_wdata_work_reg05            , // Reg05
  output     [31:0] ip_wdata_work_reg06            , // Reg06
  output     [31:0] ip_wdata_work_reg07            , // Reg07
  output     [31:0] ip_wdata_work_reg08            , // Reg08
  output     [31:0] ip_wdata_work_reg09            , // Reg09
  output     [31:0] ip_wdata_work_reg0A            , // Reg10
  output     [31:0] ip_wdata_work_reg0B            , // Reg11
  output     [31:0] ip_wdata_work_reg0C            , // Reg12
  output     [31:0] ip_wdata_work_reg0D            , // Reg13
  output     [31:0] ip_wdata_work_reg0E            , // Reg14
  output     [31:0] ip_wdata_work_reg0F            , // Reg15
  output     [31:0] ip_wdata_work_reg10            , // Reg16
  output     [31:0] ip_wdata_work_reg11            , // Reg17
  output     [31:0] ip_wdata_work_reg12            , // Reg18
  output     [31:0] ip_wdata_work_reg13            , // Reg19
  output     [31:0] ip_wdata_work_reg14            , // Reg20
  output     [31:0] ip_wdata_work_reg15            , // Reg21
  output     [31:0] ip_wdata_work_reg16            , // Reg22
  output     [31:0] ip_wdata_work_reg17            , // Reg23
  output     [31:0] ip_wdata_work_reg18            , // Reg24
  output     [31:0] ip_wdata_work_reg19            , // Reg25
  output     [31:0] ip_wdata_work_reg1A            , // Reg26
  output     [31:0] ip_wdata_work_reg1B            , // Reg27
  output     [31:0] ip_wdata_work_reg1C            , // Reg28
  output     [31:0] ip_wdata_work_reg1D            , // Reg29
  output     [31:0] ip_wdata_work_reg1E            , // Reg30
  output     [31:0] ip_wdata_work_reg1F            , // Reg31
  input      [ 2:0] cfg_instr_op_code              , // Operation code: -- 3'd0 : reg[dst] = reg[rs0] + imm -- 3'd1 : reg[dst] = reg[rs0] * imm -- 3'd2 : reg[dst] = reg[rs0] + reg[rs1] -- 3'd3 : reg[dst] = reg[rs0] * reg[rs1] -- 3'd4 : reg [dst] = reg[rs0] * reg[rs1] + imm -- Other configuration will rise an error interrupt
  input      [ 4:0] cfg_instr_reg_rs0              , // Address for source register 0
  input      [ 4:0] cfg_instr_reg_rs1              , // Address for source register 1
  input      [ 4:0] cfg_instr_reg_dst              , // Address for destination register
  input      [ 7:0] cfg_instr_imm                  , // Immediate
// RWA registers fields
  input      [ 0:0] ev_intr_clr_err                , // Clear error interrupt
  input      [ 0:0] ev_intr_clr_finish             , // Event Filed 1 of register2
  input      [ 0:0] ev_ctrl_start                  , // Instruction start
// RO registers fields
  output reg [ 0:0] sts_intr_error_cfg             , // Error interrupt
  output reg [ 0:0] sts_intr_finish_op               // Finish interrupt
);

// Internal Signals ----------------------------------------------------------------------------------------------------
wire        valid_instruction ; // All valid instructions have opcode smallest than 5
wire        instr_0           ; // Decoded instruction 0
wire        instr_1           ; // Decoded instruction 1
wire        instr_2           ; // Decoded instruction 2
wire        instr_3           ; // Decoded instruction 3
wire        instr_4           ; // Decoded instruction 4
wire [31:0] lut [31:0]        ; // Lut
wire [31:0] rs0_val           ; // Value from LUT @ RS0 address
wire [31:0] rs1_val           ; // Value from LUT @ RS0 address
// Lut Registers control interface
reg         lut_we            ; // Write enable .    The 32 configuration registers can be also written by this module
reg   [4:0] lut_addr          ; // Write address.    The 32 configuration registers can be also written by this module
reg  [31:0] lut_wdata         ; // Write write data. The 32 configuration registers can be also written by this module

// Code ----------------------------------------------------------------------------------------------------------------
assign valid_instruction = (cfg_instr_op_code < 5); // All valid instructions have opcode smallest than 5
assign instr_0           = (cfg_instr_op_code == 3'd0)      ; // Decoded instruction 0
assign instr_1           = (cfg_instr_op_code == 3'd1)      ; // Decoded instruction 1
assign instr_2           = (cfg_instr_op_code == 3'd2)      ; // Decoded instruction 2
assign instr_3           = (cfg_instr_op_code == 3'd3)      ; // Decoded instruction 3
assign instr_4           = (cfg_instr_op_code == 3'd4)      ; // Decoded instruction 4

assign lut[0]   = work_reg00; // Reg00
assign lut[1]   = work_reg01; // Reg01
assign lut[2]   = work_reg02; // Reg02
assign lut[3]   = work_reg03; // Reg03
assign lut[4]   = work_reg04; // Reg04
assign lut[5]   = work_reg05; // Reg05
assign lut[6]   = work_reg06; // Reg06
assign lut[7]   = work_reg07; // Reg07
assign lut[8]   = work_reg08; // Reg08
assign lut[9]   = work_reg09; // Reg09
assign lut[10]  = work_reg0A; // Reg10
assign lut[11]  = work_reg0B; // Reg11
assign lut[12]  = work_reg0C; // Reg12
assign lut[13]  = work_reg0D; // Reg13
assign lut[14]  = work_reg0E; // Reg14
assign lut[15]  = work_reg0F; // Reg15
assign lut[16]  = work_reg10; // Reg16
assign lut[17]  = work_reg11; // Reg17
assign lut[18]  = work_reg12; // Reg18
assign lut[19]  = work_reg13; // Reg19
assign lut[20]  = work_reg14; // Reg20
assign lut[21]  = work_reg15; // Reg21
assign lut[22]  = work_reg16; // Reg22
assign lut[23]  = work_reg17; // Reg23
assign lut[24]  = work_reg18; // Reg24
assign lut[25]  = work_reg19; // Reg25
assign lut[26]  = work_reg1A; // Reg26
assign lut[27]  = work_reg1B; // Reg27
assign lut[28]  = work_reg1C; // Reg28
assign lut[29]  = work_reg1D; // Reg29
assign lut[30]  = work_reg1E; // Reg30
assign lut[31]  = work_reg1F; // Reg31

assign rs0_val = lut[cfg_instr_reg_rs0]           ; // Value from LUT @ RS0 address
assign rs1_val = lut[cfg_instr_reg_rs1]           ; // Value from LUT @ RS0 address


always @(posedge clk or negedge rst_n)
if(~rst_n)                                            lut_we <= #TP 1'd0; else // HW Reset (Asynchronous)
if(ev_ctrl_start & valid_instruction) lut_we <= #TP 1'd1; else // Set write enable if valid opcode detected at start
if(lut_we)                                            lut_we <= #TP 1'd0;      // Reset after 1 cycle

always @(posedge clk or negedge rst_n)
if(~rst_n)                            lut_addr <= #TP 5'd0                        ; else // HW Reset (Asynchronous)
if(ev_ctrl_start & valid_instruction) lut_addr <= #TP cfg_instr_reg_dst;      // Load destination address

always @(posedge clk or negedge rst_n)
if(~rst_n)                  lut_wdata <= #TP 32'd0                            ; else // HW Reset (Asynchronous)
if(ev_ctrl_start & instr_0) lut_wdata <= #TP rs0_val + cfg_instr_imm          ; else // reg[dst] = reg[rs0] + imm
if(ev_ctrl_start & instr_1) lut_wdata <= #TP rs0_val * cfg_instr_imm          ; else // reg[dst] = reg[rs0] * imm
if(ev_ctrl_start & instr_2) lut_wdata <= #TP rs0_val + rs1_val                ; else // reg[dst] = reg[rs0] + reg[rs1]
if(ev_ctrl_start & instr_3) lut_wdata <= #TP rs0_val * rs1_val                ; else // reg[dst] = reg[rs0] * reg[rs1] + imm
if(ev_ctrl_start & instr_4) lut_wdata <= #TP rs0_val * rs1_val + cfg_instr_imm;      // Load destination address

assign ip_wdata_work_reg00 = lut_wdata;
assign ip_wdata_work_reg01 = lut_wdata;
assign ip_wdata_work_reg02 = lut_wdata;
assign ip_wdata_work_reg03 = lut_wdata;
assign ip_wdata_work_reg04 = lut_wdata;
assign ip_wdata_work_reg05 = lut_wdata;
assign ip_wdata_work_reg06 = lut_wdata;
assign ip_wdata_work_reg07 = lut_wdata;
assign ip_wdata_work_reg08 = lut_wdata;
assign ip_wdata_work_reg09 = lut_wdata;
assign ip_wdata_work_reg0A = lut_wdata;
assign ip_wdata_work_reg0B = lut_wdata;
assign ip_wdata_work_reg0C = lut_wdata;
assign ip_wdata_work_reg0D = lut_wdata;
assign ip_wdata_work_reg0E = lut_wdata;
assign ip_wdata_work_reg0F = lut_wdata;
assign ip_wdata_work_reg10 = lut_wdata;
assign ip_wdata_work_reg11 = lut_wdata;
assign ip_wdata_work_reg12 = lut_wdata;
assign ip_wdata_work_reg13 = lut_wdata;
assign ip_wdata_work_reg14 = lut_wdata;
assign ip_wdata_work_reg15 = lut_wdata;
assign ip_wdata_work_reg16 = lut_wdata;
assign ip_wdata_work_reg17 = lut_wdata;
assign ip_wdata_work_reg18 = lut_wdata;
assign ip_wdata_work_reg19 = lut_wdata;
assign ip_wdata_work_reg1A = lut_wdata;
assign ip_wdata_work_reg1B = lut_wdata;
assign ip_wdata_work_reg1C = lut_wdata;
assign ip_wdata_work_reg1D = lut_wdata;
assign ip_wdata_work_reg1E = lut_wdata;
assign ip_wdata_work_reg1F = lut_wdata;

assign ip_we_work_reg00 = lut_we & (lut_addr == 5'h00);
assign ip_we_work_reg01 = lut_we & (lut_addr == 5'h01);
assign ip_we_work_reg02 = lut_we & (lut_addr == 5'h02);
assign ip_we_work_reg03 = lut_we & (lut_addr == 5'h03);
assign ip_we_work_reg04 = lut_we & (lut_addr == 5'h04);
assign ip_we_work_reg05 = lut_we & (lut_addr == 5'h05);
assign ip_we_work_reg06 = lut_we & (lut_addr == 5'h06);
assign ip_we_work_reg07 = lut_we & (lut_addr == 5'h07);
assign ip_we_work_reg08 = lut_we & (lut_addr == 5'h08);
assign ip_we_work_reg09 = lut_we & (lut_addr == 5'h09);
assign ip_we_work_reg0A = lut_we & (lut_addr == 5'h0A);
assign ip_we_work_reg0B = lut_we & (lut_addr == 5'h0B);
assign ip_we_work_reg0C = lut_we & (lut_addr == 5'h0C);
assign ip_we_work_reg0D = lut_we & (lut_addr == 5'h0D);
assign ip_we_work_reg0E = lut_we & (lut_addr == 5'h0E);
assign ip_we_work_reg0F = lut_we & (lut_addr == 5'h0F);
assign ip_we_work_reg10 = lut_we & (lut_addr == 5'h10);
assign ip_we_work_reg11 = lut_we & (lut_addr == 5'h11);
assign ip_we_work_reg12 = lut_we & (lut_addr == 5'h12);
assign ip_we_work_reg13 = lut_we & (lut_addr == 5'h13);
assign ip_we_work_reg14 = lut_we & (lut_addr == 5'h14);
assign ip_we_work_reg15 = lut_we & (lut_addr == 5'h15);
assign ip_we_work_reg16 = lut_we & (lut_addr == 5'h16);
assign ip_we_work_reg17 = lut_we & (lut_addr == 5'h17);
assign ip_we_work_reg18 = lut_we & (lut_addr == 5'h18);
assign ip_we_work_reg19 = lut_we & (lut_addr == 5'h19);
assign ip_we_work_reg1A = lut_we & (lut_addr == 5'h1A);
assign ip_we_work_reg1B = lut_we & (lut_addr == 5'h1B);
assign ip_we_work_reg1C = lut_we & (lut_addr == 5'h1C);
assign ip_we_work_reg1D = lut_we & (lut_addr == 5'h1D);
assign ip_we_work_reg1E = lut_we & (lut_addr == 5'h1E);
assign ip_we_work_reg1F = lut_we & (lut_addr == 5'h1F);

always @(posedge clk)
if(~rst_n)                               sts_intr_error_cfg <= #TP 1'd0     ; else // HW Reset (Asynchronous)
if(ev_ctrl_start & (~valid_instruction)) sts_intr_error_cfg <= #TP 1'd1     ; else // Set error cfg
if(ev_intr_clr_err)                      sts_intr_error_cfg <= #TP 1'd0     ;      // Reset after 1 cycle

always @(posedge clk or negedge rst_n)
if(~rst_n)                               sts_intr_finish_op <= #TP 1'd0     ; else // HW Reset (Asynchronous)
if(ev_ctrl_start &   valid_instruction ) sts_intr_finish_op <= #TP 1'd1     ; else // Set error cfg
if(ev_intr_clr_finish)                   sts_intr_finish_op <= #TP 1'd0     ;      // Reset after 1 cycle

assign afvip_intr = sts_intr_error_cfg | sts_intr_finish_op;

endmodule
