`timescale 1ns/10ps
`define CYCLE	10	// Modify your clock period here
`define End_CYCLE  50000

module testfixture;

reg	clk ;
reg	rst ; 
reg  [2:0]  req, slave_id; 
reg  [31:0] data_out;

wire [2:0]  gnt; 
wire [31:0] data_in;
wire        ack;

reg  [31:0] data_out_0, data_out_1, data_out_2;
reg [31:0] mac_out;
reg [31:0] mac_in [0:7];
reg [31:0] fft_in [0:3];
reg [31:0] fft_out [0:7];
reg [15:0] fft_in_tmep1, fft_in_tmep2;
reg fft_fail;


parameter signed W = 16'h00B5; 

chip chip(.req(req),
		.slave_id(slave_id),
		.m_data_out(data_out),
		.m_data_in(data_in),
		.gnt(gnt),
		.ack(ack),
		.clk(clk),
		.rst(rst)
		);
		
integer i,err,check,check_1_7;

/* 
initial begin
$fsdbDumpfile("SOC.fsdb");
$fsdbDumpvars;
end */

always begin #(`CYCLE/2) clk = ~clk; end

//initial value//
initial begin
clk=1'b0;
rst=1'b0;
err=0;
check=0;
check_1_7=0;
@(negedge clk) rst=1'b1 ;
#(`CYCLE*2) rst=1'b0 ;
end

//Master_0//
initial begin
@(negedge rst)
while(1)
begin
	#((({$random}%10)+1)*`CYCLE);
	req[0]=1;
	slave_id[0]= {$random}%2;
	wait(gnt[0]);
	if (slave_id[0]==0)
	begin
		for(i=0;i<=7;i=i+1)
		begin
			@(negedge clk);
			data_out_0 = $random;
			mac_in[i]=data_out_0;
		end
		mac(mac_in[0],
			mac_in[1],
			mac_in[2],
			mac_in[3],
			mac_in[4],
			mac_in[5],
			mac_in[6],
			mac_in[7],
			mac_out);
		@(negedge clk);
		data_out_0 = 0;
		wait(ack);
		@(negedge clk);
		if(data_in==mac_out)
			check = check+1;
		else	
		begin
			err=err+1;
			$display($time,"MAC_Error:") ;
			$display($time,"Expect   : mac_out=%8h",mac_out);
    		$display($time,"Your ans : mac_out=%8h\n\n",data_in);	
		end
		@(negedge ack);
		# `CYCLE ;
		req[0] = 0;		
	end
	else if (slave_id[0]==1)
	begin
		for(i=0;i<=3;i=i+1)
		begin
			@(negedge clk);
			fft_in_tmep1 = $random%256;
			fft_in_tmep2 = $random%256;
			data_out_0 = {{8{fft_in_tmep1[8]}},fft_in_tmep1[7:0],{8{fft_in_tmep2[8]}},fft_in_tmep2[7:0]};
			fft_in[i] = data_out_0;	
		end
		fft(fft_in[0],
			fft_in[1],
			fft_in[2],
			fft_in[3],
			fft_out[0],
			fft_out[1],
			fft_out[2],
			fft_out[3],
			fft_out[4],
			fft_out[5],
			fft_out[6],
			fft_out[7]);
		@(negedge clk);
		data_out_0 = 0;
		wait(ack)
		for(i=0;i<=7;i=i+1)
		begin
			@(negedge clk);
			fft_verify(fft_out[i], data_in, fft_fail);
			if(!fft_fail)
				check_1_7 = check_1_7+1;
			else
			begin
				err=err+1;
				$display($time,"FFT_Error:") ;
				$display($time,"Expect   : fft_out=%8h",fft_out[i]);
				$display($time,"Your ans : fft_out=%8h\n\n",data_in);	
			end					
		end
		@(negedge ack);
		#(`CYCLE);
		req[0]=0;
		if(check_1_7==8)
			check = check+1;
		check_1_7 = 0;
	end
