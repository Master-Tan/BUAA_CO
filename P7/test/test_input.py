# Coding in UTF-8
import os
import re
import shutil

##############################################################################################
f = open("result.txt", "w")


def fileCmp(std_path, ise_path, std, ise, filename):  # file a,b
    stdText = std.read()
    iseText = ise.read()

    isSame = True

    stdLogs = re.findall("@[^\\n]*\\n?", stdText)
    iseLogs = re.findall("@[^\\n]*\\n?", iseText)

    for i in range(len(stdLogs)):
        if (stdLogs[i] != iseLogs[i]):
            isSame = False
            f.write(filename + ":\n")
            f.write("\tWrong: " + "At Line " + str(i) + " : " + "we want " +
                    stdLogs[i] + " " + " but we get " + iseLogs[i] + "\n")
            break
    if (isSame is True):
        print("\tAccepted")
        f.write("Accepted:  " + filename + "\n")
        flag = 1
    else:
        print("\tWrongAnswer")
        flag = 0

    stdLog.close()
    iseLog.close()

    if (flag == 1):
        os.remove(std_path)
        os.remove(ise_path)

    return flag


########################################################################
# mipsDir = input(
#     "需要编译的mips程序绝对地址(e.g. D:/mips.asm)：\n")  # Mips File For Mars to Compile

mipsDirs = []
for filename in os.listdir():
    if re.match(r"[\w]+\.asm", filename):
        mipsDirs.append(filename)
hexCodeDir = "code.txt"  # Hex Code For ISE

for mipsDir in mipsDirs:
    #   Dump Hex Code And Get Std Log
    # spMarsJarDir = input("修改版Mars绝对地址(e.g. D:/Mars.jar)\n")
    spMarsJarDir = "Mars_test.jar"  # 修改版Mars地址
    stdLogDir = mipsDir[:-4] + "_std_ans.txt"  # 标准输出
    os.system("java -jar " + spMarsJarDir + " " + mipsDir +
              " 100000 db nc mc CompactDataAtZero a dump .text HexText " + hexCodeDir)
    os.system("java -jar " + spMarsJarDir + " " + mipsDir +
              " 100000 db nc mc CompactDataAtZero >" + stdLogDir)

    #   Prepare ISE exe
    testDir = input("工程文件夹地址(e.g. D:/test)：\n")
    # testDir = "E:/ISE/Project_4"
    # tcl文件和prj文件需要放在工程同目录下
    tclFile = open(testDir + "/test.tcl", "w")
    # tcl文件声明了工程运行的参数
    tclFile.write("run 100us;\nexit")
    # prj文件声明了工程所含各模块的位置
    prjFile = open(testDir + "/test.prj", "w")
    for root, dirs, files in os.walk(testDir):
        for fileName in files:
            if re.match(r"[\w]+\.v", fileName):
                prjFile.write("Verilog work " + root + "/" + fileName + "\n")

    tclFile.close()
    prjFile.close()
    #   Run ISE simulation
    iseCompileLogDir = "ise_log.txt"
    userLogDir = mipsDir[:-4] + "_ise_ans.txt"  # 我的输出

    ise_path = input("ISE安装文件夹(e.g. D:/Xilinx/14.7/ISE_DS/ISE):\n")
    os.environ['XILINX'] = ise_path
    # os.environ['XILINX'] = "D:/Xilinx/14.7/ISE_DS/ISE"  # ISE安装文件夹

    os.system(ise_path + "/bin/nt64/fuse -nodebug -prj " +
              testDir + "/test.prj" + " -o " + "testmips.exe mips_test>" +
              iseCompileLogDir)

    os.system("testmips.exe -nolog -tclbatch " + testDir + "/test.tcl" + ">" +
              userLogDir)
    # Mars Log Complete
    stdLog = open(stdLogDir, "r")  # 标准答案
    iseLog = open(userLogDir, "r")  # 你的答案

    fileCmp(stdLogDir, userLogDir, stdLog, iseLog, mipsDir)

    # os.remove("test/code.txt")
    os.remove("fuse.log")
    os.remove("fuse.xmsgs")
    os.remove("fuseRelaunch.cmd")
    os.remove("isim.wdb")
    os.remove("testmips.exe")
    os.remove("ise_log.txt")
    shutil.rmtree("isim")

f.close()
