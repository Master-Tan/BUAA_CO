# Coding in UTF-8
import os
# import random
import re
# import shutil


##############################################################################################
def fileCmp(std, ise):  # file a,b
    stdText = std.read()
    iseText = ise.read()

    isSame = True

    stdLogs = re.findall("@[^\\n]*\\n?", stdText)
    iseLogs = re.findall("@[^\\n]*\\n?", iseText)

    for i in range(len(stdLogs)):
        if (stdLogs[i] != iseLogs[i]):
            isSame = False
    if (isSame is True):
        print("\tAccepted")
        return 0
    else:
        print("\tWrongAnswer")
        return 1


########################################################################
mipsDir = input(
    "需要编译的mips程序绝对地址(e.g. D:/mips.asm)：\n")  # Mips File For Mars to Compile
hexCodeDir = "code.txt"  # Hex Code For ISE

#   Dump Hex Code And Get Std Log
spMarsJarDir = input("修改版Mars绝对地址(e.g. D:/Mars.jar)\n")
stdLogDir = "std_ans.txt"
os.system("java -jar " + spMarsJarDir + " " + mipsDir +
          " nc mc CompactDataAtZero a dump .text HexText " + hexCodeDir)
os.system("java -jar " + spMarsJarDir + " " + mipsDir +
          " nc mc CompactDataAtZero >" + stdLogDir)

#   Prepare ISE exe
testDir = input("工程文件夹地址(e.g. D:/test)：\n")
tclFile = open(testDir + "/test.tcl", "w")
tclFile.write("run 200us;\nexit")
prjFile = open(testDir + "/test.prj", "w")
prjFile.write("Verilog work " + testDir + "/CPU_test.v\n" + "Verilog work " +
              testDir + "/mips.v\n" + "Verilog work " + testDir + "/PC.v\n" +
              "Verilog work " + testDir + "/NPC.v\n" + "Verilog work " +
              testDir + "/IM.v\n" + "Verilog work " + testDir + "/CTRL.v\n" +
              "Verilog work " + testDir + "/ALU.v\n" + "Verilog work " +
              testDir + "/EXT.v\n" + "Verilog work " + testDir + "/GRF.v\n" +
              "Verilog work " + testDir + "/DM.v\n" + "Verilog work " +
              testDir + "/define.v\n" + "Verilog work " + testDir +
              "/toASM.v\n")
tclFile.close()
prjFile.close()
#   Run ISE simulation
iseCompileLogDir = "ise_log.txt"
userLogDir = "ise_ans.txt"
os.environ['XILINX'] = input("ISE安装文件夹(e.g. D:/Xilinx/14.7/ISE_DS/ISE):\n")
os.system("d:/Xilinx/14.7/ISE_DS/ISE/bin/nt64/fuse -nodebug -prj " + testDir +
          "/test.prj" + " -o " + "testmips.exe CPU_test>" + iseCompileLogDir)
os.system("d:/Codes/testmips.exe -nolog -tclbatch " + testDir + "/test.tcl" +
          ">" + userLogDir)

# Mars Log Complete
stdLog = open(stdLogDir, "r")
iseLog = open(userLogDir, "r")
fileCmp(stdLog, iseLog)

os.remove("code.txt")
os.remove("fuse.log")
os.remove("fuse.xmsgs")
os.remove("fuseRelaunch.cmd")
os.remove("isim.wdb")
os.remove("testmips.exe")
os.remove("ise_log.txt")
