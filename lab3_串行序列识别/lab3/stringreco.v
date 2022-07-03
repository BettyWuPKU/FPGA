`timescale 1ns / 1ps

module stringreco(
    input clk, 
    input clr, 
    input en,
    input sw,
    output count
    );
    
    reg counter;
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
            state_pre = 0;
            counter_pre = 0;
        end
        case(state_pre)
            0: begin
                if(en) state_pre = 1;
                else state_pre = 0;
            end
            1: begin
                if(counter_pre >= 15) state_pre = 0;
                else begin
                    state_pre = 1; 
                    counter_pre = counter_pre + 1;
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if(clr) begin
            state = 0; counter = 0;
        end
        else begin
            case(state)
            0: begin
                out = 0;
                if(shifter[0])  state = 1;
                else    state = 4;
            end
            1: begin
                out = 0;
                if(shifter[0])  state = 2;
                else    state = 1;
            end
            2: begin
                out = 0;
                if(shifter[0])  state = 5;
                else    state = 3;
            end
            3: begin
                if(shifter[0])  begin
                    state = 4; out = 0;
                end
                else    begin
                    state = 1; out = 1;
                end
            end
            4: begin
                out = 0;
                if(shifter[0])  state = 5;
                else    state = 1;
            end
            5: begin
                out = 0;
                if(shifter[0])  state = 5;
                else    state = 4;
            end
            6: begin
                if(shifter[0])  begin
                    state = 4; out = 1;
                end
                else begin
                    state = 1; out = 0;
                end
            end
            endcase
            counter = counter + out & (state_pre == 1);
        end
    end
    
    assign count = counter;

endmodule
