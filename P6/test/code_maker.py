# import os
import sys
import random
"""

$2被生成器保留用作保存当前空闲memory的地址
$3被生成器保留用作循环变量
$4被生成器保留用作终止变量
在memory0~256(0~64)生成64个32位随机数
"""
prog = """
# auto generated code
.data
a: .space 4096
.text
{}
ori $2,$2,256
beq $0,$0,main
{}
main:
{}
"""
proc = """
proc_{}:
{}
jr $ra
"""
branch_success = """
addu ${0},$0,${1}
beq ${0},${1},branch_{2}
{3}
beq $0,$0,branch_{2}_end
branch_{2}:
{4}
branch_{2}_end:
"""
branch = """
beq ${0},${1},branch_{2}
{3}
beq $0,$0,branch_{2}_end
branch_{2}:
{4}
branch_{2}_end:
"""

loopp = """
lui $3,0
lui $5,0
ori $5,$5,1
{1}
loop_{0}:
beq $3,$4,loop_{0}_end
{2}
addu $3,$3,$5
beq $0,$0,loop_{0}
loop_{0}_end:
"""
proc_num = random.randint(4, 7)

mem_cnt = 0
# 标记正在使用的register
register_in_use = [0 for _ in range(32)]
register_in_use[1] = 1  # at
register_in_use[2] = 1
register_in_use[3] = 1
register_in_use[4] = 1
register_in_use[5] = 1
register_in_use[28] = 1
register_in_use[29] = 1
register_in_use[30] = 1
register_in_use[31] = 1
# 最大嵌套深度
max_depth = 5


def take_register() -> int:
    max_try = 10
    for i in range(max_try):
        t = random.randint(1, 31)
        if register_in_use[t] == 0:
            register_in_use[t] == 1
            return t
    return 0


def free_register(reg):
    register_in_use[reg] = 0


def li(reg, v) -> str:
    ret = ""
    hi = v // (2**16)
    lo = v % (2**16)
    ret += f"lui ${reg},{hi:#x}\n"
    ret += f"ori ${reg},${reg},{lo:#x}\n"
    return ret


def gen_block(jal_allowed) -> str:
    """
    生成语句块
    """
    global mem_cnt
    ret = ""
    # 决定在这个块使用哪些reg
    n_use_register = random.randint(5, 12)
    # print(n_use_register)
    using_register = []
    # print(register_in_use)
    for i in range(32):
        if n_use_register <= 0:
            break
        if register_in_use[i] == 0:
            n_use_register -= 1
            using_register.append(i)
    # print(using_register)
    n_instruction = random.randint(5, 20)
    instr = ["addu", "subu", "lw", "sw", "ori", "lui", "nop", "jal"]
    for _ in range(n_instruction):
        a = random.choices(instr, k=1)[0]
        if a == "addu":
            opr1, opr2, opr3 = random.choices(using_register, k=3)
            ret += f"addu ${opr1},${opr2},${opr3}\n"
        elif a == "subu":
            opr1, opr2, opr3 = random.choices(using_register, k=3)
            ret += f"subu ${opr1},${opr2},${opr3}\n"
        elif a == "lw":
            opr1 = random.choices(using_register, k=1)[0]
            read_from_mem = random.randint(0, 64) * 4
            ret += li(1, read_from_mem)
            ret += f"lw ${opr1},a($1)\n"
        elif a == "sw":
            opr1 = random.choices(using_register, k=1)[0]
            rand_addr = random.randint(64, 1023) * 4
            ret += f"ori $2,$0,{rand_addr}\n"
            ret += f"sw ${opr1},a($2)\n"
            mem_cnt += 4
        elif a == "ori":
            opr1, opr2 = random.choices(using_register, k=2)
            op3 = random.randint(0, 2**16 - 1)
            ret += f"ori ${opr1},${opr2},{op3}\n"
        elif a == "lui":
            opr1 = random.choices(using_register, k=1)[0]
            op3 = random.randint(0, 2**16 - 1)
            ret += f"lui ${opr1},{op3}\n"
        elif a == "nop":
            ret += "nop\n"
        elif a == "jal" and jal_allowed:
            t = random.randint(0, proc_num - 1)
            ret += f"jal proc_{t}\n"
    # 保底sw一次，保存这个block的结果
    opr1 = random.choice(using_register)
    rand_addr = random.randint(64, 1023) * 4
    ret += f"ori $2,$0,{rand_addr}\n"
    ret += f"sw ${opr1},a($2)\n"
    return ret


out = sys.argv[1]
# out = "test.asm"
f = open(out, "w")

rand_mem = ""
for i in range(64):
    t = random.randint(0, 2**32 - 1)
    # print(t)
    rand_mem += li(2, t)
    rand_mem += f"ori $1,$0,{i*4}\n"
    rand_mem += "sw $2,a($1)\n"

procs = ""
for i in range(proc_num):
    # 不能再过程之间跳转，可能死循环
    procs += proc.format(i, gen_block(False))

block_num = random.randint(5, 10)

mainproc = ""
branch_cnt = 0
loopp_cnt = 0
possible_block = ["branch_success", "branch", "loopp"]
for i in range(block_num):
    a = random.choice(possible_block)
    if a == "branch_success":
        iterat = take_register()
        bound = take_register()

        mainproc += branch_success.format(iterat, bound, branch_cnt,
                                          gen_block(True), gen_block(True))

        free_register(iterat)
        free_register(bound)
        branch_cnt += 1
    elif a == "branch":
        iterat = take_register()
        bound = take_register()

        mainproc += branch.format(iterat, bound, branch_cnt, gen_block(True),
                                  gen_block(True))

        free_register(iterat)
        free_register(bound)
        branch_cnt += 1
    elif a == "loopp":
        mainproc += loopp.format(loopp_cnt, li(4, random.randint(5, 25)),
                                 gen_block(True))
        loopp_cnt += 1

f.write(prog.format(rand_mem, procs, mainproc))
f.close()
