module regfile_tb();
    reg [15:0] sim_data_in;
    reg [2:0] sim_writenum, sim_readnum;
    reg sim_write, sim_clk;
    reg err;
    wire [15:0] sim_data_out;

    //instantiate DUT: regfile module
    regfile DUT(sim_data_in, sim_writenum, sim_write, sim_readnum, sim_clk, sim_data_out);

    
    task error_checker;
        input [15:0] expected_data_out;
        begin
            //if the data_out in the instantiated DUT is erraneous, display the actual and expected state, and set err = 1
            if (DUT.data_out !== expected_data_out) begin
                $display("ERROR: data_out is %b, expecting %b", DUT.data_out, expected_data_out);
                err = 1'b1;
                $stop;
            end
        end
    endtask
    
    //loop of rising edges every 10 time units
    initial begin
        sim_clk = 0; #5;
        forever begin
            sim_clk = 1; #5;
            sim_clk = 0; #5;
        end
    end

    initial begin
        err = 0;
        sim_write = 1;
        sim_data_in = 16'h42;
        sim_writenum = 0;
        sim_readnum = 0;

        #10;

        //testcase autograder
        error_checker(16'h42);
        $display("data_out is %b, expecting %b", sim_data_out, 16'h42);

        //initialize signals
        sim_clk = 1'b0;
        err = 1'b0;
        sim_data_in = 16'b1;
        #5;

        //testcase 1: test writing and reading with register 0, data_in = 16'b1
        sim_writenum = 3'b0;
        sim_write = 1'b1;
        sim_readnum = 3'b0;
        #10;

        error_checker(16'b1);
        $display("data_out is %b, expecting %b", sim_data_out, 16'b1);

        //testcase 3: 
        sim_write = 1;
        sim_data_in = 16'h42;
        sim_writenum = 0;
        sim_readnum = 0;
        #5;

        sim_clk = 1;
        #5;
        sim_clk = 0;
        #5;

        $display("data_0 is %b, expecting %b", DUT.data_0, 16'b1000010);
        $display("data_out is %b, expecting %b", sim_data_out, 16'b1000010);

        //testcase 3: test writing to register 0, data_in = 16'b1
        sim_data_in = 16'b0000000000000010;
        sim_writenum = 3'b1;
        sim_write = 1'b1;
        #5;

        sim_clk = 1;
        #5;
        sim_clk = 0;
        #5;

        $display("data_1 is %b, expecting %b", DUT.data_1, 16'b0000000000000010);

        
        //print results, whether errors were found
        if (~err) 
            $display ("All test cases passed with no errors. ");
        else
            $display ("Error found. ");
        $stop;
    end

endmodule