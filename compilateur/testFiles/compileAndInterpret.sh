#!/bin/sh
../comp $1 out.asm
python3 ../asm_interpreter/interpreter.py out.asm