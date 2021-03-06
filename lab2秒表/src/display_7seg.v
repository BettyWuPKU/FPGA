`timescale 1ns / 1ps

module display_7seg_x4(
    input CLK, //100MHz
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    output reg [0:6] seg,
    output reg [0:3] an
    );
    
    reg [19:0] count=0;
    reg [1:0] sel=0;
    parameter T1MS = 100000;
    reg [3:0] seg7_in;
    
    always @(seg7_in)
    begin
          case(seg7_in)
                    // abc_defg
            0: seg = 7'b000_0001; //111_1110;
	    //
	    //再次加入译码器其他部分
	    //
            9: seg = 7'b000_1100; //111_0011;
            default: seg = 7'b111_1111; //000_0000;
          endcase
    end
    
    always @(posedge CLK)
    begin
      count<=count+1;
      if(count==T1MS)
        begin
          count<=0;
          sel<=sel+1;
        end
    end
    
    always @(sel, in0, in1, in2, in3)
    begin
      case(sel)
      0: begin an = 4'b0111; seg7_in = in0; end
      1: begin an = 4'b1011; seg7_in = in1; end
      2: begin an = 4'b1101; seg7_in = in2; end
      3: begin an = 4'b1110; seg7_in = in3; end
      default: begin an = 4'b1111; seg7_in = 4'bxxxx; end
      endcase
    end
endmodule
