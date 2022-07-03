`timescale 1ns / 1ps

module stringreco(
    input clk, 
    input clr, 
    input en,
    input sw,
    output count_out
    );

    reg count;
    reg out;
    reg [15:0] shifter;
    reg state_pre;
    reg state;
    reg counter_pre;

    always @(posedge clk) begin
        if(en) shifter <= sw;
    end

    always @(posedge clk) begin
        shifter = shifter >> 1;
    end

    always @(posedge clk) begin
        if(clr)begin
            state_pre = zero;
            counter_pre = 0;
        end
        case(state_pre)
            zero: begin
                if(en) state_pre = one;
                else state_pre = zero;
            end
            one: begin
                if(counter_pre >= 15) state_pre = zero;
                else begin
                    state_pre = one; 
                    counter_pre = counter_pre + 1;
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if(clr) state = zero;
        else begin
            case(state)
            zero: begin
                out = 0;
                if(shifter[0])  state = one;
                else    state = four;
            end
            one: begin
                out = 0;
                if(shifter[0])  state = two;
                else    state = one;
            end
            two: begin
                out = 0;
                if(shifter[0])  state = five;
                else    state = three;
            end
            three: begin
                if(shifter[0])  begin
                    state = four; out = 0;
                end
                else    begin
                    state = one; out = 1;
                end
            end
            four: begin
                out = 0;
                if(shifter[0])  state = five;
                else    state = one;
            end
            five: begin
                out = 0;
                if(shifter[0])  state = five;
                else    state = four;
            end
            six: begin
                if(shifter[0])  state = four; out = 1
                else begin
                    state = one; out = 0;
                end
            end
            endcase
        end
    end

    assign count_out = count + out & (state_pre == one);

endmodule
