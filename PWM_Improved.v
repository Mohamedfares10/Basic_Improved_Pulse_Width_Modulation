module PWM_Improved #(parameter R = 8, Timer_Bits =15) (
input clk, rst_n, 
input [R:0] duty,
input [Timer_Bits-1:0] final_value,
output pwn_out
	);
reg [R-1 : 0] count = 0;
reg D;
wire tick;
always @(posedge clk , negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
		D <= 0;
	end
	else if (tick) begin
		count <= count + 1 ;
        if (count < duty) D <= 1;
        else D <= 0;
	end
	else begin
		count <= count ;
		D <= D;
	end
end

assign pwn_out = D;

timer #(.bits(Timer_Bits)) Timer (.clk(clk), .rst_n(rst_n), .enable(1'b1), .final_value(final_value), .done(tick));

endmodule


module timer #(parameter bits = 4)(
input clk, rst_n,enable,
input [bits-1 : 0] final_value,
output done
	);
reg [bits-1 : 0] T_count;

always @(posedge clk , negedge rst_n) begin
	if (!rst_n) begin
		T_count <= 0;
	end
	else if (enable) begin
	    if (done) T_count <= 0 ;
	    else T_count <= T_count + 1 ;
	end
	else begin
		T_count <= T_count ;	
	end
end

assign done = (T_count == final_value);

endmodule



module PWM_Improved_tb ();
parameter R = 8;
parameter Timer_Bits = 8;
parameter T = 10;
reg clk, rst_n;
reg [R : 0] duty;
reg [Timer_Bits-1:0] final_value;
wire pwn_out;

PWM_Improved #(.R(R),.Timer_Bits(Timer_Bits)) dut (.clk(clk), .rst_n(rst_n), .duty(duty),.final_value(final_value), .pwn_out(pwn_out));

initial
        
    always
    begin
        clk = 1'b0;
        #(T / 2);
        clk = 1'b1;
        #(T / 2);
    end
    
    initial
    begin
        // issue a quick reset for 2 ns
        rst_n = 1'b0;
        #2  
        rst_n = 1'b1;
        duty = 0.25 * (2**R);
        final_value = 8'd194;
        
        repeat(2 * 2**R * final_value) @(negedge clk);
        duty = 0.50 * (2**R);

        repeat(2 * 2**R * final_value) @(negedge clk);
        duty = 0.75 * (2**R);
        
        #(7 * 2**R * T * 200) $stop;
    end    
    

endmodule