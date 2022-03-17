TEST='./test/subpipeline_tb.v'
LIB='/Users/Kate/Documents/GitHub/MIPS_superscalar/ce361_CPU_Verilog/lib'

build:
	iverilog -Tmax -gspecify -g2012 -o sim.vvp -y./ece361_alu_verilog -y./extralib -y./extra -y./lib -y./cpu ./cpu/alu_subpipeline.v ./test/subpipeline_tb.v  -Wall -Wno-implicit

run:
	./sim.vvp >> output

clean:
	rm *.vvp output dump.vcd

all: build run
