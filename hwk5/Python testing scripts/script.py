import subprocess
import sys



def callFunction(op):
    try:
        test = subprocess.Popen(COMMAND_LINE, stdout=subprocess.PIPE, shell=True)
        output = test.communicate()[0]
        # format output (might be different depending on your output from mips)
        output = output.decode("utf-8", 'backslashreplace').replace("\n\n", "\n").replace("\r\n", "").split("\n")
        return output
    except Exception as e:
        print("Houston we have a problem")
        print(e)

def readFile(fileName, directory, REGISTER_CHECK_PASSED = True, ANSWER_MATCH = 0, ANSWER_TOTAL = 0, HIGHEST_INSTRUCTION_COUNT = 0):
    f = open(fileName)
    lines = f.readlines()

    TESTER_ASM = "tester.asm"
    FUNCTIONS = []
    CHECK_ANSWERS = False
    GLOBAL_FUNCTION_COUNTER = 1
    TYPE_DEFINITION = {}
    FUNCTION_ARGUMENT_DICT = {}
    FUNCTION_PRINT = {}

    REGISTER_CHECKING = {}
    # REGISTER_CHECK_PASSED = True
    # false if any function calls result in a perserved register being changed
    # true otherwise
    CHECK_STACK = False

    LOAD_TYPE = {}
    SYSCALL_TYPE = {}


    # ANSWER_MATCH = 0
    # ANSWER_TOTAL = 0
    # HIGHEST_INSTRUCTION_COUNT = 0

    c = 0
    while c < len(lines):
        op = lines[c].strip()
        c += 1
        if op not in FUNCTIONS:
            if op == ".def":
                STARTDEFINITION = True
                while STARTDEFINITION:
                    line = lines[c].strip()
                    if line == ".end":
                        STARTDEFINITION = False
                    else:
                        # grab next line and append if line[-1] == "\"
                        while line[-1] == "\\":
                            c += 1
                            line = line[:-1] + lines[c].strip()
                        # line[0] = function name and arguments
                        # line[1] =  outputs
                        line = line.split("->")
                        fun_return = line[1].strip().split(" ")

                        # line[0] = function name
                        # line[1,length-1] = argument types need to be define using type
                        line = line[0].strip().split(" ")
                        VALID = True
                        for x in line[1:]:
                            if x.strip() not in TYPE_DEFINITION:
                                VALID = False
                        if VALID:
                            FUNCTIONS.append(line[0])
                            FUNCTION_ARGUMENT_DICT[line[0].strip()] = line[1:]
                            FUNCTION_PRINT[line[0].strip()] = fun_return

                    c += 1
            elif op == ".type":
                STARTDEFINITION = True
                while STARTDEFINITION:
                    line = lines[c].strip()
                    if line == ".end":
                        STARTDEFINITION = False
                    else:
                        line = line.split(" ")
                        TYPE_DEFINITION[line[0].strip()] = [l.strip() for l in line[1:-2]]
                        LOAD_TYPE[line[0].strip()] = line[-2].strip()
                        SYSCALL_TYPE[line[0].strip()] = line[-1].strip()
                    c += 1
            elif op == ".start_check":
                CHECK_ANSWERS = True
            elif op == ".end_check":
                CHECK_ANSWERS = False
            elif op == ".test_file":
                TESTER_ASM = lines[c].strip()
                c += 1
            elif op == ".check_register":
                register = lines[c].strip().split(" ")
                # register[0] = register to check
                # register[1] = value of that register (IMMEDIATE)
                REGISTER_CHECKING[register[0].strip()] = register[1].strip()
                c += 1
            elif op == ".check_stack":
                CHECK_STACK = True
            elif op == "pause":
                input("Press Enter to Continue...")
            elif op == "exit":
                break
            elif "->" in op:
                print(op.split("->")[1].strip())
        else: # is a function
            print(f"Example #{GLOBAL_FUNCTION_COUNTER}")
            print(op)

            INSTRUCTION_OFFSET = 0
            with open(f"{directory}/arguments.asm", 'w') as filetowrite:
                filetowrite.write(".data \n")

                fun_argument = FUNCTION_ARGUMENT_DICT[op]
                arg_counter = 0
                for x in fun_argument:
                    arg = lines[c].replace("\n", "")
                    c += 1
                    current_type = 0
                    print(f"    {x}:{arg[:30]}")
                    if len(TYPE_DEFINITION[x]) ==  0:
                        # 0
                        filetowrite.write(f"arg{arg_counter}: {arg}\n")
                        while lines[c].strip() != ".end_type":
                            filetowrite.write(lines[c].strip())
                            filetowrite.write("\n")
                            c += 1
                        c += 1
                    else:
                        filetowrite.write(f"arg{arg_counter}: .{TYPE_DEFINITION[x][current_type]} {arg}\n")
                        current_type += 1
                        while current_type < len(TYPE_DEFINITION[x]):
                            arg = lines[c].replace("\n", "")
                            c += 1
                            filetowrite.write(f".{TYPE_DEFINITION[x][current_type]} {arg}\n")
                            current_type += 1
                    arg_counter += 1
                # main
                filetowrite.write(".text\n.globl main\nmain:\n")
                if CHECK_STACK:
                    # $sp value before function call
                    filetowrite.write(f"move $a0, $sp\n")
                    filetowrite.write("li $v0, 1\n")
                    filetowrite.write("syscall\n")
                    # newline
                    filetowrite.write("li $a0, '\\n'\n")
                    filetowrite.write("li $v0, 11\n")
                    filetowrite.write("syscall\n")
                    INSTRUCTION_OFFSET += 6
                # load arguments to registers
                num_argument = 0
                # allocate space on stack prior for arguments
                if arg_counter > 4:
                    filetowrite.write(f"addi $sp, $sp, -{(arg_counter-4)*4}\n")
                for x in range(arg_counter):
                    if x < 4:
                        filetowrite.write(f'{LOAD_TYPE[fun_argument[x]]} $a{x}, arg{x}\n')
                    else:
                        # put onto the stack
                        filetowrite.write(f'{LOAD_TYPE[fun_argument[x]]} $t0, arg{x}\n')
                        filetowrite.write(f"sw $t0, {num_argument}($sp)\n")
                        num_argument += 4
                    INSTRUCTION_OFFSET += 1
                # load values to register
                for reg, val in REGISTER_CHECKING.items():
                    filetowrite.write(f"li {reg}, {val}\n")
                    INSTRUCTION_OFFSET += 1
                # call function
                filetowrite.write(f'jal {op}\n')
                INSTRUCTION_OFFSET += 1
                # deallocate space on stack prior for arguments
                if arg_counter > 4:
                    filetowrite.write(f"addi $sp, $sp, {(arg_counter-4)*4}\n")
                # copy v0 and v1 to t0 and t1 for preservation
                filetowrite.write('move $t0, $v0\n')
                filetowrite.write('move $t1, $v1\n')
                INSTRUCTION_OFFSET += 2
                if CHECK_STACK:
                    # $sp value after function call
                    filetowrite.write(f"move $a0, $sp\n")
                    filetowrite.write("li $v0, 1\n")
                    filetowrite.write("syscall\n")
                    # newline
                    filetowrite.write("li $a0, '\\n'\n")
                    filetowrite.write("li $v0, 11\n")
                    filetowrite.write("syscall\n")
                    INSTRUCTION_OFFSET += 6
                # check register for correct values
                for reg in REGISTER_CHECKING:
                    filetowrite.write(f"move $a0, {reg}\n")
                    filetowrite.write("li $v0, 1\n")
                    filetowrite.write("syscall\n")
                    # newline
                    filetowrite.write("li $a0, '\\n'\n")
                    filetowrite.write("li $v0, 11\n")
                    filetowrite.write("syscall\n")
                    INSTRUCTION_OFFSET += 6
                v_count = 0
                # print result
                for x in FUNCTION_PRINT[op]:
                    if "rec:" in x:
                        x = x.strip().split(":")

                        if "arg" in x[1].strip():
                            filetowrite.write(f"la $a0, {x[1].strip()}\n")
                            if len(x) == 4:
                                filetowrite.write(f"lw $a0, {x[3].strip()}($a0)\n")
                            loop_name = x[1].strip()+(x[3].strip() if len(x) == 4 else "")
                        elif x[1].strip()[0] == 'v':
                            filetowrite.write(f"move $a0, $t{x[1].strip()[1]}\n")
                            loop_name = x[1].strip()
                        else:
                            loop_name = "idk"
                        filetowrite.write(f"lw $t8, 0($a0)\n") # length
                        filetowrite.write(f"lw $t9, 4($a0)\n") # first node

                        filetowrite.write(f"li $a0, 'S'\n") # space
                        filetowrite.write("li $v0, 11\n")
                        filetowrite.write("syscall\n")

                        filetowrite.write(f"li $a0, 'I'\n") # space
                        filetowrite.write("li $v0, 11\n")
                        filetowrite.write("syscall\n")

                        filetowrite.write(f"li $a0, 'Z'\n") # space
                        filetowrite.write("li $v0, 11\n")
                        filetowrite.write("syscall\n")

                        filetowrite.write(f"li $a0, 'E'\n") # space
                        filetowrite.write("li $v0, 11\n")
                        filetowrite.write("syscall\n")

                        filetowrite.write(f"li $a0, ' '\n") # space
                        filetowrite.write("li $v0, 11\n")
                        filetowrite.write("syscall\n")
                        
                        filetowrite.write(f"move $a0, $t8\n") # size
                        filetowrite.write("li $v0, 1\n")
                        filetowrite.write("syscall\n")

                        filetowrite.write(f"li $a0, ' '\n") # space
                        filetowrite.write("li $v0, 11\n")
                        filetowrite.write("syscall\n")

                        filetowrite.write(f"li $a0, '|'\n") # space
                        filetowrite.write("li $v0, 11\n")
                        filetowrite.write("syscall\n")
                        filetowrite.write(f"rec_loop{loop_name}:\n")
                        if x[2].strip() == "11":
                            # filetowrite.write(f"beqz $t8, rec_loop{loop_name}_done\n")
                            filetowrite.write(f"beqz $t9, rec_loop{loop_name}_done\n")
                            filetowrite.write(f"lw $a0, 0($t9)\n") # value of node

                            filetowrite.write(f"lb $a0, 0($t9)\n")
                            filetowrite.write(f"li $v0, 11\n")
                            filetowrite.write("syscall\n")

                            filetowrite.write(f"lb $a0, 1($t9)\n")
                            filetowrite.write(f"li $v0, 11\n")
                            filetowrite.write("syscall\n")

                            filetowrite.write(f"lb $a0, 2($t9)\n")
                            filetowrite.write(f"li $v0, 11\n")
                            filetowrite.write("syscall\n")

                            # filetowrite.write(f"li $v0, {x[2].strip()}\n")
                            # filetowrite.write("syscall\n")
                        else:
                            # filetowrite.write(f"beqz $t8, rec_loop{loop_name}_done\n")
                            filetowrite.write(f"beqz $t9, rec_loop{loop_name}_done\n")
                            filetowrite.write(f"lw $a0, 0($t9)\n") # value of node
                            filetowrite.write(f"li $v0, {x[2].strip()}\n")
                            filetowrite.write("syscall\n")
                        filetowrite.write(f"addi $t8, $t8, -1 \n") # decrement
                        # filetowrite.write(f"beqz $t8, rec_loop{loop_name}_done\n")
                        filetowrite.write(f"lw $t9, 4($t9)\n") # update node
                        filetowrite.write(f"beqz $t9, rec_loop{loop_name}_done\n")
                        filetowrite.write(f"li $a0, ' '\n") # space
                        filetowrite.write("li $v0, 11\n")
                        filetowrite.write("syscall\n")
                        filetowrite.write(f"j rec_loop{loop_name}\n")
                        filetowrite.write(f"rec_loop{loop_name}_done:\n")
                        filetowrite.write(f"li $a0, '|'\n") # space
                        filetowrite.write("li $v0, 11\n")
                        filetowrite.write("syscall\n")
                    else:
                        if "arg" in x:
                            values = x.strip().split("|")
                            for part in values:
                                x = part.strip().split(":")
                                var = fun_argument[int(x[0][x[0].index("arg")+3])]
                                # print(var)
                                filetowrite.write(f"la $a0, {x[0].strip()}\n")
                                if len(x) == 2:
                                    filetowrite.write(f"addi $a0, $a0, {x[1].strip()}\n") # offset
                                    INSTRUCTION_OFFSET += 1 # extra offset in length == 2
                                if len(x) == 6 or len(x) == 7:
                                    start = int(x[1])
                                    end = int(x[2])
                                    increment = int(x[3])
                                    load_instruction = x[4]
                                    syscall_code = int(x[5])
                                    sep = x[6] if len(x) == 7 else " "
                                    # move to t9 to store base address
                                    filetowrite.write(f"move $t9, $a0\n")
                                    INSTRUCTION_OFFSET += 2
                                    while start < end:
                                        filetowrite.write(f"{load_instruction} $a0, {start}($t9)\n")
                                        filetowrite.write(f"li $v0, {syscall_code}\n")
                                        filetowrite.write("syscall\n")
                                        if start < end - increment and sep != "":
                                            filetowrite.write(f"li $a0, '{sep}'\n") # space
                                            filetowrite.write("li $v0, 11\n")
                                            filetowrite.write("syscall\n")
                                            INSTRUCTION_OFFSET += 3
                                        INSTRUCTION_OFFSET += 3
                                        start += increment
                                else:
                                    filetowrite.write(f"li $v0, {SYSCALL_TYPE[var]}\n")
                                    filetowrite.write("syscall\n")
                                    INSTRUCTION_OFFSET += 3
                                # add seperator
                                if part != values[-1]:
                                    filetowrite.write(f"li $a0, ' '\n") # space
                                    filetowrite.write("li $v0, 11\n")
                                    filetowrite.write("syscall\n")
                                    INSTRUCTION_OFFSET += 3
                        else:
                            if v_count < 2:
                                filetowrite.write(f"move $a0, $t{v_count}\n")
                                filetowrite.write("li $v0, 1\n")
                                filetowrite.write("syscall\n")
                                v_count += 1
                                INSTRUCTION_OFFSET += 3
                    # newline
                    filetowrite.write("li $a0, '\\n'\n")
                    filetowrite.write("li $v0, 11\n")
                    filetowrite.write("syscall\n")
                    INSTRUCTION_OFFSET += 3
                # syscall 10
                filetowrite.write("li $v0, 10\n")
                filetowrite.write("syscall\n")
                INSTRUCTION_OFFSET += 2
                # include tester files
                filetowrite.write(f'\n.include "{TESTER_ASM}"')
            # call function after closing arguments file
            GLOBAL_FUNCTION_COUNTER += 1
            output = callFunction(op)
            # print(output[:-1])
            output = [ "-1" if "\\xff" in x else x.strip() for x in output]
            num_register = len(REGISTER_CHECKING)
            if CHECK_STACK:
                num_register += 2
            print("Answer        : " + "\n".join(output[num_register:-1]))
            # Check register
            register_counter = 0
            REGISTERS_MATCHED = True
            if CHECK_STACK:
                REGISTERS_MATCHED = REGISTERS_MATCHED and output[0] == output[1]
                if output[0] != output[1]:
                    print(f"MEMORY LEAK ======================== WARNING WARNING")
                register_counter += 2 # increment to account for $sp
            for reg, val in REGISTER_CHECKING.items():
                REGISTERS_MATCHED = REGISTERS_MATCHED and val == output[register_counter]
                if val != output[register_counter]:
                    print(f"{reg}: Expected: {val} Got: {output[register_counter]}")
                register_counter += 1
            MATCHED = True
            if CHECK_ANSWERS:
                ANSWER_TOTAL += 1
                # check if answers match
                correct_answers = []
                # print correct answers
                a0 = lines[c].replace("\n", "")
                correct_answers.append(a0)
                print(f"Correct Answer: {a0}")
                # print(f"Correct Answer: ")
                c += 1
                for x in FUNCTION_PRINT[op][1:]:
                    ans = lines[c].strip()
                    correct_answers.append(ans)
                    print(ans)
                    c += 1
                for x in range(len(correct_answers)):
                    CORRECT = output[num_register+x].replace('\x00',"").strip() == correct_answers[x]
                    MATCHED = MATCHED and CORRECT
                    if not CORRECT:
                        # print(output)
                        # print(output[num_register+x].strip('\x00') == "")
                        print(f"Expected: {correct_answers[x]} Got: {output[num_register+x]}")
            if MATCHED:
                ANSWER_MATCH += 1
            instruction_count = int(output[-1].strip()) - INSTRUCTION_OFFSET
            print(f"MATCHED: {MATCHED}")
            print(f"REGISTERS_MATCHED: {REGISTERS_MATCHED}")
            print(f"Instruction Count: {instruction_count}\n")
            REGISTER_CHECK_PASSED = REGISTER_CHECK_PASSED and REGISTERS_MATCHED
            if instruction_count > HIGHEST_INSTRUCTION_COUNT:
                HIGHEST_INSTRUCTION_COUNT = instruction_count
    # done testing provide results
    print("=====================================================================")
    print("TEST SUMMARY")
    print(f"REGISTERS CHECKING MATCH: {REGISTER_CHECK_PASSED}")
    print(f"RESULTS: {ANSWER_MATCH}/{ANSWER_TOTAL}")
    print(f"HIGHEST INSTRUCTION COUNT: {HIGHEST_INSTRUCTION_COUNT}")

    return REGISTER_CHECK_PASSED, ANSWER_MATCH, ANSWER_TOTAL, HIGHEST_INSTRUCTION_COUNT
