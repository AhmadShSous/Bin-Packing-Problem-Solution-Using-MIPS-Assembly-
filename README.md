# Bin-Packing-Problem-Solution-Using-MIPS-Assembly-

Project Overview:

This project provides a solution to the Bin Packing Problem using MIPS Assembly language.
It was developed as part of the course ENCS4370 - Computer Architecture, Spring Semester 2024/2025.

The goal is to pack a list of items (floating-point sizes between 0 and 1) into the minimum number of unit-capacity bins using two heuristics:

1) First Fit (FF)

2) Best Fit (BF)

Features
Read item sizes from an input text file

Validate the input file and display appropriate error messages

Infinite user menu loop until the user decides to exit (q or Q)

User selects heuristic method (FF or BF)

Write the results (bins and item allocations) to an output text file

Usage
Run the program in a MIPS simulator (such as MARS or SPIM).

Enter the input file name when prompted.

Choose the heuristic (FF or BF) to apply.

View the output in the generated text file.

File Structure
main.asm: Main program file containing the user interface and control logic.

first_fit.asm: First Fit heuristic implementation.

best_fit.asm: Best Fit heuristic implementation.

utils.asm: Utility functions (file handling, validation, printing).

Note: Make sure the input file is correctly formatted with floating-point numbers separated by space
