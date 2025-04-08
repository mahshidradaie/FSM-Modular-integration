module motion_control(
	input [3:0]z,
	input clk,
	input resetn,
	output reg  [8:0]x_next,
	output reg  [7:0]y_next
);
reg [8:0]x=80;
reg [7:0]y=60;
reg[30:0]counter;
reg flag=1;
always@(posedge clk or negedge resetn)begin
	if(!resetn)begin
		x_next<=80;
		y_next<=60;

	end
	else
	begin
	counter<=counter+1;
	if(counter>=25000000)begin
	flag<=1;
	end
	else
	flag<=0;
	if(flag)begin
	case(z)
    4'b1000:if(x_next<139)begin
	 x_next<=x_next+1;
		counter<=0;

	end	 //right
    4'b0100:if(x_next>10) begin
	 x_next<=x_next-1;  //left
	 counter<=0;
	 end
    4'b0010:if(y_next<109) begin 
	 y_next<=y_next+1;     //down
	 counter<=0;
	 end
    4'b0001:if(y_next>0)begin
	 y_next<=y_next-1;     //up
	 counter<=0;

	end
        endcase
		  end
		  end
end
endmodule

module top_module(
    input CLOCK_50,
    input [3:0] KEY,   
    input [17:0] SW,   
    output VGA_CLK,
    output VGA_HS,
    output VGA_VS,
    output VGA_BLANK,
    output VGA_SYNC,
    output [9:0] VGA_R,
    output [9:0] VGA_G,
    output [9:0] VGA_B,
	 output [8:0] x_new,
	 output [7:0] y_new
);
	wire rst;
	assign rst=SW[14];
    wire resetn, plot;
    wire [2:0] color;
 
	 //wire [4:0]width;
	 //wire [4:0]height;
  

    assign resetn = KEY[0];  
    assign plot = KEY[1];    
    assign color = SW[17:15]; 

    motion_control u1 (.clk(CLOCK_50),.resetn(rst),.z(SW[3:0]),.x_next(x_new),.y_next(y_new));

    show u3 (.KEY(KEY),.SW(SW),.rst(rst),.x_new(x_new),.y_new(y_new),.clk(CLOCK_50),.resetn(resetn),.VGA_CLK(VGA_CLK),.VGA_HS(VGA_HS),.VGA_VS(VGA_VS),.VGA_BLANK(VGA_BLANK),.VGA_SYNC(VGA_SYNC),.VGA_R(VGA_R),.VGA_G(VGA_G),.VGA_B(VGA_B));

endmodule


