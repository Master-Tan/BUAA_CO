import os
import re

logisim = "P3_L0_CPU_2.0.circ"
mars = "P2_L1_puzzle.asm";
command="java -jar Mars4_5.jar "+ mars +" nc mc CompactTextAtZero a dump .text HexText rom1.txt" 
os.system(command)
content = open("rom1.txt","r").read()
cur = open(logisim).read()
cur = re.sub(r'addr/data: 16 32([\s\S]*)</a>',"addr/data: 16 32\n" + content + "</a>", cur)
# open("rom1_1.txt","w").write(cur)
logisim_1 = logisim[:-5] + "_1.circ"
with open(logisim_1,"w") as file:
	file.write(cur)
os.system("java -jar logisim-generic-2.7.1.jar "+ logisim_1 +" -tty table >out.txt")
with open("out.txt", "r") as f1:
    with open("out_dec.txt", "w") as f2:
        lines = f1.readlines()
        for line in lines:
            line = line.replace(" ", "")
            line = line.replace("\t", "")
            if line[0] == "0":
                line = (str(int(line[1:], 2))) + '\n'
            else:
                line = '-' + (str(int(line[1:], 2))) + '\n'
            f2.write(line)
