# Bin-Packing-Problem-Solution-Using-MIPS-Assembly-

## Project Description
This project implements the **Bin Packing Problem** using MIPS Assembly Language.
It reads a list of floating-point numbers from a file, where each number represents an item size (between 0 and 1), and organizes these items into bins with a capacity of 1.0.

The project offers two heuristics:
- **First Fit (FF)**: Places each item into the first bin that has enough space.
- **Best Fit (BF)**: Places each item into the bin where it leaves the least remaining space.

The program then writes the results into an output file, listing:
- The minimum number of bins used
- The contents of each bin

---

## Features
- Read items from a file.
- Validate and store only numbers between 0 and 1.
- Allow the user to select between First Fit (FF) and Best Fit (BF) heuristics.
- Store bins and their items in separate arrays.
- Print the results in the console and save them into an output file.
- Separate bin contents using a special separator (0.5).
- Clear/reset data between different heuristic runs.
- Robust error handling if a file fails to open or invalid input is found.

---

## Technologies Used
- **MIPS Assembly Language** (MIPS32 ISA)
- **SPIM / MARS simulator** for running and testing the assembly code

---

## How it Works
1. **Display a Menu**: User can choose to load file, select heuristic, or exit.
2. **Load Input File**: File containing numbers is loaded into a buffer, parsed, validated, and stored.
3. **Choose Heuristic**: Based on user's choice (FF or BF), the bin packing is executed.
4. **Store Results**: Store the packed bins, insert separators, and output the results to an output file.
5. **Support Re-run**: Clearing bins and allowing multiple heuristic trials without restarting the program.

---


## Example of Usage
- User loads a file containing: `0.3 0.7 0.4 0.6 0.5`
- Selects "First Fit" heuristic
- Output:
```
Minimum number of required bins: 3
Bins contents:
Bin 1: 0.300 0.700
Bin 2: 0.400 0.600
Bin 3: 0.500
```
- Same can be done using "Best Fit" which might yield different packing based on minimal leftover space.

---

## Notes
- Make sure your input file has floating point numbers separated by spaces, tabs, or newlines.
- Only numbers strictly between 0.0 and 1.0 are stored.
- MIPS system calls used for file I/O, printing, memory management.
- Custom floating-point parsing was implemented instead of using library functions.

---

## Author
- Ahmad Shaher Sous
- Project Supervisor: Dr. Radi Jarrar

---

Ready to include this in your portfolio or CV to showcase advanced assembly-level programming skills!

---

