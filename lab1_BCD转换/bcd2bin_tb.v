module bcd2bin_tb;
  wire [3:0] bcd3, bcd2, bcd1, bcd0;
  reg [13:0] binary_in;
  wire [13:0] binary_out;

  integer i = 0;


  initial begin
    $dumpfile("bcd2bin.vcd");
    $dumpvars(0, u_BCD2bin);
    $dumpvars(1, u_bin2BCD);
    $monitor("Binary_in is %b; BCD is %d %d %d %d; Binary_out is %b", binary_in, bcd3, bcd2, bcd1, bcd0, binary_out);
  
    for (i = 0; i <=10001; i++) begin
      binary_in = i; #50;
    end
    $finish;
  end

  binary2BCD u_bin2BCD(binary_in, bcd3, bcd2, bcd1, bcd0);
  BCD2binary u_BCD2bin(bcd3, bcd2, bcd1, bcd0, binary_out);

endmodule
