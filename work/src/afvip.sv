// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_top
// HDL        : System Verilog
// Author     : Nicolae Nicoara
// Description: This is a wrapper over Registers and an configurable Arithmetic unit
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------
`timescale 1ns/1ps
module afvip #(
    parameter TP = 0  // Time Propagation
)(
//Ports List -------------------------------------------------------------------
//System Interface
    input            clk        , // Clock
    input            rst_n      , // Asynchronous Reset active low
    output           afvip_intr , // Interrupt
// APB Interface
    input            psel       , // Select.        
    input            penable    , // Enable.        
    input     [15:0] paddr      , // Address.       
    input            pwrite     , // Direction.     
    input     [31:0] pwdata     , // Write data.    
    output           pready     , // Ready.         
    output    [31:0] prdata     , // Read data.     
    output           pslverr      // Transfer error.
);

// Internal Signals ----------------------------------------------------------------------------------------------------
// RW registers fields
wire [31:0] work_reg00                     ; // Reg00
wire [31:0] ip_wdata_work_reg00            ; // Reg00
wire [ 0:0] ip_we_work_reg00              ; // Reg00
wire [31:0] work_reg01                     ; // Reg01
wire [31:0] ip_wdata_work_reg01            ; // Reg01
wire [ 0:0] ip_we_work_reg01              ; // Reg01
wire [31:0] work_reg02                     ; // Reg02
wire [31:0] ip_wdata_work_reg02            ; // Reg02
wire [ 0:0] ip_we_work_reg02              ; // Reg02
wire [31:0] work_reg03                     ; // Reg03
wire [31:0] ip_wdata_work_reg03            ; // Reg03
wire [ 0:0] ip_we_work_reg03              ; // Reg03
wire [31:0] work_reg04                     ; // Reg04
wire [31:0] ip_wdata_work_reg04            ; // Reg04
wire [ 0:0] ip_we_work_reg04              ; // Reg04
wire [31:0] work_reg05                     ; // Reg05
wire [31:0] ip_wdata_work_reg05            ; // Reg05
wire [ 0:0] ip_we_work_reg05              ; // Reg05
wire [31:0] work_reg06                     ; // Reg06
wire [31:0] ip_wdata_work_reg06            ; // Reg06
wire [ 0:0] ip_we_work_reg06              ; // Reg06
wire [31:0] work_reg07                     ; // Reg07
wire [31:0] ip_wdata_work_reg07            ; // Reg07
wire [ 0:0] ip_we_work_reg07              ; // Reg07
wire [31:0] work_reg08                     ; // Reg08
wire [31:0] ip_wdata_work_reg08            ; // Reg08
wire [ 0:0] ip_we_work_reg08              ; // Reg08
wire [31:0] work_reg09                     ; // Reg09
wire [31:0] ip_wdata_work_reg09            ; // Reg09
wire [ 0:0] ip_we_work_reg09              ; // Reg09
wire [31:0] work_reg0A                     ; // Reg10
wire [31:0] ip_wdata_work_reg0A            ; // Reg10
wire [ 0:0] ip_we_work_reg0A              ; // Reg10
wire [31:0] work_reg0B                     ; // Reg11
wire [31:0] ip_wdata_work_reg0B            ; // Reg11
wire [ 0:0] ip_we_work_reg0B              ; // Reg11
wire [31:0] work_reg0C                     ; // Reg12
wire [31:0] ip_wdata_work_reg0C            ; // Reg12
wire [ 0:0] ip_we_work_reg0C              ; // Reg12
wire [31:0] work_reg0D                     ; // Reg13
wire [31:0] ip_wdata_work_reg0D            ; // Reg13
wire [ 0:0] ip_we_work_reg0D              ; // Reg13
wire [31:0] work_reg0E                     ; // Reg14
wire [31:0] ip_wdata_work_reg0E            ; // Reg14
wire [ 0:0] ip_we_work_reg0E              ; // Reg14
wire [31:0] work_reg0F                     ; // Reg15
wire [31:0] ip_wdata_work_reg0F            ; // Reg15
wire [ 0:0] ip_we_work_reg0F              ; // Reg15
wire [31:0] work_reg10                     ; // Reg16
wire [31:0] ip_wdata_work_reg10            ; // Reg16
wire [ 0:0] ip_we_work_reg10              ; // Reg16
wire [31:0] work_reg11                     ; // Reg17
wire [31:0] ip_wdata_work_reg11            ; // Reg17
wire [ 0:0] ip_we_work_reg11              ; // Reg17
wire [31:0] work_reg12                     ; // Reg18
wire [31:0] ip_wdata_work_reg12            ; // Reg18
wire [ 0:0] ip_we_work_reg12              ; // Reg18
wire [31:0] work_reg13                     ; // Reg19
wire [31:0] ip_wdata_work_reg13            ; // Reg19
wire [ 0:0] ip_we_work_reg13              ; // Reg19
wire [31:0] work_reg14                     ; // Reg20
wire [31:0] ip_wdata_work_reg14            ; // Reg20
wire [ 0:0] ip_we_work_reg14              ; // Reg20
wire [31:0] work_reg15                     ; // Reg21
wire [31:0] ip_wdata_work_reg15            ; // Reg21
wire [ 0:0] ip_we_work_reg15              ; // Reg21
wire [31:0] work_reg16                     ; // Reg22
wire [31:0] ip_wdata_work_reg16            ; // Reg22
wire [ 0:0] ip_we_work_reg16              ; // Reg22
wire [31:0] work_reg17                     ; // Reg23
wire [31:0] ip_wdata_work_reg17            ; // Reg23
wire [ 0:0] ip_we_work_reg17              ; // Reg23
wire [31:0] work_reg18                     ; // Reg24
wire [31:0] ip_wdata_work_reg18            ; // Reg24
wire [ 0:0] ip_we_work_reg18              ; // Reg24
wire [31:0] work_reg19                     ; // Reg25
wire [31:0] ip_wdata_work_reg19            ; // Reg25
wire [ 0:0] ip_we_work_reg19              ; // Reg25
wire [31:0] work_reg1A                     ; // Reg26
wire [31:0] ip_wdata_work_reg1A            ; // Reg26
wire [ 0:0] ip_we_work_reg1A              ; // Reg26
wire [31:0] work_reg1B                     ; // Reg27
wire [31:0] ip_wdata_work_reg1B            ; // Reg27
wire [ 0:0] ip_we_work_reg1B              ; // Reg27
wire [31:0] work_reg1C                     ; // Reg28
wire [31:0] ip_wdata_work_reg1C            ; // Reg28
wire [ 0:0] ip_we_work_reg1C              ; // Reg28
wire [31:0] work_reg1D                     ; // Reg29
wire [31:0] ip_wdata_work_reg1D            ; // Reg29
wire [ 0:0] ip_we_work_reg1D              ; // Reg29
wire [31:0] work_reg1E                     ; // Reg30
wire [31:0] ip_wdata_work_reg1E            ; // Reg30
wire [ 0:0] ip_we_work_reg1E              ; // Reg30
wire [31:0] work_reg1F                     ; // Reg31
wire [31:0] ip_wdata_work_reg1F            ; // Reg31
wire [ 0:0] ip_we_work_reg1F              ; // Reg31

wire [ 2:0] cfg_instr_op_code              ; // Operation code: -- 3'd0 : reg[dst] = reg[rs0] + imm -- 3'd1 : reg[dst] = reg[rs0] * imm -- 3'd2 : reg[dst] = reg[rs0] + reg[rs1] -- 3'd3 : reg[dst] = reg[rs0] * reg[rs1] -- 3'd4 : reg [dst] = reg[rs0] * reg[rs1] + imm -- Other configuration will rise an error interrupt
wire [ 4:0] cfg_instr_reg_rs0              ; // Address for source register 0
wire [ 4:0] cfg_instr_reg_rs1              ; // Address for source register 1
wire [ 4:0] cfg_instr_reg_dst              ; // Address for destination register
wire [ 7:0] cfg_instr_imm                  ; // Immediate
// RWA registers fields
wire [ 0:0] ev_intr_clr_err                ; // Clear error interrupt
wire [ 0:0] ev_intr_clr_finish             ; // Event Filed 1 of register2
wire [ 0:0] ev_ctrl_start                  ; // Instruction start
// RO registers fields
wire [ 0:0] sts_intr_error_cfg             ; // Error interrupt
wire [ 0:0] sts_intr_finish_op             ; // Finish interrupt
// Lut interface
wire        lut_we                         ; // Write enable .    The 32 configuration registers can be also written by this module 
wire  [4:0] lut_addr                       ; // Write address.    The 32 configuration registers can be also written by this module 
wire [31:0] lut_wdata                      ; // Write write data. The 32 configuration registers can be also written by this module 


// Code ----------------------------------------------------------------------------------------------------------------

// APB for verification IP - Registers instance
afvip_hw_registers #(
  .TP                             (TP                   ), // Time Propagation
  .APB_ADDR_WIDTH                 (16                   ), // APB Address width
  .BASE_ADDR                      (16'h0000             )  // APB Base address
)afvip_hw_registers_i(
// System and Control Interface
  .clk                            (clk                  ), // [I] Clock
  .rst_n                          (rst_n                ), // [I] Asynchronous Reset - Active low
// RW registers fields
  .work_reg00                     (work_reg00           ), // [O] Reg00
  .work_reg01                     (work_reg01           ), // [O] Reg01
  .work_reg02                     (work_reg02           ), // [O] Reg02
  .work_reg03                     (work_reg03           ), // [O] Reg03
  .work_reg04                     (work_reg04           ), // [O] Reg04
  .work_reg05                     (work_reg05           ), // [O] Reg05
  .work_reg06                     (work_reg06           ), // [O] Reg06
  .work_reg07                     (work_reg07           ), // [O] Reg07
  .work_reg08                     (work_reg08           ), // [O] Reg08
  .work_reg09                     (work_reg09           ), // [O] Reg09
  .work_reg0A                     (work_reg0A           ), // [O] Reg10
  .work_reg0B                     (work_reg0B           ), // [O] Reg11
  .work_reg0C                     (work_reg0C           ), // [O] Reg12
  .work_reg0D                     (work_reg0D           ), // [O] Reg13
  .work_reg0E                     (work_reg0E           ), // [O] Reg14
  .work_reg0F                     (work_reg0F           ), // [O] Reg15
  .work_reg10                     (work_reg10           ), // [O] Reg16
  .work_reg11                     (work_reg11           ), // [O] Reg17
  .work_reg12                     (work_reg12           ), // [O] Reg18
  .work_reg13                     (work_reg13           ), // [O] Reg19
  .work_reg14                     (work_reg14           ), // [O] Reg20
  .work_reg15                     (work_reg15           ), // [O] Reg21
  .work_reg16                     (work_reg16           ), // [O] Reg22
  .work_reg17                     (work_reg17           ), // [O] Reg23
  .work_reg18                     (work_reg18           ), // [O] Reg24
  .work_reg19                     (work_reg19           ), // [O] Reg25
  .work_reg1A                     (work_reg1A           ), // [O] Reg26
  .work_reg1B                     (work_reg1B           ), // [O] Reg27
  .work_reg1C                     (work_reg1C           ), // [O] Reg28
  .work_reg1D                     (work_reg1D           ), // [O] Reg29
  .work_reg1E                     (work_reg1E           ), // [O] Reg30
  .work_reg1F                     (work_reg1F           ), // [O] Reg31
  .ip_we_work_reg00               (ip_we_work_reg00     ), // [I] Reg00
  .ip_we_work_reg01               (ip_we_work_reg01     ), // [I] Reg01
  .ip_we_work_reg02               (ip_we_work_reg02     ), // [I] Reg02
  .ip_we_work_reg03               (ip_we_work_reg03     ), // [I] Reg03
  .ip_we_work_reg04               (ip_we_work_reg04     ), // [I] Reg04
  .ip_we_work_reg05               (ip_we_work_reg05     ), // [I] Reg05
  .ip_we_work_reg06               (ip_we_work_reg06     ), // [I] Reg06
  .ip_we_work_reg07               (ip_we_work_reg07     ), // [I] Reg07
  .ip_we_work_reg08               (ip_we_work_reg08     ), // [I] Reg08
  .ip_we_work_reg09               (ip_we_work_reg09     ), // [I] Reg09
  .ip_we_work_reg0A               (ip_we_work_reg0A     ), // [I] Reg10
  .ip_we_work_reg0B               (ip_we_work_reg0B     ), // [I] Reg11
  .ip_we_work_reg0C               (ip_we_work_reg0C     ), // [I] Reg12
  .ip_we_work_reg0D               (ip_we_work_reg0D     ), // [I] Reg13
  .ip_we_work_reg0E               (ip_we_work_reg0E     ), // [I] Reg14
  .ip_we_work_reg0F               (ip_we_work_reg0F     ), // [I] Reg15
  .ip_we_work_reg10               (ip_we_work_reg10     ), // [I] Reg16
  .ip_we_work_reg11               (ip_we_work_reg11     ), // [I] Reg17
  .ip_we_work_reg12               (ip_we_work_reg12     ), // [I] Reg18
  .ip_we_work_reg13               (ip_we_work_reg13     ), // [I] Reg19
  .ip_we_work_reg14               (ip_we_work_reg14     ), // [I] Reg20
  .ip_we_work_reg15               (ip_we_work_reg15     ), // [I] Reg21
  .ip_we_work_reg16               (ip_we_work_reg16     ), // [I] Reg22
  .ip_we_work_reg17               (ip_we_work_reg17     ), // [I] Reg23
  .ip_we_work_reg18               (ip_we_work_reg18     ), // [I] Reg24
  .ip_we_work_reg19               (ip_we_work_reg19     ), // [I] Reg25
  .ip_we_work_reg1A               (ip_we_work_reg1A     ), // [I] Reg26
  .ip_we_work_reg1B               (ip_we_work_reg1B     ), // [I] Reg27
  .ip_we_work_reg1C               (ip_we_work_reg1C     ), // [I] Reg28
  .ip_we_work_reg1D               (ip_we_work_reg1D     ), // [I] Reg29
  .ip_we_work_reg1E               (ip_we_work_reg1E     ), // [I] Reg30
  .ip_we_work_reg1F               (ip_we_work_reg1F     ), // [I] Reg31
  .ip_wdata_work_reg00            (ip_wdata_work_reg00  ), // [I] Reg00
  .ip_wdata_work_reg01            (ip_wdata_work_reg01  ), // [I] Reg01
  .ip_wdata_work_reg02            (ip_wdata_work_reg02  ), // [I] Reg02
  .ip_wdata_work_reg03            (ip_wdata_work_reg03  ), // [I] Reg03
  .ip_wdata_work_reg04            (ip_wdata_work_reg04  ), // [I] Reg04
  .ip_wdata_work_reg05            (ip_wdata_work_reg05  ), // [I] Reg05
  .ip_wdata_work_reg06            (ip_wdata_work_reg06  ), // [I] Reg06
  .ip_wdata_work_reg07            (ip_wdata_work_reg07  ), // [I] Reg07
  .ip_wdata_work_reg08            (ip_wdata_work_reg08  ), // [I] Reg08
  .ip_wdata_work_reg09            (ip_wdata_work_reg09  ), // [I] Reg09
  .ip_wdata_work_reg0A            (ip_wdata_work_reg0A  ), // [I] Reg10
  .ip_wdata_work_reg0B            (ip_wdata_work_reg0B  ), // [I] Reg11
  .ip_wdata_work_reg0C            (ip_wdata_work_reg0C  ), // [I] Reg12
  .ip_wdata_work_reg0D            (ip_wdata_work_reg0D  ), // [I] Reg13
  .ip_wdata_work_reg0E            (ip_wdata_work_reg0E  ), // [I] Reg14
  .ip_wdata_work_reg0F            (ip_wdata_work_reg0F  ), // [I] Reg15
  .ip_wdata_work_reg10            (ip_wdata_work_reg10  ), // [I] Reg16
  .ip_wdata_work_reg11            (ip_wdata_work_reg11  ), // [I] Reg17
  .ip_wdata_work_reg12            (ip_wdata_work_reg12  ), // [I] Reg18
  .ip_wdata_work_reg13            (ip_wdata_work_reg13  ), // [I] Reg19
  .ip_wdata_work_reg14            (ip_wdata_work_reg14  ), // [I] Reg20
  .ip_wdata_work_reg15            (ip_wdata_work_reg15  ), // [I] Reg21
  .ip_wdata_work_reg16            (ip_wdata_work_reg16  ), // [I] Reg22
  .ip_wdata_work_reg17            (ip_wdata_work_reg17  ), // [I] Reg23
  .ip_wdata_work_reg18            (ip_wdata_work_reg18  ), // [I] Reg24
  .ip_wdata_work_reg19            (ip_wdata_work_reg19  ), // [I] Reg25
  .ip_wdata_work_reg1A            (ip_wdata_work_reg1A  ), // [I] Reg26
  .ip_wdata_work_reg1B            (ip_wdata_work_reg1B  ), // [I] Reg27
  .ip_wdata_work_reg1C            (ip_wdata_work_reg1C  ), // [I] Reg28
  .ip_wdata_work_reg1D            (ip_wdata_work_reg1D  ), // [I] Reg29
  .ip_wdata_work_reg1E            (ip_wdata_work_reg1E  ), // [I] Reg30
  .ip_wdata_work_reg1F            (ip_wdata_work_reg1F  ), // [I] Reg31
  .cfg_instr_op_code              (cfg_instr_op_code    ), // [O] Operation code: -- 3'd0 : reg[dst] = reg[rs0] + imm -- 3'd1 : reg[dst] = reg[rs0] * imm -- 3'd2 : reg[dst] = reg[rs0] + reg[rs1] -- 3'd3 : reg[dst] = reg[rs0] * reg[rs1] -- 3'd4 : reg [dst] = reg[rs0] * reg[rs1] + imm -- Other configuration will rise an error interrupt
  .cfg_instr_reg_rs0              (cfg_instr_reg_rs0    ), // [O] Address for source register 0
  .cfg_instr_reg_rs1              (cfg_instr_reg_rs1    ), // [O] Address for source register 1
  .cfg_instr_reg_dst              (cfg_instr_reg_dst    ), // [O] Address for destination register
  .cfg_instr_imm                  (cfg_instr_imm        ), // [O] Immediate
// RWA registers fields
  .ev_intr_clr_err                (ev_intr_clr_err      ), // [O] Clear error interrupt
  .ev_intr_clr_finish             (ev_intr_clr_finish   ), // [O] Event Filed 1 of register2
  .ev_ctrl_start                  (ev_ctrl_start        ), // [O] Instruction start
// RO registers fields
  .sts_intr_error_cfg             (sts_intr_error_cfg   ), // [I] Error interrupt
  .sts_intr_finish_op             (sts_intr_finish_op   ), // [I] Finish interrupt
// APB Interface
  .psel                           (psel                 ), // [I] Select.         PSELx indicates that the Completer is selected and that a data transfer is required.
  .penable                        (penable              ), // [I] Enable.         PENABLE indicates the second and subsequent cycles of an APB transfer.
  .paddr                          (paddr                ), // [I] Address.        PADDR is the APB address bus. 
  .pwrite                         (pwrite               ), // [I] Direction.      PWRITE indicates an APB write access when HIGH and an APB read access when LOW
  .pwdata                         (pwdata               ), // [I] Write data.     The PWDATA write data bus is driven by the APB bridge Requester during write cycles when PWRITE is HIGH.  
  .pready                         (pready               ), // [O] Ready.          PREADY is used to extend an APB transfer by the Completer.
  .prdata                         (prdata               ), // [O] Read data.      The PRDATA read data bus is driven by the selected Completer during read cycles when PWRITE is LOW. 
  .pslverr                        (pslverr              )  // [O] Transfer error. PSLVERR is an optional signal that can be asserted HIGH by the Completer to indicate an error condition on an APB transfer
);

// APB for verification IP - Arithmetic Unit
afvip_au #(
  .TP                             (TP                    )  // Time Propagation
)afvip_au_i(
// System and Control Interface
  .clk                            (clk                   ), // [I] Clock
  .rst_n                          (rst_n                 ), // [I] Asynchronous Reset - Active low
  .afvip_intr                     (afvip_intr            ), // [O] Interrupt Level
// RW registers fields
  .work_reg00                     (work_reg00            ), // [I] Reg00
  .work_reg01                     (work_reg01            ), // [I] Reg01
  .work_reg02                     (work_reg02            ), // [I] Reg02
  .work_reg03                     (work_reg03            ), // [I] Reg03
  .work_reg04                     (work_reg04            ), // [I] Reg04
  .work_reg05                     (work_reg05            ), // [I] Reg05
  .work_reg06                     (work_reg06            ), // [I] Reg06
  .work_reg07                     (work_reg07            ), // [I] Reg07
  .work_reg08                     (work_reg08            ), // [I] Reg08
  .work_reg09                     (work_reg09            ), // [I] Reg09
  .work_reg0A                     (work_reg0A            ), // [I] Reg10
  .work_reg0B                     (work_reg0B            ), // [I] Reg11
  .work_reg0C                     (work_reg0C            ), // [I] Reg12
  .work_reg0D                     (work_reg0D            ), // [I] Reg13
  .work_reg0E                     (work_reg0E            ), // [I] Reg14
  .work_reg0F                     (work_reg0F            ), // [I] Reg15
  .work_reg10                     (work_reg10            ), // [I] Reg16
  .work_reg11                     (work_reg11            ), // [I] Reg17
  .work_reg12                     (work_reg12            ), // [I] Reg18
  .work_reg13                     (work_reg13            ), // [I] Reg19
  .work_reg14                     (work_reg14            ), // [I] Reg20
  .work_reg15                     (work_reg15            ), // [I] Reg21
  .work_reg16                     (work_reg16            ), // [I] Reg22
  .work_reg17                     (work_reg17            ), // [I] Reg23
  .work_reg18                     (work_reg18            ), // [I] Reg24
  .work_reg19                     (work_reg19            ), // [I] Reg25
  .work_reg1A                     (work_reg1A            ), // [I] Reg26
  .work_reg1B                     (work_reg1B            ), // [I] Reg27
  .work_reg1C                     (work_reg1C            ), // [I] Reg28
  .work_reg1D                     (work_reg1D            ), // [I] Reg29
  .work_reg1E                     (work_reg1E            ), // [I] Reg30
  .work_reg1F                     (work_reg1F            ), // [I] Reg31
  .ip_we_work_reg00               (ip_we_work_reg00      ), // [O] Reg00
  .ip_we_work_reg01               (ip_we_work_reg01      ), // [O] Reg01
  .ip_we_work_reg02               (ip_we_work_reg02      ), // [O] Reg02
  .ip_we_work_reg03               (ip_we_work_reg03      ), // [O] Reg03
  .ip_we_work_reg04               (ip_we_work_reg04      ), // [O] Reg04
  .ip_we_work_reg05               (ip_we_work_reg05      ), // [O] Reg05
  .ip_we_work_reg06               (ip_we_work_reg06      ), // [O] Reg06
  .ip_we_work_reg07               (ip_we_work_reg07      ), // [O] Reg07
  .ip_we_work_reg08               (ip_we_work_reg08      ), // [O] Reg08
  .ip_we_work_reg09               (ip_we_work_reg09      ), // [O] Reg09
  .ip_we_work_reg0A               (ip_we_work_reg0A      ), // [O] Reg10
  .ip_we_work_reg0B               (ip_we_work_reg0B      ), // [O] Reg11
  .ip_we_work_reg0C               (ip_we_work_reg0C      ), // [O] Reg12
  .ip_we_work_reg0D               (ip_we_work_reg0D      ), // [O] Reg13
  .ip_we_work_reg0E               (ip_we_work_reg0E      ), // [O] Reg14
  .ip_we_work_reg0F               (ip_we_work_reg0F      ), // [O] Reg15
  .ip_we_work_reg10               (ip_we_work_reg10      ), // [O] Reg16
  .ip_we_work_reg11               (ip_we_work_reg11      ), // [O] Reg17
  .ip_we_work_reg12               (ip_we_work_reg12      ), // [O] Reg18
  .ip_we_work_reg13               (ip_we_work_reg13      ), // [O] Reg19
  .ip_we_work_reg14               (ip_we_work_reg14      ), // [O] Reg20
  .ip_we_work_reg15               (ip_we_work_reg15      ), // [O] Reg21
  .ip_we_work_reg16               (ip_we_work_reg16      ), // [O] Reg22
  .ip_we_work_reg17               (ip_we_work_reg17      ), // [O] Reg23
  .ip_we_work_reg18               (ip_we_work_reg18      ), // [O] Reg24
  .ip_we_work_reg19               (ip_we_work_reg19      ), // [O] Reg25
  .ip_we_work_reg1A               (ip_we_work_reg1A      ), // [O] Reg26
  .ip_we_work_reg1B               (ip_we_work_reg1B      ), // [O] Reg27
  .ip_we_work_reg1C               (ip_we_work_reg1C      ), // [O] Reg28
  .ip_we_work_reg1D               (ip_we_work_reg1D      ), // [O] Reg29
  .ip_we_work_reg1E               (ip_we_work_reg1E      ), // [O] Reg30
  .ip_we_work_reg1F               (ip_we_work_reg1F      ), // [O] Reg31
  .ip_wdata_work_reg00            (ip_wdata_work_reg00   ), // [O] Reg00
  .ip_wdata_work_reg01            (ip_wdata_work_reg01   ), // [O] Reg01
  .ip_wdata_work_reg02            (ip_wdata_work_reg02   ), // [O] Reg02
  .ip_wdata_work_reg03            (ip_wdata_work_reg03   ), // [O] Reg03
  .ip_wdata_work_reg04            (ip_wdata_work_reg04   ), // [O] Reg04
  .ip_wdata_work_reg05            (ip_wdata_work_reg05   ), // [O] Reg05
  .ip_wdata_work_reg06            (ip_wdata_work_reg06   ), // [O] Reg06
  .ip_wdata_work_reg07            (ip_wdata_work_reg07   ), // [O] Reg07
  .ip_wdata_work_reg08            (ip_wdata_work_reg08   ), // [O] Reg08
  .ip_wdata_work_reg09            (ip_wdata_work_reg09   ), // [O] Reg09
  .ip_wdata_work_reg0A            (ip_wdata_work_reg0A   ), // [O] Reg10
  .ip_wdata_work_reg0B            (ip_wdata_work_reg0B   ), // [O] Reg11
  .ip_wdata_work_reg0C            (ip_wdata_work_reg0C   ), // [O] Reg12
  .ip_wdata_work_reg0D            (ip_wdata_work_reg0D   ), // [O] Reg13
  .ip_wdata_work_reg0E            (ip_wdata_work_reg0E   ), // [O] Reg14
  .ip_wdata_work_reg0F            (ip_wdata_work_reg0F   ), // [O] Reg15
  .ip_wdata_work_reg10            (ip_wdata_work_reg10   ), // [O] Reg16
  .ip_wdata_work_reg11            (ip_wdata_work_reg11   ), // [O] Reg17
  .ip_wdata_work_reg12            (ip_wdata_work_reg12   ), // [O] Reg18
  .ip_wdata_work_reg13            (ip_wdata_work_reg13   ), // [O] Reg19
  .ip_wdata_work_reg14            (ip_wdata_work_reg14   ), // [O] Reg20
  .ip_wdata_work_reg15            (ip_wdata_work_reg15   ), // [O] Reg21
  .ip_wdata_work_reg16            (ip_wdata_work_reg16   ), // [O] Reg22
  .ip_wdata_work_reg17            (ip_wdata_work_reg17   ), // [O] Reg23
  .ip_wdata_work_reg18            (ip_wdata_work_reg18   ), // [O] Reg24
  .ip_wdata_work_reg19            (ip_wdata_work_reg19   ), // [O] Reg25
  .ip_wdata_work_reg1A            (ip_wdata_work_reg1A   ), // [O] Reg26
  .ip_wdata_work_reg1B            (ip_wdata_work_reg1B   ), // [O] Reg27
  .ip_wdata_work_reg1C            (ip_wdata_work_reg1C   ), // [O] Reg28
  .ip_wdata_work_reg1D            (ip_wdata_work_reg1D   ), // [O] Reg29
  .ip_wdata_work_reg1E            (ip_wdata_work_reg1E   ), // [O] Reg30
  .ip_wdata_work_reg1F            (ip_wdata_work_reg1F   ), // [O] Reg31
  .cfg_instr_op_code              (cfg_instr_op_code     ), // [I] Operation code: -- 3'd0 : reg[dst] = reg[rs0] + imm -- 3'd1 : reg[dst] = reg[rs0] * imm -- 3'd2 : reg[dst] = reg[rs0] + reg[rs1] -- 3'd3 : reg[dst] = reg[rs0] * reg[rs1] -- 3'd4 : reg [dst] = reg[rs0] * reg[rs1] + imm -- Other configuration will rise an error interrupt
  .cfg_instr_reg_rs0              (cfg_instr_reg_rs0     ), // [I] Address for source register 0
  .cfg_instr_reg_rs1              (cfg_instr_reg_rs1     ), // [I] Address for source register 1
  .cfg_instr_reg_dst              (cfg_instr_reg_dst     ), // [I] Address for destination register
  .cfg_instr_imm                  (cfg_instr_imm         ), // [I] Immediate
// RWA registers fields
  .ev_intr_clr_err                (ev_intr_clr_err       ), // [I] Clear error interrupt
  .ev_intr_clr_finish             (ev_intr_clr_finish    ), // [I] Event Filed 1 of register2
  .ev_ctrl_start                  (ev_ctrl_start         ), // [I] Instruction start
// RO registers fields
  .sts_intr_error_cfg             (sts_intr_error_cfg    ), // [O] Error interrupt
  .sts_intr_finish_op             (sts_intr_finish_op    )  // [O] Finish interrupt
);

endmodule 