# print(sys.argv)

directory = sys.argv[1]
if directory == "/":
    directory = sys.argv[1][:-1]

COMMAND_LINE = f"java -jar {directory}/MarsFall2020.jar p {directory}/arguments.asm --noGui --main -i -q -g"

# if len(sys.argv) == 4:
#     with open(sys.argv[3], "w") as output:
#         sys.stdout = output
#         readFile(sys.argv[2], directory)
# elif len(sys.argv) == 3:
#     readFile(sys.argv[2], directory)

# print(sys.argv)

REGISTER = True 
MATCH = 0
TOTAL = 0
HIGH = 0

if "-o" in sys.argv:
    location = sys.argv.index("-o")
    output_file = sys.argv[location+1]
    with open(output_file, "w") as output:
        sys.stdout = output
        for x in sys.argv[2:location]:
            print("=====================================================================")
            print(f"RUNNING {x} FILE ===================================================")
            REGISTER, MATCH, TOTAL, HIGH = readFile(x, directory, REGISTER, MATCH, TOTAL, HIGH)
else:
    for x in sys.argv[2:]:
        print("=====================================================================")
        print(f"RUNNING {x} FILE ===================================================")
        REGISTER, MATCH, TOTAL, HIGH = readFile(x, directory, REGISTER, MATCH, TOTAL, HIGH)

    # print(sys.argv[2:location])
    # print(output)
