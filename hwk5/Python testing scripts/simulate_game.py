import subprocess
import os

# Game 1
# deck = "9d8d7d6d5d4d3d2d1d\n"
# moves = "7080 0001 0170 0001 1100 2100 3100 4100 5100 6100 7100 8200 8100 7080 6080 1100 0001 5080 4080 3080 2080 1080 0080 0110 0080 1080"
# moves = "7080"
# board = "1d2u3u4u5u6u7u8u9u\n0u              0u"

# Game 2
deck = "0d7d4d1d2d1d1d9d5d9d0d8d1d6d4d8d5d8d3d4d4d6d9d5d6d5d9d0d2d7d7d0d3d3d9d5d\n"
board = "9d9d7d2d0d1d2d6d0d\n6d8d4d7d6d8d0d4d8d\n3d1d7d2d3d1d3d3d5d\n5d2d4d1d5d6d7d7d9u\n3u8u4u0u8u6u2u2u"
moves = "7400 0420 4480 2440 7380 5480 4380 6440 5360 5280 3480 6350 8250 2350 3340 4360 6250 2210 3240 4220 2100 0340 4130 2080 5120 6150 5060 6070 7260 6070 3150 1460 1300 1200 4020 2110 1140 4010 0210 0140 8100 5100 1200 8000 1100 6180 0001 6140 6070 7660 7180 8170 7080 8060 5160 2170 1180 0001 2100 1130 7140 7040 5170 1070 4350 5060 7160 4160 3360 6200 3210 6150 0001 5160 5080 8250 8140 8040 4180 6180 2180 1170 0280 0110 1000 0080 7280 7100 3210 0001 1150 8110 8010 5210 1020 2070 3220 3170 0170 2050 6170 4160 4050 0050 7050 3050 6050"





moves_set = moves.split(" ")

COMMAND_LINE = "python script.py . test_simulation.txt"

result_set = []

num_moves = len(moves_set)

num_moves = 16

def callFunction():
    try:
        test = subprocess.Popen(COMMAND_LINE, stdout=subprocess.PIPE, shell=True)
        output = test.communicate()[0]
        # format output (might be different depending on your output from mips)
        output = output.decode("utf-8", 'backslashreplace').split("\n")
        return output
    except Exception as e:
        print("Houston we have a problem")
        print(e)


print("START")

for x in range(num_moves):
    with open("simulation.txt", "w") as file:
        file.write(deck)
        file.write(" ".join(moves_set[:x+1])+"\n")
        file.write(board)

    
    output = callFunction()
    # print(output)
    result_set.append(output)


# expect_len = len(moves_set)
# while len(result_set) < expect_len:
#     print(len(result_set))
#     pass

for move in result_set:
    os.system('clear')
    for line in move:
        print(line)
    input("Enter for next move")

print(f"Show {len(result_set)} moves")