Blocks:
1x PC
1x iuinit
    input: pc; output: pc + 4, instruction;
4x registers (for keeping track between stages)
    how big? IDK depends on the register?
1x Register file
    Same as before
1x Execution Unit
    extender, muxes, adder, and ALU
    input: pc+4, busa, busb, alucontrol, immediate; output: target, aluout, zero
1x Data Memory
    same as before
3x mux