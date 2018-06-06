module slave_0(	clk,
				rst,
				sel,
				s_data_in_0,
				ack,
				s_data_out_0
				);
//---Input & output Port---//			
input  [31:0]	 s_data_in_0;
input			sel,     clk, rst;

output  [31:0] s_data_out_0;
output 		         ack;


//---- Your design code---//
reg  [31:0] s_data_out_0;
reg ack =0 ; 
 
reg  [7:0] mac_dataA=8'd0 , mac_dataB=8'd0 ;
reg  [31:0] reg_product = 32'd0 , reg_compute = 32'd0;
reg data_in = 0 , mac_product=0 , mac_compute=0;
reg [3:0] counter = 4'b0000;

always@(posedge clk or posedge rst)
	begin

		if(rst)
		begin
			s_data_out_0 <= 31'd0;
			ack <= 0 ;
		end
		if (sel)
		begin
		if(counter == 4'd8)
		begin
			s_data_out_0 <= reg_compute;
			ack <= 1 ;
		end
		else
			ack <= 0 ;
		end
	end

always@(posedge clk or posedge rst)
	begin
	if (rst)
		counter <= 4'd0 ;
	else if (sel)
	begin
		if(counter == 4'd12)
		counter <= 4'd0 ;
		else 
		counter <= counter + 1 ;
	end
end

always@(posedge clk)
	begin
	if (sel)
	begin
	mac_dataA <= s_data_in_0 [15:8] ;
	mac_dataB <= s_data_in_0 [7:0]  ;
	end
	end

always@(*)
	begin
	reg_product = mac_dataA * mac_dataB ;
	end

always@(*)
	begin
	if(counter == 4'd0)
		begin
		reg_compute = reg_product;
		end
	else if (counter == 4'd1 || counter == 4'd2 || counter == 4'd3 || counter == 4'd4 || counter == 4'd5 || counter == 4'd6 || counter == 4'd7 || counter ==4'd8)
		begin
		reg_compute = reg_compute + reg_product ;
		end
	end









































		
endmodule