module show(
    input clk,         
    input resetn,
	 input rst,
	input signed[15:0]x_new,
	input signed[13:0]y_new,
	input	[3:0] KEY,				//	Button[0:0]
	input	[17:0] SW,				//	Button[0:0]
    output VGA_CLK,    
    output VGA_HS,     
    output VGA_VS,     
    output VGA_BLANK,  
    output VGA_SYNC,   
    output [9:0] VGA_R,
    output [9:0] VGA_G,
    output [9:0] VGA_B
);
    reg signed[15:0] x;       
    reg signed[13:0] y;       
    reg plot;
	 reg[11:0]r=20;
    //parameter start_x = 0;  
    //parameter start_y = 0;
    //parameter width = 20;
    //parameter height = 10;
    //reg [4:0] count_x = 0;  
    //reg [3:0] count_y = 0;  
    //reg[7:0]x_1;
    //reg[6:0]y_1;
    reg [2:0]colour;
	
	//wire resetn;
	wire [2:0] color;
    //reg [7:0]x=80;
   // reg [6:0]y=60;
	//assign resetn = KEY[0];
    //assign plot=KEY[1];
	// Further assignments go here...
    assign color=SW[17:15];
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.


    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            x<=0;
            y<=0;
				r<=20;
            //count_x<=0;
            //count_y<=0;
        end 
        else begin
				
            x<=1+x;
            plot<=1;
				if(x>=160)begin
				y<=1+y;
				x<=0;
				end
				if(y>=120)begin
				y<=0;
				end
            if((x-x_new)**2 + (y-y_new)**2 <= r**2)begin
				colour<=color;
            end
            else 
            begin
                colour<=3'b001;
        end
		  end
		  end

    	vga_adapter VGA(
			.resetn(resetn),
			.clock(clk),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(plot),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "display.mif";
		

endmodule



circle:
module show(
    input clk,         
    input resetn,
	 input rst,
	input [11:0]r,
	input	[3:0] KEY,				//	Button[0:0]
	input	[17:0] SW,				//	Button[0:0]
    output VGA_CLK,    
    output VGA_HS,     
    output VGA_VS,     
    output VGA_BLANK,  
    output VGA_SYNC,   
    output [9:0] VGA_R,
    output [9:0] VGA_G,
    output [9:0] VGA_B
);
    reg signed[15:0] x;       
    reg signed[13:0] y;       
    reg plot;
	 //reg[11:0]r=20;
    //parameter start_x = 0;  
    //parameter start_y = 0;
    //parameter width = 20;
    //parameter height = 10;
    //reg [4:0] count_x = 0;  
    //reg [3:0] count_y = 0;  
    //reg[7:0]x_1;
    //reg[6:0]y_1;
    reg [2:0]colour;
	
	//wire resetn;
	wire [2:0] color;
    //reg [7:0]x=80;
   // reg [6:0]y=60;
	//assign resetn = KEY[0];
    //assign plot=KEY[1];
	// Further assignments go here...
    assign color=SW[17:15];
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.


    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            x<=0;
            y<=0;
				//r<=20;
            //count_x<=0;
            //count_y<=0;
        end 
        else begin
				
            x<=1+x;
            plot<=1;
				if(x>=160)begin
				y<=1+y;
				x<=0;
				end
				if(y>=120)begin
				y<=0;
				end
            if((x-80)**2 + (y-60)**2 <= r**2)begin
				colour<=color;
            end
            else 
            begin
                colour<=3'b001;
        end
		  end
		  end

    	vga_adapter VGA(
			.resetn(resetn),
			.clock(clk),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(plot),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "display.mif";
		

endmodule
module top_module(
    input CLOCK_50,
    input [3:0] KEY,   
    input [17:0] SW,   
    output VGA_CLK,
    output VGA_HS,
    output VGA_VS,
    output VGA_BLANK,
    output VGA_SYNC,
    output [9:0] VGA_R,
    output [9:0] VGA_G,
    output [9:0] VGA_B,
	 output [8:0] x_new,
	 output [7:0] y_new
);
	wire rst;
	assign rst=SW[14];
    wire resetn, plot;
    wire [2:0] color;
	 wire [11:0]r;
 
	 //wire [4:0]width;
	 //wire [4:0]height;
  

    assign resetn = KEY[0];  
    assign plot = KEY[1];    
    assign color = SW[17:15]; 

    motion_control u1 (.clk(CLOCK_50),.resetn(rst),.z(SW[3:0]),.r(r));

    show u3 (.KEY(KEY),.SW(SW),.rst(rst),.r(r),.clk(CLOCK_50),.resetn(resetn),.VGA_CLK(VGA_CLK),.VGA_HS(VGA_HS),.VGA_VS(VGA_VS),.VGA_BLANK(VGA_BLANK),.VGA_SYNC(VGA_SYNC),.VGA_R(VGA_R),.VGA_G(VGA_G),.VGA_B(VGA_B));

endmodule
module motion_control(
	input [3:0]z,
	input clk,
	input resetn,
	output reg  [11:0]r
	);
reg [8:0]x=80;
reg [7:0]y=60;
reg[30:0]counter;
reg flag=1;
always@(posedge clk or negedge resetn)begin
	if(!resetn)begin
		r<=20;

	end
	else
	begin
	counter<=counter+1;
	if(counter>=25000000)begin
	flag<=1;
	end
	else
	flag<=0;
	if(flag)begin
	case(z)
    4'b1000:if(r<50)begin
	 r<=r+1;
		counter<=0;

	end	 //right
    4'b0100:if(r>0) begin
	 r<=r-1;  //left
	 counter<=0;
	 end

        endcase
		  end
		  end
end
endmodule


module secret_sequence_detector(
    input wire clk,
    input wire reset,
    input wire [2:0] inp_button,
    output reg Trigger
);

reg [2:0] current_state;
reg [2:0] next_state;
// States
localparam start_1 = 3'd1;
localparam cross_2 = 3'd2;
localparam triangle_3 = 3'd3;
localparam square_4 = 3'd4;
localparam cross_3 = 3'd5;
localparam circle_5 = 3'd6;

// State's symbol
localparam Square = 3'b001;
localparam Triangle = 3'b010;
localparam Circle = 3'b011;
localparam Cross = 3'b100;
localparam start = 3'b111;
localparam Non = 3'b000;

// State register update
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state = start_1 ;
    end else begin
        current_state = next_state;
    end
end

// Next state logic
always @(current_state or inp_button) begin
    case (current_state)
        // Start state
        start_1: begin
            Trigger = 0;
            if (inp_button == Cross) begin
                next_state = cross_2;
            end else begin
                next_state = start_1;
            end
        end

        // Cross_2 state
        cross_2: begin
            Trigger = 0;
            if (inp_button == Square || inp_button == Circle) begin
                next_state = start_1;
            end else if (inp_button == Triangle) begin
                next_state = triangle_3;
            end else begin
                next_state = cross_2;
            end
        end

        // Triangle_3 state
        triangle_3: begin
            Trigger = 0;
            if (inp_button == Circle) begin
                next_state = start_1;
            end else if (inp_button == Square) begin
                next_state = square_4;
            end else if (inp_button == Cross) begin
                next_state = cross_2;
            end else begin
                next_state = triangle_3;
            end
        end

        // Square_4 state
        square_4: begin
            Trigger = 0;
            if (inp_button == Circle || inp_button == Triangle) begin
                next_state = start_1;
            end else if (inp_button == Cross) begin
                next_state = cross_3;
            end else begin
                next_state = square_4;
            end
        end

        // Cross_3 state
        cross_3: begin
            Trigger = 0;
            if (inp_button == Square) begin
                next_state = start_1;
            end else if (inp_button == Triangle) begin
                next_state = triangle_3;
            end else if (inp_button == Circle) begin
                next_state = circle_5;
                Trigger = 1;
            end else begin
                next_state = cross_3;
            end
        end

        // Circle_5 state
        circle_5: begin
            Trigger = 0;
            
            next_state = start_1;
        end

        default: begin
            Trigger = 0;
            next_state = start_1;
        end
    endcase
end

endmodule
// two sequence will set trigger 1 to reset timer first cross, triangle , square , cross , circle
// the next one is cross,cross, square,triangle
//these two sequences will make valid 1
//two_repeated_cross is when we have two cross repeated and then we should compare it to sequence cross,square,triangle
module testbench_1();
  reg clk_t;
  reg reset_t;
  reg [2:0] inp_button_t;
  wire Trigger_t;

  secret_sequence_detector dut (
    .clk(clk_t),
    .reset(reset_t),
    .inp_button(inp_button_t),
    .Trigger(Trigger_t)
  );

  initial begin
    clk_t = 1'b0;
    reset_t = 1'b1;
    #15 reset_t = 1'b0;
    forever #5 clk_t = ~clk_t;
  end

  initial begin
    #11 inp_button_t = 3'b001;
    #10 inp_button_t = 3'b010;
    #10 inp_button_t = 3'b011;
    #10 inp_button_t = 3'b100;
    #10 inp_button_t = 3'b111;
    #10 inp_button_t = 3'b000;
    #10 inp_button_t = 3'b111;
    #10 inp_button_t = 3'b100;
    #10 inp_button_t = 3'b010;
    #10 inp_button_t = 3'b001;
    #10 inp_button_t = 3'b100;
    #10 inp_button_t = 3'b011;
    #10 $finish;
  end

  initial begin
    $dumpfile("testbench_1.vcd");
    $dumpvars(0, testbench_1);
  end

endmodule

/* State's symbol
localparam Square = 3'b001;
localparam Triangle = 3'b010;
localparam Circle = 3'b011;
localparam Cross = 3'b100;
localparam start = 3'b111;
localparam Non = 3'b000;*/