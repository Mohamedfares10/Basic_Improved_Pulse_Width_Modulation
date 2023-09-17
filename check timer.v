module timer #(parameter bits = 4)(
input clk, rst_n,enable,
input [bits-1 : 0] final_value,
output done
	);
reg [bits-1 : 0] count;

always @(posedge clk , negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else if (enable) begin
	    if (done) count <= 0 ;
	    else count <= count + 1 ;
	end
	else begin
		count <= count ;	
	end
end

assign done = (count == final_value);

endmodule


module timer_tb ();
parameter bits = 15;
parameter T = 10;
reg clk, rst_n,enable;
reg [bits-1:0] final_value;
wire done;

timer #(.bits(bits)) dut (.clk(clk), .enable(enable),.rst_n(rst_n), .done(done),.final_value(final_value));

always #(T/2) clk = ~clk;

initial begin
enable = 1;
rst_n = 0;
clk   = 0;
final_value = 255;
#(T/2);
rst_n = 1;
# 25555;
$stop;
end
endmodule