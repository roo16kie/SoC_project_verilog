module slave_1(	clk,
				rst,
				sel,
				s_data_in_1,
				ack,
				s_data_out_1
				);

//---Input & output Port---//

input		clk;
input		rst;
input		sel;
input	[31:0]	s_data_in_1;
output		ack;
output 	[31:0] 	s_data_out_1;

///////////////
// parameter //
///////////////
parameter signed W0_I = 32'h00000000;  
parameter signed W1_I = 32'hFFFF4AFC;  
parameter signed W2_I = 32'hFFFF0000;  
parameter signed W3_I = 32'hFFFF4AFC;  
parameter signed W0_R = 32'h00010000; 
parameter signed W1_R = 32'h0000B504; 
parameter signed W2_R = 32'h00000000; 
parameter signed W3_R = 32'hFFFF4AFC; 

//---- Your design code---//
reg ack = 0; reg [31:0] s_data_out_1 = 32'd0 ;

reg [3:0] counter ;

reg    signed   [15:0]  reg_data0  , reg_data1 , reg_data2 , reg_data3  , reg_data4  , reg_data5  , reg_data6  , reg_data7  ;
wire   signed   [15:0] j0r , j1r , j2r , j3r , j4r , j5r , j6r , j7r ;
wire   signed   [15:0] j0i , j1i , j2i , j3i , j4i , j5i , j6i , j7i ;
wire   signed   [15:0] k0r , k1r , k2r , k3r , k4r , k5r , k6r , k7r ;
wire   signed   [15:0] k0i , k1i , k2i , k3i , k4i , k5i , k6i , k7i ;
wire   signed   [15:0] m0r , m1r , m2r , m3r , m4r , m5r , m6r , m7r ;
wire   signed   [15:0] m0i , m1i , m2i , m3i , m4i , m5i , m6i , m7i ;
reg    signed   [31:0] reg_fft0 = 32'd0 , reg_fft1 = 32'd0 , reg_fft2 = 32'd0 , reg_fft3 = 32'd0 , reg_fft4 = 32'd0 , reg_fft5 = 32'd0 , reg_fft6 = 32'd0 , reg_fft7 = 32'd0 ; 


	butterfly0 shit0(j0r,j0i,j1r,j1i,reg_data0,16'd0,reg_data4,16'd0,W0_R,W0_I);
	butterfly0 shit1(j2r,j2i,j3r,j3i,reg_data2,16'd0,reg_data6,16'd0,W0_R,W0_I);
	butterfly0 shit2(j4r,j4i,j5r,j5i,reg_data1,16'd0,reg_data5,16'd0,W0_R,W0_I);
	butterfly0 shit3(j6r,j6i,j7r,j7i,reg_data3,16'd0,reg_data7,16'd0,W0_R,W0_I);	

	butterfly1 pig0(k0r,k0i,k2r,k2i,j0r,j0i,j2r,j2i,W0_R,W0_I);
	butterfly1 pig1(k1r,k1i,k3r,k3i,j1r,j1i,j3r,j3i,W2_R,W2_I);
	butterfly1 pig2(k4r,k4i,k6r,k6i,j4r,j4i,j6r,j6i,W0_R,W0_I);
	butterfly1 pig3(k5r,k5i,k7r,k7i,j5r,j5i,j7r,j7i,W2_R,W2_I);

	butterfly1 kiwi0(m0r,m0i,m4r,m4i,k0r,k0i,k4r,k4i,W0_R,W0_I);
	butterfly1 kiwi1(m1r,m1i,m5r,m5i,k1r,k1i,k5r,k5i,W1_R,W1_I);
	butterfly1 kiwi2(m2r,m2i,m6r,m6i,k2r,k2i,k6r,k6i,W2_R,W2_I);
	butterfly1 kiwi3(m3r,m3i,m7r,m7i,k3r,k3i,k7r,k7i,W3_R,W3_I);

