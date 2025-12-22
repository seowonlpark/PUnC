//==============================================================================
// Control Unit for PUnC LC3 Processor
//==============================================================================

`include "Defines.v"

module PUnCControl(
	// External Inputs
	input  wire        clk,            // Clock
	input  wire        rst,            // Reset
	
	input [15:0]       ir,
	input [15:0]       alu_out,
	input              br_en,
	
	// Memory Controls 
	output reg [1:0]   mem_r_addr_sel,
	output reg         mem_w_addr_sel,
	output reg         mem_w_data_sel,
	output reg         mem_w_en,
	
	output reg         mem_reg_ld,
	output reg         mem_reg_rst,

	// Register File Controls
	output reg         rf_r_addr_0_sel,
	output reg         rf_r_addr_1_sel,
	output reg         rf_w_addr_sel,
    output reg [1:0]   rf_w_data_sel,
    output reg         rf_w_en,

	// Instruction Register Controls
	output reg         ir_ld,
	
	// Program Counter Controls
	output reg         pc_ld,
	output reg         pc_up,
	output reg         pc_rst,
	output reg [1:0]   pc_src_sel,

    // ALU	
	output reg [1:0]   alu_src_0_sel,
	output reg [2:0]   alu_src_1_sel,
	
	output reg [1:0]   alu_fn,
	output reg         alu_en,
	
	// nzp
	output reg         nzp_rst,
	output reg         nzp_en

);

	// FSM States
	// Add your FSM State values as localparams here
	// localparam STATE_FETCH     = X'd0;
	// FSM States
    localparam STATE_FETCH      = 5'd0;
    localparam STATE_DECODE     = 5'd1;
    localparam STATE_ADD_R      = 5'd2;
    localparam STATE_ADD_I      = 5'd3;
    localparam STATE_AND_R      = 5'd4;
    localparam STATE_AND_I      = 5'd5;
    localparam STATE_NOT        = 5'd6;
    localparam STATE_BRANCH     = 5'd7;
    localparam STATE_JUMP       = 5'd8;
    localparam STATE_JSR        = 5'd9;
    localparam STATE_JSR_REG    = 5'd10;
    localparam STATE_LD         = 5'd11;
    localparam STATE_LDI_1      = 5'd12;
    localparam STATE_LDI_2      = 5'd13;
    localparam STATE_LDR        = 5'd14;
    localparam STATE_LEA        = 5'd15;
    localparam STATE_ST         = 5'd16;
    localparam STATE_STI_1      = 5'd17;
    localparam STATE_STI_2      = 5'd18;
    localparam STATE_STR        = 5'd19;
    localparam STATE_RET        = 5'd20;
    localparam STATE_HALT       = 5'd21;

	// State, Next State
	reg [5:0] state, next_state;

	// Output Combinational Logic
	always @( * ) begin
		// Set default values for outputs here (prevents implicit latching)
        mem_w_en = 0;
        mem_reg_ld = 0;
        mem_reg_rst = 0;
        rf_w_en = 0;
        ir_ld = 0;
        pc_up = 0;
        pc_ld = 0;
        nzp_en = 0;
        nzp_rst = 0;
        
		// Add your output logic here
        case (state)
            STATE_FETCH: begin
                mem_r_addr_sel = `MEM_R_ADDR_SEL_PC;
                mem_reg_rst = 0;
                rf_w_en = 0;
                ir_ld = 1;
                pc_ld = 0;
                pc_up = 1;
                pc_rst = 0;
                alu_en = 0;
                nzp_en = 0;
            end
        
            STATE_DECODE: begin
                pc_up = 0;

                mem_reg_rst = 0;
                
                nzp_en = 0;
            end
        
            STATE_ADD_R: begin
                ir_ld = 0;
                pc_up = 0;
                
                rf_r_addr_0_sel = `RF_R_ADDR_0_SEL_8_6;
                rf_r_addr_1_sel = `RF_R_ADDR_1_SEL_2_0;
                rf_w_addr_sel = `RF_W_ADDR_SEL_11_9;
                rf_w_data_sel = `RF_W_DATA_SEL_ALU;
                rf_w_en = 1;

                alu_src_0_sel = `ALU_SRC_0_SEL_REG_0;
                alu_src_1_sel = `ALU_SRC_1_SEL_REG_1;
                alu_en = 1;
                
                nzp_en = 1;
                
                alu_fn = `ALU_FN_ADD;
            end
        
            STATE_ADD_I: begin
                ir_ld = 0;
                pc_up = 0;
                
                rf_r_addr_0_sel = `RF_R_ADDR_0_SEL_8_6;
                rf_r_addr_1_sel = `RF_R_ADDR_1_SEL_2_0;
                rf_w_addr_sel = `RF_W_ADDR_SEL_11_9;
                rf_w_data_sel = `RF_W_DATA_SEL_ALU;
                rf_w_en = 1;
                
                alu_src_0_sel = `ALU_SRC_0_SEL_REG_0;
                alu_src_1_sel = `ALU_SRC_1_SEL_SXT_5;
                alu_en = 1;
                
                nzp_en = 1;
                
                alu_fn = `ALU_FN_ADD;
            end
        
            STATE_AND_R: begin
                ir_ld = 0;
                pc_up = 0;
                
                rf_r_addr_0_sel = `RF_R_ADDR_0_SEL_8_6;
                rf_r_addr_1_sel = `RF_R_ADDR_1_SEL_2_0;
                rf_w_addr_sel = `RF_W_ADDR_SEL_11_9;
                rf_w_data_sel = `RF_W_DATA_SEL_ALU;
                rf_w_en = 1;

                alu_src_0_sel = `ALU_SRC_0_SEL_REG_0;
                alu_src_1_sel = `ALU_SRC_1_SEL_REG_1;
                alu_en = 1;
                
                nzp_en = 1;
                
                alu_fn = `ALU_FN_AND;
            end
        
            STATE_AND_I: begin
                ir_ld = 0;
                pc_up = 0;
                
                rf_r_addr_0_sel = `RF_R_ADDR_0_SEL_8_6;
                rf_w_addr_sel = `RF_W_ADDR_SEL_11_9;
                rf_w_data_sel = `RF_W_DATA_SEL_ALU;
                rf_w_en = 1;

                alu_src_0_sel = `ALU_SRC_0_SEL_REG_0;
                alu_src_1_sel = `ALU_SRC_1_SEL_SXT_5;
                alu_en = 1;
                
                nzp_en = 1;
                
                alu_fn = `ALU_FN_AND;
            end
        
            STATE_NOT: begin
                pc_up = 0;
                ir_ld = 0;
    
                rf_r_addr_0_sel = `RF_R_ADDR_0_SEL_8_6;
                rf_w_addr_sel = `RF_W_ADDR_SEL_11_9;
                rf_w_data_sel = `RF_W_DATA_SEL_ALU;
                rf_w_en = 1;
    
                alu_src_0_sel = `ALU_SRC_0_SEL_REG_0;
                alu_src_1_sel = `ALU_SRC_1_SEL_REG_1;
                alu_fn = `ALU_FN_NOT;
                alu_en = 1;
    
                nzp_en = 1;
            end
        
            STATE_BRANCH: begin
                pc_ld = 0;
                pc_up = 0;
                ir_ld = 0;
                
                alu_src_0_sel = `ALU_SRC_0_SEL_PC;
                alu_src_1_sel = `ALU_SRC_1_SEL_SXT_9;
                alu_fn = `ALU_FN_ADD;
                alu_en = 1;
    
                pc_src_sel = `PC_SRC_SEL_ALU;
                
                if (br_en) begin
                    pc_ld = 1;
                    pc_src_sel = `PC_SRC_SEL_ALU;
                end
    
                nzp_en = 0;
            end
            
            STATE_JUMP: begin
                pc_ld = 1;
                pc_up = 0;
                ir_ld = 0;
                
                mem_w_en = 0;
                
                rf_r_addr_0_sel = `RF_R_ADDR_0_SEL_8_6;
                rf_w_en = 0;
                
                alu_en = 0;
                
                nzp_rst = 0;
                pc_src_sel = `PC_SRC_SEL_REG;
            end
        
            STATE_JSR: begin
                pc_ld = 1;
                pc_up = 0;
                ir_ld = 0;
    
                rf_w_addr_sel = `RF_W_ADDR_SEL_7_CN;
                rf_w_data_sel = `RF_W_DATA_SEL_PC;
                rf_w_en = 1;
                
                pc_src_sel = `PC_SRC_SEL_ALU;

                alu_src_0_sel = `ALU_SRC_0_SEL_PC;
                alu_src_1_sel = `ALU_SRC_1_SEL_SXT_11;
                alu_fn = `ALU_FN_ADD;
                alu_en = 1;
            end
        
            STATE_JSR_REG: begin
                pc_up = 0;
                ir_ld = 0;
                
                rf_r_addr_0_sel = `RF_R_ADDR_0_SEL_8_6;
                
                pc_src_sel = `PC_SRC_SEL_REG;
            end
        
            STATE_LD: begin
                pc_up = 0;
                ir_ld = 0;
    
                mem_r_addr_sel  = `MEM_R_ADDR_SEL_ALU;
    
                rf_w_addr_sel   = `RF_W_ADDR_SEL_11_9;
                rf_w_data_sel   = `RF_W_DATA_SEL_MEM;
                rf_w_en         = 1;
                
                alu_src_0_sel = `ALU_SRC_0_SEL_PC;
                alu_src_1_sel = `ALU_SRC_1_SEL_SXT_9;
                alu_fn = `ALU_FN_ADD;
                alu_en = 1;
    
                nzp_en = 1;
            end
        
            STATE_LDI_1: begin
                pc_up = 0;
                ir_ld = 0;
                
                mem_r_addr_sel = `MEM_R_ADDR_SEL_ALU;
                mem_reg_ld = 1;
                mem_reg_rst = 0;
                    
                alu_src_0_sel = `ALU_SRC_0_SEL_PC;
                alu_src_1_sel = `ALU_SRC_1_SEL_SXT_9;
                alu_fn = `ALU_FN_ADD;
                alu_en = 1;
                
                nzp_en = 1;
            end
        
            STATE_LDI_2: begin
                pc_up = 0;
                ir_ld = 0;
    
                mem_r_addr_sel = `MEM_R_ADDR_SEL_IND;
                mem_reg_rst = 0;
    
                rf_w_addr_sel = `RF_W_ADDR_SEL_11_9;
                rf_w_data_sel = `RF_W_DATA_SEL_MEM;
                rf_w_en = 1;
    
                nzp_en = 1;
            end
        
            STATE_LDR: begin
                pc_up = 0;
                ir_ld = 0;
                
                mem_r_addr_sel = `MEM_R_ADDR_SEL_ALU;

                rf_r_addr_0_sel = `RF_R_ADDR_0_SEL_8_6;
                rf_w_addr_sel = `RF_W_ADDR_SEL_11_9;
                rf_w_data_sel = `RF_W_DATA_SEL_MEM;
                rf_w_en = 1;
    
                alu_src_0_sel = `ALU_SRC_0_SEL_REG_0;
                alu_src_1_sel = `ALU_SRC_1_SEL_SXT_6;
                alu_fn = `ALU_FN_ADD;
                alu_en = 1;
    
                nzp_en = 1;
            end
        
            STATE_LEA: begin
                pc_up = 0;
                ir_ld = 0;

                rf_w_addr_sel = `RF_W_ADDR_SEL_11_9;
                rf_w_data_sel = `RF_W_DATA_SEL_ALU;
                rf_w_en = 1;
                
                alu_src_0_sel = `ALU_SRC_0_SEL_PC;
                alu_src_1_sel = `ALU_SRC_1_SEL_SXT_9;
                alu_fn = `ALU_FN_ADD;
                alu_en = 1;
    
                nzp_en = 1;
            end
        
            STATE_ST: begin
                pc_up = 0;
                ir_ld = 0;
    
                mem_w_addr_sel = `MEM_W_ADDR_SEL_ALU;
                mem_w_data_sel = 1'b0;
                mem_w_en = 1;
    
                rf_r_addr_0_sel = `RF_R_ADDR_0_SEL_11_9;
    
                alu_src_0_sel = `ALU_SRC_0_SEL_PC;
                alu_src_1_sel = `ALU_SRC_1_SEL_SXT_9;
                alu_fn = `ALU_FN_ADD;
                alu_en = 1;
            end
            STATE_STI_1: begin
                pc_up = 0;
                ir_ld = 0;
            
                mem_r_addr_sel = `MEM_R_ADDR_SEL_ALU;
                mem_reg_ld = 1;
            
                alu_src_0_sel = `ALU_SRC_0_SEL_PC;
                alu_src_1_sel = `ALU_SRC_1_SEL_SXT_9;
                alu_fn = `ALU_FN_ADD;
                alu_en = 1;
            
                mem_w_en = 0;
            end
            
            STATE_STI_2: begin
                pc_up = 0;
                ir_ld = 0;
            
                mem_w_addr_sel = `MEM_W_ADDR_SEL_IND;
                mem_w_data_sel = 1'b0;
                mem_w_en = 1;
            
                rf_r_addr_0_sel = `RF_R_ADDR_0_SEL_11_9;
            
                alu_en = 0;
            end
            
            STATE_STR: begin
                rf_r_addr_0_sel = `RF_R_ADDR_0_SEL_11_9;
                rf_r_addr_1_sel = `RF_R_ADDR_1_SEL_8_6;
            
                alu_src_0_sel = `ALU_SRC_0_SEL_REG_1;
                alu_src_1_sel = `ALU_SRC_1_SEL_SXT_6;
                alu_fn = `ALU_FN_ADD;
                alu_en = 1;
            
                mem_w_addr_sel = `MEM_W_ADDR_SEL_ALU;
                mem_w_data_sel = 1'b0;
                mem_w_en = 1;
            end
            
            STATE_RET: begin
                pc_ld = 1;
                pc_up = 0;
                ir_ld = 0;
    
                rf_r_addr_0_sel = `RF_R_ADDR_0_SEL_8_6;
                
                pc_src_sel = `PC_SRC_SEL_REG;
            end
        
            STATE_HALT: begin
               ir_ld = 0;
               pc_up = 0;
            end
        
        endcase 

	end

	// Next State Combinational Logic
	always @( * ) begin
		// Set default value for next state here
		next_state = state;

		// Add your next-state logic here
		case (state)
            STATE_FETCH: begin
		      if (ir_ld) begin
		          next_state = STATE_DECODE;
		      end
			end
			
			STATE_DECODE: begin
		      if (ir[`OC] == `OC_ADD) begin
		          nzp_rst = 1;
		          if (ir[`IMM_BIT_NUM] == 0) begin
		              next_state = STATE_ADD_R;
		          end
		          else begin
		              next_state = STATE_ADD_I;
		          end   
		      end
		      if (ir[`OC] == `OC_AND) begin
		          nzp_rst = 1;
                 if (ir[`IMM_BIT_NUM] == 0) begin
		              next_state = STATE_AND_R;
		          end
		          else begin
		              next_state = STATE_AND_I;
		          end   
		      end
		      if (ir[`OC] == `OC_BR) begin
		          next_state = STATE_BRANCH;
		      end
		      if (ir[`OC] == `OC_JMP) begin
		          nzp_rst = 1;
		          if (ir == `RET_MATCH) begin
		              next_state = STATE_RET;
		          end
		          else begin
		              next_state = STATE_JUMP;
		          end
		      end
		      if (ir[`OC] == `OC_JSR) begin
		          nzp_rst = 1;
		          if (ir[`JSR_BIT_NUM] == 1) begin
		              next_state = STATE_JSR;
		          end
		          else begin
		              next_state = STATE_JSR_REG;
		          end
		      end
		      if (ir[`OC] == `OC_LD) begin
		          nzp_rst = 1;
		          next_state = STATE_LD;
		      end
		      if (ir[`OC] == `OC_LDI) begin
		          nzp_rst = 1;
		          next_state = STATE_LDI_1;
		      end
		      if (ir[`OC] == `OC_LDR) begin
		          nzp_rst = 1;
		          next_state = STATE_LDR;
		      end
		      if (ir[`OC] == `OC_LEA) begin
		          nzp_rst = 1;
		          next_state = STATE_LEA;
		      end
		      if (ir[`OC] == `OC_NOT) begin
		          nzp_rst = 1;
		          next_state = STATE_NOT;
		      end
		      if (ir[`OC] == `OC_ST) begin
		          nzp_rst = 1;
		          next_state = STATE_ST;
		      end
		      if (ir[`OC] == `OC_STI) begin
		          nzp_rst = 1;
		          next_state = STATE_STI_1;
		      end
		      if (ir[`OC] == `OC_STR) begin
		          nzp_rst = 1;
		          next_state = STATE_STR;
		      end
		      if (ir[`OC] == `OC_HLT) begin
		          nzp_rst = 1;
		          next_state = STATE_HALT;
		      end
			end
			STATE_ADD_R: begin
			    next_state = STATE_FETCH;
			end
			STATE_ADD_I: begin
			    next_state = STATE_FETCH;
			end
			STATE_AND_R: begin
			    next_state = STATE_FETCH;
			end
			STATE_AND_I: begin
			    next_state = STATE_FETCH;
			end
			STATE_BRANCH: begin
			    next_state = STATE_FETCH;
		        nzp_rst = 0;
			end
			STATE_JUMP: begin
			    next_state = STATE_FETCH;
			end
			STATE_JSR: begin
			    next_state = STATE_FETCH;
			end
			STATE_JSR_REG: begin
			    next_state = STATE_FETCH;
			end
			STATE_LD: begin
			    next_state = STATE_FETCH;
			end
			STATE_LDI_1: begin
			    next_state = STATE_LDI_2;
			end
			STATE_LDI_2: begin
			    next_state = STATE_FETCH;
			end
			STATE_LDR: begin
			    next_state = STATE_FETCH;
			end
			STATE_LEA: begin
			    next_state = STATE_FETCH;
			end
			STATE_NOT: begin
			    next_state = STATE_FETCH;
			end
			STATE_RET: begin
			    next_state = STATE_FETCH;
			end
			STATE_ST: begin
			    next_state = STATE_FETCH;
			end
			STATE_STI_1: begin
			    next_state = STATE_STI_2;
			end
			STATE_STI_2: begin
			    next_state = STATE_FETCH;
			end
			STATE_STR: begin
			    next_state = STATE_FETCH;
			end
			STATE_HALT: begin
			    next_state = STATE_HALT;
			end
		endcase
	end

 	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			// Add your initial state here
			state <= STATE_FETCH;
			pc_rst = 1;
		end
		else begin
			// Add your next state here
			state <= next_state;
		end
	end

endmodule