end
end

//Master_1//
initial begin
@(negedge rst)
while(1)
begin
	#((({$random}%10)+1)*`CYCLE);
	req[1]=1;
	slave_id[1]= {$random}%2;
	wait(gnt[1]);
	if (slave_id[1]==0)
	begin
		for(i=0;i<=7;i=i+1)
		begin
			@(negedge clk);
			data_out_1 = $random;
			mac_in[i]=data_out_1;
		end
		mac(mac_in[0],
			mac_in[1],
			mac_in[2],
			mac_in[3],
			mac_in[4],
			mac_in[5],
			mac_in[6],
			mac_in[7],
			mac_out);
		@(negedge clk);
		data_out_1 = 0;
		wait(ack);
		@(negedge clk);
		if(data_in==mac_out)
			check = check+1;
		else	
		begin
			err=err+1;
			$display($time,"MAC_Error:") ;
			$display($time,"Expect   : mac_out=%8h",mac_out);
    		$display($time,"Your ans : mac_out=%8h\n\n",data_in);	
		end
		@(negedge ack);
		# `CYCLE ;
		req[1] = 0;		
	end
	else if (slave_id[1]==1)
	begin
		for(i=0;i<=3;i=i+1)
		begin
			@(negedge clk);
			fft_in_tmep1 = $random%256;
			fft_in_tmep2 = $random%256;
			data_out_1 = {{8{fft_in_tmep1[8]}},fft_in_tmep1[7:0],{8{fft_in_tmep2[8]}},fft_in_tmep2[7:0]};
			fft_in[i] = data_out_1;	
		end
		fft(fft_in[0],
			fft_in[1],
			fft_in[2],
			fft_in[3],
			fft_out[0],
			fft_out[1],
			fft_out[2],
			fft_out[3],
			fft_out[4],
			fft_out[5],
			fft_out[6],
			fft_out[7]);
		@(negedge clk);
		data_out_1 = 0;
		wait(ack)
		for(i=0;i<=7;i=i+1)
		begin
			@(negedge clk);
			fft_verify(fft_out[i], data_in, fft_fail);
			if(!fft_fail)
				check_1_7 = check_1_7+1;
			else
			begin
				err=err+1;
				$display($time,"FFT_Error:") ;
				$display($time,"Expect   : fft_out=%8h",fft_out[i]);
				$display($time,"Your ans : fft_out=%8h\n\n",data_in);	
			end	
		end
		@(negedge ack);
		#(`CYCLE);
		req[1]=0;
		if(check_1_7==8)
			check = check+1;
			
		check_1_7 = 0;
	end
end
end

