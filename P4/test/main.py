import os

cnt = 100

for i in range(cnt):
    try:
        os.makedirs("auto_test_code")
    except Exception:
        pass
    os.system("python code_maker.py " + "test_" + str(i) + ".asm")
    os.system("python code_maker.py auto_test_code/" + "test_" + str(i) +
              ".asm")
os.system("python test.py")
for i in range(cnt):
    os.remove("test_" + str(i) + ".asm")
