//`include "arbiter_pri.v"// use arbiter_pri.v
`include "arbiter_RR.v"   // use arbiter_RR.v
`include "slave_0.v"
`include "slave_1.v"

module chip(req,
			slave_id,
			m_data_out,
			m_data_in,
			gnt,
			ack,
			clk,
			rst
			);

//---Input & output Port---//
input clk,rst;
input [2:0] req,slave_id;
input [31:0] m_data_out;

output [2:0] gnt;
output ack;
output [31:0] m_data_in;

//---- Your design code---//
reg [31:0] m_data_in ;
reg ack ;


wire [1:0] wire_sel ;
wire ack_s0 , ack_s1 , wire_ack;
wire [31:0]   s_data_out_0 , s_data_out_1 ;

reg [31:0] data_bus ;



arbiter ar(req, slave_id, gnt,ack, wire_sel,clk, rst)   ;
slave_0 slave_mac(clk, rst,wire_sel[0], data_bus, ack_s0, s_data_out_0) ;
slave_1 slave_FFT(clk, rst,wire_sel[1], data_bus, ack_s1, s_data_out_1) ;


assign wire_ack = ack_s0 | ack_s1 ;


always@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		m_data_in <= 32'd0 ;
	end
	else if(wire_ack)
		begin
		ack<=1;
		m_data_in <= data_bus ;
	     	end
	else begin ack<=0 ; m_data_in <= 32'd0 ; end

end





































always@(*)
casex({ack_s1, ack_s0, |gnt}) 
	3'b1x_x: data_bus=s_data_out_1; 
	3'bx1_x: data_bus=s_data_out_0;
	3'b00_1: data_bus=m_data_out; 
	default: data_bus=m_data_out; 
endcase 

endmodule 