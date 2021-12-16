PC = "00003d08"
text = "testpoint0.asm"

pc = 0
for i in PC:
    pc = int(i) + pc * 16

pc = int((pc-3*1024*4) / 4) + 1


f = open(text, "r")

cnt = 0

txt = f.readlines()
print(txt[354][-2] == ":")
for i in txt:
    if (i[0] != '.' and i[-2] != ':'):
        cnt = cnt + 1
        if (cnt == pc):
            for i in range(9, 0, -1):
                if (cnt - i >= 0):
                    print(txt[cnt - i])
            print("now: ")
            for i in range(10):
                if (cnt + i <= len(txt)):
                    print(txt[cnt + i])


# print("pc" + str(pc))