//Master_2//
initial begin
@(negedge rst)
while(1)
begin
	#((({$random}%10)+1)*`CYCLE);
	req[2]=1;
	slave_id[2]= {$random}%2;
	wait(gnt[2]);
	if (slave_id[2]==0)
	begin
		for(i=0;i<=7;i=i+1)
		begin
			@(negedge clk);
			data_out_2 = $random;
			mac_in[i]=data_out_2;
		end
		mac(mac_in[0],
			mac_in[1],
			mac_in[2],
			mac_in[3],
			mac_in[4],
			mac_in[5],
			mac_in[6],
			mac_in[7],
			mac_out);
		@(negedge clk);
		data_out_2 = 0;
		wait(ack);
		@(negedge clk);
		if(data_in==mac_out)
			check = check+1;
		else	
		begin
			err=err+1;
			$display($time,"MAC_Error:") ;
			$display($time,"Expect   : mac_out=%8h",mac_out);
    		$display($time,"Your ans : mac_out=%8h\n\n",data_in);	
		end
		@(negedge ack);
		# `CYCLE ;
		req[2] = 0;		
	end
	else if (slave_id[2]==1)
	begin
		for(i=0;i<=3;i=i+1)
		begin
			@(negedge clk);
			fft_in_tmep1 = $random%256;
			fft_in_tmep2 = $random%256;
			data_out_2 = {{8{fft_in_tmep1[8]}},fft_in_tmep1[7:0],{8{fft_in_tmep2[8]}},fft_in_tmep2[7:0]};
			fft_in[i] = data_out_2;	
		end
		fft(fft_in[0],
			fft_in[1],
			fft_in[2],
			fft_in[3],
			fft_out[0],
			fft_out[1],
			fft_out[2],
			fft_out[3],
			fft_out[4],
			fft_out[5],
			fft_out[6],
			fft_out[7]);
		@(negedge clk);
		data_out_2 = 0;
		wait(ack)
		for(i=0;i<=7;i=i+1)
		begin
			@(negedge clk);
			fft_verify(fft_out[i], data_in, fft_fail);
			if(!fft_fail)
				check_1_7 = check_1_7+1;
			else
			begin
				err=err+1;
				$display($time,"FFT_Error:") ;
				$display($time,"Expect   : fft_out=%8h",fft_out[i]);
				$display($time,"Your ans : fft_out=%8h\n\n",data_in);	
			end					
		end
		@(negedge ack);
		#(`CYCLE);
		req[2]=0;
		if(check_1_7==8)
			check = check+1;
		check_1_7 = 0;
	end
end
end

always@(*)
begin
	data_out = 32'd0;
	case(gnt)
		3'b001 : data_out = data_out_0;
		3'b010 : data_out = data_out_1;
		3'b100 : data_out = data_out_2;
	endcase
end
//FFT Check//
task fft_verify;
input [31:0] fft_exp, fft_rec;
output fft_fail;
reg [15:0] fftr_ver, ffti_ver;
reg [15:0] fft_rec_r , fft_rec_r1 , fft_rec_r2 , fft_rec_r3 ,fft_rec_i , fft_rec_i1 , fft_rec_i2 , fft_rec_i3 ;
reg [15:0] fft_rec_r4 , fft_rec_r5 , fft_rec_r6, fft_rec_r7, fft_rec_i4 , fft_rec_i5 , fft_rec_i6, fft_rec_i7 ;
reg fftr_verify, ffti_verify;
begin
	fftr_ver = fft_exp[31:16];
	ffti_ver = fft_exp[15:0];

	fft_rec_r = fft_rec[31:16]; 
	fft_rec_r1 = fft_rec_r-1; fft_rec_r2 = fft_rec_r; fft_rec_r3 = fft_rec_r+1;
	fft_rec_r4 = fft_rec_r-2; fft_rec_r5 = fft_rec_r+2; fft_rec_r6 = fft_rec_r-3; fft_rec_r7 = fft_rec_r+3;
			
	fft_rec_i = fft_rec[15:0];
	fft_rec_i1 = fft_rec_i-1; fft_rec_i2 = fft_rec_i; fft_rec_i3 = fft_rec_i+1;
	fft_rec_i4 = fft_rec_i-2; fft_rec_i5 = fft_rec_i+2; fft_rec_i6 = fft_rec_i-3; fft_rec_i7 = fft_rec_i+3;
	
	fftr_verify = ((fftr_ver == fft_rec_r2) || (fftr_ver == (fft_rec_r3)) || (fftr_ver == (fft_rec_r1)) || (fftr_ver == (fft_rec_r4)) || (fftr_ver == (fft_rec_r5)) || (fftr_ver == (fft_rec_r6)) || (fftr_ver == (fft_rec_r7)));
	ffti_verify = ((ffti_ver == fft_rec_i2) || (ffti_ver == (fft_rec_i3)) || (ffti_ver == (fft_rec_i1)) || (ffti_ver == (fft_rec_i4)) || (ffti_ver == (fft_rec_i5)) || (ffti_ver == (fft_rec_i6)) || (ffti_ver == (fft_rec_i7)));
	if ( (!fftr_verify) || (!ffti_verify)|| (fft_rec === 32'bx) || (fft_rec === 32'bz)) begin
		fft_fail = 1;
	end
	else 
		fft_fail = 0;
