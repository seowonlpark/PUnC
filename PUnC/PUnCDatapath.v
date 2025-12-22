//==============================================================================
// Datapath for PUnC LC3 Processor 
//==============================================================================

`include "Defines.v"

module PUnCDatapath(
    // External Inputs
    input  wire        clk,
    input  wire        rst,

    // DEBUG
    input  wire [15:0] mem_debug_addr,
    input  wire [2:0]  rf_debug_addr,
    output wire [15:0] mem_debug_data,
    output wire [15:0] rf_debug_data,
    output wire [15:0] pc_debug_data,

    // Control signals
    input [1:0] mem_r_addr_sel,
    input       mem_w_addr_sel,
    input       mem_w_data_sel,
    input       mem_w_en,

    input       rf_r_addr_0_sel,
    input       rf_r_addr_1_sel,
    input       rf_w_addr_sel,
    input [1:0] rf_w_data_sel,
    input       rf_w_en,

    input [1:0] pc_src_sel,
    input [1:0] alu_src_0_sel,
    input [2:0] alu_src_1_sel,
    input [1:0] alu_fn,
    input       alu_en,

    input       mem_reg_ld,
    input       mem_reg_rst,

    input       ir_ld,

    input       pc_ld,
    input       pc_up,
    input       pc_rst,

    input       nzp_en,
    input       nzp_rst,

    // Outputs to controller
    output reg [15:0] ir,
    output wire       br_en,
    output wire [15:0] alu_out
);

    //==========================================================================
    // STATE
    //==========================================================================
    reg [15:0] pc;
    reg [15:0] mem_reg;
    reg n_reg, z_reg, p_reg;

    assign pc_debug_data = pc;

    //==========================================================================
    // WIRES
    //==========================================================================
    wire [15:0] mem_r_addr_0;
    wire [15:0] mem_w_addr;
    wire [15:0] mem_w_data;
    wire [15:0] mem_r_data_0;

    wire [2:0]  rf_r_addr_0;
    wire [2:0]  rf_r_addr_1;
    wire [2:0]  rf_w_addr;
    wire [15:0] rf_w_data;
    wire [15:0] rf_r_data_0;
    wire [15:0] rf_r_data_1;

    wire [15:0] alu_src_0;
    wire [15:0] alu_src_1;
    wire [15:0] pc_in;

    //==========================================================================
    // MEMORY
    //==========================================================================
    Memory mem(
        .clk      (clk),
        .rst      (rst),
        .r_addr_0 (mem_r_addr_0),
        .r_addr_1 (mem_debug_addr),
        .w_addr   (mem_w_addr),
        .w_data   (mem_w_data),
        .w_en     (mem_w_en),
        .r_data_0 (mem_r_data_0),
        .r_data_1 (mem_debug_data)
    );

    //==========================================================================
    // REGISTER FILE
    //==========================================================================
    RegisterFile rfile(
        .clk      (clk),
        .rst      (rst),
        .r_addr_0 (rf_r_addr_0),
        .r_addr_1 (rf_r_addr_1),
        .r_addr_2 (rf_debug_addr),
        .w_addr   (rf_w_addr),
        .w_data   (rf_w_data),
        .w_en     (rf_w_en),
        .r_data_0 (rf_r_data_0),
        .r_data_1 (rf_r_data_1),
        .r_data_2 (rf_debug_data)
    );

    //==========================================================================
    // COMBINATIONAL LOGIC
    //==========================================================================

    // Register file addresses
    assign rf_r_addr_0 =
        (rf_r_addr_0_sel == `RF_R_ADDR_0_SEL_8_6) ? ir[8:6] : ir[11:9]; // default to DR

    assign rf_r_addr_1 =
        (rf_r_addr_1_sel == `RF_R_ADDR_1_SEL_2_0) ? ir[2:0] : ir[8:6]; // default to SRI

    assign rf_w_addr =
        (rf_w_addr_sel == `RF_W_ADDR_SEL_11_9) ? ir[11:9] : 3'd7;

    // Register writeback data
    assign rf_w_data =
        (rf_w_data_sel == `RF_W_DATA_SEL_ALU) ? alu_out :
        (rf_w_data_sel == `RF_W_DATA_SEL_PC ) ? pc      :
        (rf_w_data_sel == `RF_W_DATA_SEL_MEM) ? mem_r_data_0 :
                                                16'd0;

    // ALU inputs
    assign alu_src_0 =
        (alu_src_0_sel == `ALU_SRC_0_SEL_REG_0) ? rf_r_data_0 :
        (alu_src_0_sel == `ALU_SRC_0_SEL_REG_1) ? rf_r_data_1 :
        (alu_src_0_sel == `ALU_SRC_0_SEL_PC)    ? pc :
                                                  16'd0;

    assign alu_src_1 =
        (alu_src_1_sel == `ALU_SRC_1_SEL_REG_1) ? rf_r_data_1 :
        (alu_src_1_sel == `ALU_SRC_1_SEL_SXT_5)  ? {{11{ir[4]}}, ir[4:0]} :
        (alu_src_1_sel == `ALU_SRC_1_SEL_SXT_6)  ? {{10{ir[5]}}, ir[5:0]} :
        (alu_src_1_sel == `ALU_SRC_1_SEL_SXT_9)  ? {{7{ir[8]}},  ir[8:0]} :
        (alu_src_1_sel == `ALU_SRC_1_SEL_SXT_11) ? {{5{ir[10]}}, ir[10:0]} :
                                                   16'd0;

    // ALU
    assign alu_out =
        (alu_en && alu_fn == `ALU_FN_ADD) ? (alu_src_0 + alu_src_1) :
        (alu_en && alu_fn == `ALU_FN_AND) ? (alu_src_0 & alu_src_1) :
        (alu_en && alu_fn == `ALU_FN_NOT) ? (~alu_src_0) :
                                            16'd0;

    // Memory addressing
    assign mem_r_addr_0 =
        (mem_r_addr_sel == `MEM_R_ADDR_SEL_PC ) ? pc :
        (mem_r_addr_sel == `MEM_R_ADDR_SEL_ALU) ? alu_out :
        (mem_r_addr_sel == `MEM_R_ADDR_SEL_IND) ? mem_reg :
                                                  16'd0;

    assign mem_w_addr =
        (mem_w_addr_sel == `MEM_W_ADDR_SEL_ALU) ? alu_out : mem_reg;

    assign mem_w_data =
        (mem_w_data_sel == 1'b0) ? rf_r_data_0 : rf_r_data_1;

    // PC input mux
    assign pc_in =
        (pc_src_sel == `PC_SRC_SEL_REG) ? rf_r_data_0 :
        (pc_src_sel == `PC_SRC_SEL_INC) ? (pc + 1) :
                                          alu_out;

    // Branch enable
    assign br_en =
        (ir[`OC] == `OC_BR) &&
        ((ir[`BR_N] & n_reg) |
         (ir[`BR_Z] & z_reg) |
         (ir[`BR_P] & p_reg));

    //==========================================================================
    // SEQUENTIAL LOGIC
    //==========================================================================
    always @(posedge clk) begin
        if (rst) begin
            pc      <= 16'd0;
            ir      <= 16'd0;
            mem_reg <= 16'd0;
            n_reg   <= 1'b0;
            z_reg   <= 1'b0;
            p_reg   <= 1'b0;
        end else begin
            // PC
            if (pc_rst)
                pc <= 16'd0;
            else if (pc_ld)
                pc <= pc_in;
            else if (pc_up)
                pc <= pc + 1;

            // IR
            if (ir_ld)
                ir <= mem_r_data_0;

            // Memory register
            if (mem_reg_rst)
                mem_reg <= 16'd0;
            else if (mem_reg_ld)
                mem_reg <= mem_r_data_0;

            // NZP flags
            if (nzp_rst) begin
                n_reg <= 0;
                z_reg <= 0;
                p_reg <= 0;
            end else if (nzp_en && rf_w_en) begin
                if (rf_w_data == 16'd0) begin
                    z_reg <= 1;
                    n_reg <= 0;
                    p_reg <= 0;
                end else if (rf_w_data[15]) begin
                    n_reg <= 1;
                    z_reg <= 0;
                    p_reg <= 0;
                end else begin
                    p_reg <= 1;
                    n_reg <= 0;
                    z_reg <= 0;
                end
            end
        end
    end

endmodule