always@(posedge clk or posedge rst)
begin	
	if(rst)
		counter <= 4'd0;
	else if (counter == 4'd14 && sel==1)
		counter <= 4'd0;
	else if (sel==1)
		counter <= counter + 1 ;
end

always@(posedge clk or posedge rst)
begin

	if (rst)
		ack <= 0 ;
	else if (sel)
	begin
	if (counter==4'd0 || counter==4'd1 || counter==4'd2 || counter==4'd3 || counter==4'd12 || counter==4'd13 || counter==4'd14 || counter==4'd15)
		ack <= 0 ;
	else if (counter==4'd4 || counter==4'd5 || counter==4'd6 || counter==4'd7 || counter==4'd8 || counter==4'd9 || counter==4'd10 || counter==4'd11 )
		ack <= 1 ;
	end
end

always@(posedge clk or posedge rst)
begin

	if(rst)
		s_data_out_1 <= 32'd0 ;
	else if(sel)
	begin
	if (counter==4'd0 || counter==4'd1 || counter==4'd2 || counter==4'd3)
		s_data_out_1 <= 32'd0 ;
	else if (counter == 4'd4)
		s_data_out_1 <= reg_fft0 ;
	else if (counter == 4'd5)
		s_data_out_1 <= reg_fft1 ;	
	else if (counter == 4'd6)
		s_data_out_1 <= reg_fft2 ;
	else if (counter == 4'd7)
		s_data_out_1 <= reg_fft3 ;
	else if (counter == 4'd8)
		s_data_out_1 <= reg_fft4 ;
	else if (counter == 4'd9)
		s_data_out_1 <= reg_fft5 ;
	else if (counter == 4'd10)
		s_data_out_1 <= reg_fft6 ;
	else if (counter == 4'd11)
		s_data_out_1 <= reg_fft7 ;
	end
end

always@(posedge clk or posedge rst)
begin
	
	if(rst)
		begin reg_data0 <= 16'd0 ; reg_data1 <= 16'd0 ; reg_data2 <= 16'd0 ; reg_data3 <= 16'd0 ; reg_data4 <= 16'd0 ; reg_data5 <= 16'd0 ; reg_data6 <= 16'd0 ; reg_data7 <= 16'd0 ;  end 
	else if (sel)
	begin
	if (counter == 4'd0)
		begin reg_data0 <= s_data_in_1[31:16] ; reg_data1 <= s_data_in_1[15:0] ; end
	else if (counter == 4'd1)
		begin reg_data2 <= s_data_in_1[31:16] ; reg_data3 <= s_data_in_1[15:0] ; end
	else if (counter == 4'd2)
		begin reg_data4 <= s_data_in_1[31:16] ; reg_data5 <= s_data_in_1[15:0] ; end
	else if (counter == 4'd3)
		begin reg_data6 <= s_data_in_1[31:16] ; reg_data7 <= s_data_in_1[15:0] ; end
	end
end


always@(*)
begin
	 reg_fft0 = {m0r , m0i} ; reg_fft1 = {m1r , m1i} ; reg_fft2 = {m2r , m2i} ; reg_fft3 = {m3r , m3i} ;
	 reg_fft4 = {m4r , m4i} ; reg_fft5 = {m5r , m5i} ; reg_fft6 = {m6r , m6i} ; reg_fft7 = {m7r , m7i} ;
end


	
endmodule


module butterfly0 (ar,ai,br,bi,xr,xi,yr,yi,w0r,w0i);

input     signed    [15:0]   xr ,yr ,xi ,yi ;
input     signed    [31:0]   w0r , w0i ;
output    signed    [15:0]   ar ,ai ,br ,bi  ;

assign ar = xr + yr ;
assign ai = xi ;
assign br = xr - yr ;
assign bi = xi ;

endmodule

module butterfly1 (ar,ai,br,bi,xr,xi,yr,yi,w0r,w0i);

input    signed   [15:0]   xr ,xi ,yr ,yi  ;
input	 signed   [31:0]   w0r,w0i;
output   signed   [15:0]   ar ,ai ,br ,bi ;
wire     signed   [47:0]   dick_re1 , dick_im1 , dick_re2 , dick_im2 ;
wire	 signed	  [47:0]   far ,fai ,fbr ,fbi ;

assign dick_re1 = yr * w0r ;
assign dick_re2 = yi * w0i ;
assign dick_im1 = yr * w0i ;
assign dick_im2 = yi * w0r ;
assign    far    = (xr<<16) + dick_re1 - dick_re2 ;
assign    fai    = (xi<<16) + dick_im1 + dick_im2 ;
assign    fbr    = (xr<<16) - dick_re1 + dick_re2 ;
assign    fbi    = (xi<<16) - dick_im1 - dick_im2 ;
assign   ar     = far[31:16];
assign   ai     = fai[31:16];
assign   br     = fbr[31:16];
assign   bi     = fbi[31:16];

endmodule