end
endtask

//MAC Exp_data//
task mac;
	input [31:0] ab0,ab1,ab2,ab3,ab4,ab5,ab6,ab7;
	output [31:0] out;
	
	out = ab0[15:8]*ab0[7:0]+ab1[15:8]*ab1[7:0]+ab2[15:8]*ab2[7:0]+ab3[15:8]*ab3[7:0]+
		  ab4[15:8]*ab4[7:0]+ab5[15:8]*ab5[7:0]+ab6[15:8]*ab6[7:0]+ab7[15:8]*ab7[7:0];

endtask

//FFT Exp_data//
task fft;
	input [31:0] in0,in1,in2,in3;
	output signed [31:0] y0,y1,y2,y3,y4,y5,y6,y7;
	reg signed [15:0] x0,x1,x2,x3,x4,x5,x6,x7;
	reg signed [15:0] temp0,temp1,temp2,temp3,temp4,temp5,temp6;
	reg signed [31:0] temp7,temp8;
	begin
	x0 = in0[31:16];
	x1 = in0[15:0];
	x2 = in1[31:16];
	x3 = in1[15:0];
	x4 = in2[31:16];
	x5 = in2[15:0];
	x6 = in3[31:16];
	x7 = in3[15:0];
	temp0 = x0+x1+x2+x3+x4+x5+x6+x7;
	temp1 = x0-x4;
	temp2 = x1-x5;
	temp3 = x3-x7;
	temp4 = x2-x6;
	temp5 = x0+x4-x2-x6;
	temp6 = x3+x7-x1-x5;
	temp7 = W*temp2;
	temp8 = W*temp3;
	
	y0 = {temp0,16'b0};
	y1 = {(temp1+temp7[23:8]-temp8[23:8]),(-temp4-temp7[23:8]-temp8[23:8])};
	y2 = {temp5,temp6};
	y3 = {(temp1-temp7[23:8]+temp8[23:8]),(temp4-temp7[23:8]-temp8[23:8])};
	y4 = {x0+x2+x4+x6-x1-x3-x5-x7,16'b0};
	y5 = {(temp1-temp7[23:8]+temp8[23:8]),(-temp4+temp7[23:8]+temp8[23:8])};
	y6 = {temp5,~temp6+1'b1};
	y7 = {(temp1+temp7[23:8]-temp8[23:8]),(temp4+temp7[23:8]+temp8[23:8])};
	end
endtask

initial  begin
 #(`CYCLE * `End_CYCLE);
 $display("-----------------------------------------------------");
 $display("Oops!!! Your code can not work...!!");
 $display("-------------------------FAIL------------------------");
 $finish;
end
// Terminate the simulation, PASS
initial begin
      wait(check>=50);
      if ( !(err) ) begin
			$display("-------------------   Chip check successfully   -------------------");
			$display("            $$              ");
			$display("           $  $");
			$display("           $  $");
			$display("          $   $");
			$display("         $    $");
			$display("$$$$$$$$$     $$$$$$$$");
			$display("$$$$$$$              $");
			$display("$$$$$$$              $");
			$display("$$$$$$$              $");
			$display("$$$$$$$              $");
			$display("$$$$$$$              $");
			$display("$$$$$$$$$$$$         $$");
			$display("$$$$$      $$$$$$$$$$");
			 $display("-------------------------PASS------------------------");
			#(`CYCLE/2); $finish;
      end
      else begin
      	 $display("-----------------------------------------------------\n");
         $display("Fail!! There are%d error with your code!\n",err);
         $display("-------------------------FAIL------------------------\n");
      #(`CYCLE/2); $finish;
      end
end



endmodule
