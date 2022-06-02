from fileinput import filename
import sys

MEMORY_SIZE = 20

def get_asm_code(filename):
    f = open(filename, "r")

    asm_code = f.readlines()
    asm_lines = []

    for line in asm_code:
        line = line.replace("\n", "")
        asm_lines.append(line.split("\t"))

    f.close()

    return asm_lines

def execute_asm(lines):
    memory = [0] * MEMORY_SIZE

    i = 0
    while i < len(lines):
        if lines[i][0] == "ADD":
            memory[int(lines[i][1])] = memory[int(lines[i][2])] + memory[int(lines[i][3])]
            #print("op1=", memory[int(lines[i][2])], "op2=", memory[int(lines[i][3])])
        elif lines[i][0] == "SUB":
            memory[int(lines[i][1])] = memory[int(lines[i][2])] - memory[int(lines[i][3])]
        elif lines[i][0] == "MUL":
            memory[int(lines[i][1])] = memory[int(lines[i][2])] * memory[int(lines[i][3])]
        elif lines[i][0] == "DIV":
            memory[int(lines[i][1])] = memory[int(lines[i][2])] / memory[int(lines[i][3])]
        elif lines[i][0] == "COP":
            memory[int(lines[i][1])] = memory[int(lines[i][2])]
        elif lines[i][0] == "AFC":
            memory[int(lines[i][1])] = int(lines[i][2])
        elif lines[i][0] == "JMP" and (int(lines[i][1]) - 1) != i:
            i = int(lines[i][1]) - 1
            continue
        elif lines[i][0] == "JMF" and (int(lines[i][1]) - 1) != i:
            if memory[int(lines[i][1])] == 0:
                i = int(lines[i][2]) - 1
                continue
        elif lines[i][0] == "SUP":
            if memory[int(lines[i][2])] > memory[int(lines[i][3])]:
                memory[int(lines[i][1])] = 1
            else:
                memory[int(lines[i][1])] = 0
        elif lines[i][0] == "INF":
            if memory[int(lines[i][2])] < memory[int(lines[i][3])]:
                memory[int(lines[i][1])] = 1
            else:
                memory[int(lines[i][1])] = 0
        elif lines[i][0] == "EQU":
            if memory[int(lines[i][2])] == memory[int(lines[i][3])]:
                memory[int(lines[i][1])] = 1
            else:
                memory[int(lines[i][1])] = 0
        elif lines[i][0] == "PRI":
            print(memory[int(lines[i][1])])
        elif lines[i][0] == "LOA":
            memory[int(lines[i][1])] = memory[memory[int(lines[i][2])]]
        elif lines[i][0] == "STR":
            memory[memory[int(lines[i][1])]] = memory[int(lines[i][2])]
            

        i += 1

def main():
    if len(sys.argv) < 2:
        print("Usage: ./interpreter.py [file]")
        sys.exit(1)
    else:
        filename = sys.argv[1]
        asm_code = get_asm_code(filename)
        execute_asm(asm_code)
        

if __name__ == "__main__":
    main()