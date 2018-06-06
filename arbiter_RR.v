module arbiter(req, slave_id, gnt,ack,  sel,clk, rst);

//---Input & output Port---//

input clk, rst;
input [2:0] req, slave_id;
input ack;
output [2:0] gnt;
output [1:0] sel;

//----Parameter---//

parameter IDLE=2'b00;
parameter M0=2'b01;
parameter M1=2'b10;
parameter M2=2'b11;

//---- Your design code---//
wire [2:0] gnt ;
wire [1:0] sel ;
reg cmd_done ;

reg ack_r;
reg [1:0] state_ns =2'b01 , state_cs =2'b01 ;
reg [2:0] reg_gnt   ; 
reg [1:0] reg_sel   ;


assign gnt = reg_gnt ;
assign sel = reg_sel ;

always@(posedge clk)
	begin
	 cmd_done = ~ack & ack_r ;
	end

always@(posedge clk)
begin
	ack_r <= ack ;
end



always@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		state_cs <= IDLE ;
	end
	else 
	begin
		state_cs <= state_ns ;	
	end
end

always@(*)
begin

	case(state_cs)
	IDLE: if(req[0])
		state_ns = M0 ;
	      else if (req[1])
		state_ns = M1 ;
	      else if (req[2])
		state_ns = M2 ;

	M0: if (cmd_done & req[1])
		state_ns = M1 ;
	    else if (cmd_done & req[2])
		state_ns = M2 ;
	    else if (cmd_done)
		state_ns = IDLE ;

	M1:if (cmd_done & req[2])
		state_ns = M2 ;
	   else if (cmd_done & req[0])
		state_ns = M0 ;
	   else if (cmd_done)
		state_ns = IDLE ;

	M2:if (cmd_done & req[0])
		state_ns = M0 ;
	   else if (cmd_done & req[1])
		state_ns = M1 ;
	   else if (cmd_done)
		state_ns = IDLE ;	
	endcase 

end


always@(*)
begin
	case(state_ns)
	
	IDLE: begin reg_gnt = 3'b000 ; reg_sel = 2'b00 ; end
	
	M0: begin reg_gnt = 3'b001 ; 
		  if(slave_id[0]==1) 
			begin reg_sel[1] = 1 ; reg_sel[0] = 0 ; end
		  else if (slave_id[0]==0)
			begin reg_sel[1] = 0 ; reg_sel[0] = 1 ; end
	    end

	M1:begin reg_gnt = 3'b010 ;
		  if(slave_id[1]==1) 
			begin reg_sel[1] = 1 ; reg_sel[0] = 0 ; end
		  else if (slave_id[1]==0)
			begin reg_sel[1] = 0 ; reg_sel[0] = 1 ; end
	    end

	M2:begin reg_gnt = 3'b100 ;
		  if(slave_id[2]==1) 
			begin reg_sel[1] = 1 ; reg_sel[0] = 0 ; end
		  else if (slave_id[2]==0)
			begin reg_sel[1] = 0 ; reg_sel[0] = 1 ; end
	    end
	

	endcase
end	


























  
endmodule