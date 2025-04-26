.data
Menu_msg : .asciiz "\n--- Bin Packing Menu ---\n1. Enter Input File Name\n2. Choose Heuristic (FF or BF)\n3. Exit (q or Q to quit)\nEnter your choice: "
Exit_msg : .asciiz "\n Exiting the program...\n"
File : .asciiz "\nEnter the input file name: "
Heuristic: .asciiz "\nEnter the heuristic method (FF or BF): "
Error_msg : .asciiz "\n Invalid choice. Please try again.\n"
swap_choisce : .asciiz "\nPlese choose number 1 then 2"
YES : .asciiz "\n yes is true \n"
#file_name: .space 100 # Space to store the input file name
method : .space 2

# Bins structure
bins: .space 400 # Array to store remaining capacity (100 bins)
bin_counts: .space 400 # Array to store item counts per bin (100 bins)
bins_items: .space 40000 # 2D array (100 bins × 25 items max)
bins_count: .word 0 # Number of bins used
items_count: .word 0 # Number of valid items
no_bins_msg: .asciiz "No bins were created!\n"
min_bin: .asciiz "minimum number of required bins: "

sum: .float 0.0
newLine: .asciiz "\n"
newline: .asciiz "\n"
space: .asciiz " "
filename1: .asciiz "C:\\Users\\HP\\OneDrive\\Desktop\\project Arc\\input.txt"
filename: .space 256
buffer: .space 1024 #to store the all files (array of char)
.align 2
items: .space 400 #array having all size of items (array of floating numbers)
error_open: .asciiz "Error: Can't open file.\n"
error_invalid: .asciiz "Error: Invalid input found.\n"
prompt_file: .asciiz "Enter input file name:\n"
output_file: .asciiz "C:\\Users\\HP\\OneDrive\\Desktop\\project Arc\\output.txt"
prompt: .asciiz "The numbers in the array are:\n"
notes: .asciiz "Note: Only numbers between 0 and 1 were stored\n"
out_of_range: .asciiz "Skipped number (not 0-1): "

prompt_bins: .asciiz "\nBins contents:\n"
bin_header: .asciiz "Bin "
colon: .asciiz ": "

# Floating point constants
float_zero: .float 0.0
float_one: .float 1.0
float_half: .float 5.0 # Separator value

# New array to store all items with 0.5 separators
All_item_inAllBins: .space 10400 # 2600 elements * 4 bytes
all_items_count: .word 0 # Number of elements in All_item_inAllBins

All_item_inAllBins2: .space 10400 # 2600 elements * 4 bytes
all_items_count2: .word 0 # Number of elements in All_item_inAllBins


# ????? ??????? ???????
prompt_all_items: .asciiz "\nAll items in bins (separated by 0.5):\n"
no_items_msg: .asciiz "No items found in any bins!\n"

 

buffer1: .space 32
buffer2: .space 32
thousand: .float 1000.0
half: .float 0.5
five: .float 5.0
error_msg: .asciiz "Error opening file!" # ????? ???
test_data: .asciiz "0.500" # ?????? ????????

bins_contents_label: .asciiz "Bins contents:\n"
min_bins_label: .asciiz "minimum number of required bins: "

bin_label: .asciiz "Bin "
colon_space: .asciiz ": "

 

bigFloat: .float 1.1 # Large value for comparison
one_float: .float 1.0 # Constant 1.0

#itemCount: .word 9 # Number of items


binCount: .word 0 # Current number of bins used
binItems: .space 400 # Space to track items in each bin (100 bins × 4 items × 4 bytes)
binItemCounts: .space 400 # Space to track number of items in each bin (100 bins × 4 bytes)

msg_result: .asciiz "Total bins used: "

bin_msg: .asciiz "Bin "

comma_space: .asciiz ", "
msg_item_processing: .asciiz "\nProcessing item: "
msg_bin_search: .asciiz "Searching for best bin...\n"
msg_bin_found: .asciiz " Best bin found: bin "
msg_new_bin: .asciiz " No suitable bin, creating new bin "
msg_bin_updated: .asciiz " Updated bin contents: "
msg_bin_current: .asciiz "\nCurrent bins state:\n"

 

.text
.globl main
main :
# function to Print the Menu
Menu :
li $v0 , 4 # sevice 4 to print string
la $a0 ,Menu_msg # a0 pointer the location of massege menu
syscall
# get user input
li $v0 , 12 # service 12 to read char ....... the value is store in v0
syscall # .
# .
move $t0, $v0
# Check if the user wants to quit (q or Q)
li $t1, 113 # ASCII value for 'q' =113
li $t2, 81 # ASCII value for 'Q' = 81
li $t3, 51 # ASCII value for '3' =51
beq $t0, $t1, exit_program
beq $t0, $t2, exit_program
beq $t0, $t3, exit_program

# If the user chose option 1 (Enter Input File Name)
li $t3, 49 # ASCII value for '1' =z 49
beq $t0, $t3, Enter_File

# If the user chose option 2 (Choose Heuristic)
li $t3, 50 # ASCII value for '2'
beq $t0, $t3, choose_heuristic

# If invalid choice, print error message and loop back
li $v0, 4
la $a0, Error_msg
syscall
j Menu

Enter_File:

jal get_filename
jal read_file
jal print_numbers
jal print_notes

li $s0 , 1 # to sure and choose 2
j Menu

#......................................................to get from file and store in array
#...get the file name
get_filename:
# Print prompt
li $v0, 4
la $a0, newLine
syscall
# Print prompt
li $v0, 4
la $a0, prompt_file
syscall

# Read filename read string
li $v0, 8
la $a0, filename
li $a1, 256
syscall

# Remove newline from filename
la $t0, filename
remove_newline:
lb $t1, 0($t0)
beq $t1, '\n', found_newline
beqz $t1, done_remove # finish reading the filename and removing all newlines by zero
addi $t0, $t0, 1 #increment the index of array of string by one
j remove_newline
found_newline:
sb $zero, 0($t0) #replace the new line by zero
done_remove:
jr $ra

 


#....read from file and store in buffer
read_file:
# Open file
li $v0, 13
la $a0, filename
li $a1, 0
syscall
move $s0, $v0
bltz $s0, error_open_label #if the file not found or can not open it the value of v0 is negative

# Read file into (buffer)
li $v0, 14
move $a0, $s0
la $a1, buffer
li $a2, 1024 #maximum nuber od characters
syscall

# Add null terminator after store the file in buffer
la $t1, buffer
add $t1, $t1, $v0 #$t0 = end of string
sb $zero, 0($t1) # add null end of buffer

# Parse numbers from buffer (.....t0 have the address of buffer..... t1 have the address of items... t2 number of valid items (number of elements in items))
la $t0, buffer
la $t1, items
li $t2, 0

# f5 contain zero and f6 contain one this to check if number is valid or not
# Load float constants
l.s $f5, float_zero
l.s $f6, float_one


#start of parse the buffer and store in items
parse_loop:
lb $t3, 0($t0) #to store the element of t0>> $t3 = buffer[t0] the end is zero
beqz $t3, parse_done #end of buffer and finish parse
# if space or tab or newline skip in (start)
beq $t3, ' ', skip_space
beq $t3, '\t', skip_space
beq $t3, '\n', skip_space

# Initialize number parsing
li $t4, 0 #to store the integer part
li $t5, 0 #to store floaat number but same of integer
li $t6, 1 #to calculte the 1^n (n number of digit of each float number) t5/t6 in end
li $t7, 0 #to select the number is integer or float(flag)
# in end adding thr t4 to t5/6
parse_number: #to check each character and storing it integer part float part the conacat it
lb $t3, 0($t0)
#end of each number
beqz $t3, end_number
beq $t3, ' ', end_number
beq $t3, '\t', end_number
beq $t3, '\n', end_number
#to know when reaching point we enter in floating part
beq $t3, '.', found_decimal

sub $t3, $t3, '0'
blt $t3, 0, invalid_digit
bgt $t3, 9, invalid_digit

beqz $t7, integer_part
b fractional_part

integer_part:#mull * and then add the new number
mul $t4, $t4, 10
add $t4, $t4, $t3
j next_char

fractional_part:#same the integer but div when end 10 ^number of digit t6
mul $t5, $t5, 10
add $t5, $t5, $t3
mul $t6, $t6, 10
j next_char

found_decimal: #if float change flag 1
li $t7, 1
j next_char

invalid_digit:
j next_char

next_char:
addi $t0, $t0, 1
j parse_number

end_number: # t4 integer part t5 floating part but same integer t6 number of digits for floating number n 10^n
# Convert to float
mtc1 $t4, $f0 #moving the value of t4 as floating number in $f reg
cvt.s.w $f0, $f0 #to convert the value in f0 from integer to float ().0000

beqz $t7, check_range #if the integer part is larger than 1

mtc1 $t5, $f1 #moving the value of t5 as floating number in $f reg
cvt.s.w $f1, $f1 #to convert the value in f1 from integer to float ().0000
mtc1 $t6, $f2 #moving the value of t6 as floating number in $f reg
cvt.s.w $f2, $f2 #to convert the value in f2 from integer to float ().0000
div.s $f1, $f1, $f2 #to div the floating part as integer by number off digit 254 /1000 0.254

add.s $f0, $f0, $f1 #the number is f0 finish each number store in f0

check_range: #f0 have the integer part number f5 = 0, f6 =1
# Check if 0 <= number <= 1
c.lt.s $f0, $f5 # If number < 0.0
bc1t number_invalid

c.lt.s $f6, $f0 # If 1.0 < number
bc1t number_invalid

# Valid number - store it in items (t1 address of items)
s.s $f0, 0($t1) #store the float number in items[t1]
addi $t1, $t1, 4 #add 4 because is the floating number 4 bytes
addi $t2, $t2, 1 #number of items
j skip_space #after sore each number adding one to next char in buffer

#to print the number is invalid out of range
number_invalid:
# Print skipped number message
li $v0, 4
la $a0, out_of_range
syscall

mov.s $f12, $f0
li $v0, 2 #print the float
syscall

li $v0, 4
la $a0, newLine
syscall

j skip_space #after print invalid number increment the t0 by one

skip_space:
addi $t0, $t0, 1
j parse_loop

#finish reading the buffer
parse_done:
li $v0, 16 # close the file
move $a0, $s0
syscall
jr $ra


# to print numbers of array items............................................
print_numbers:
li $v0, 4
la $a0, prompt
syscall

la $t0, items
li $t1, 0

print_loop:
beq $t1, $t2, print_done

l.s $f12, 0($t0)
li $v0, 2
syscall

addi $t3, $t1, 1
beq $t3, $t2, no_space #t2 number of elements

li $v0, 4
la $a0, space
syscall

no_space:
addi $t0, $t0, 4
addi $t1, $t1, 1
j print_loop

print_done: #?????????
sw $t2, items_count # <-- ????? ??? ????? ???? ??? ??????? ???????
li $v0, 16
move $a0, $s0
syscall
jr $ra

print_notes:
li $v0, 4
la $a0, notes
syscall
jr $ra

error_open_label:
li $v0, 4
la $a0, error_open
syscall
li $v0, 10
syscall

 

choose_heuristic :

beq $s0,$zero,Menu #cheak if enter the file name

li $v0, 4
la $a0, Heuristic # to print the massege to choose FF or BF
syscall

# Read heuristic input (FF or BF)
la $a0,method
li $a1 , 3
li $v0,8
syscall

la $t0,method
lb $t1,0($t0) # to read the first character load byte
lb $t2 ,1($t0) # to read the seconed character load byte

li $t3,70 # ASCII value for 'F'
beq $t3 ,$t1 ,cheak_FF
li $t3,102 # ASCII value for 'f'
beq $t3 ,$t1 ,cheak_FF

li $t4 ,66 # ASCII value for 'B'
beq $t4 , $t1 , cheak_BF
li $t4, 98 # ASCII value for 'b'
beq $t4 , $t1 , cheak_BF

# If invalid choice, loop back
li $v0, 4
la $a0, Error_msg
syscall
j choose_heuristic

cheak_FF :
li $t5,70 # ASCII value for 'F'
beq $t5 ,$t2 ,First_fit
li $t5,102 # ASCII value for 'f'
beq $t5 ,$t2 , First_fit

li $v0, 4
la $a0, Error_msg
syscall
j choose_heuristic

cheak_BF :
li $t5,70 # ASCII value for 'F'
beq $t5 ,$t2 ,Best_fit
li $t5,102 # ASCII value for 'f'
beq $t5 ,$t2 , Best_fit

li $v0, 4
la $a0, Error_msg
syscall
j choose_heuristic

First_fit :
li $v0,4
la $a0,YES
syscall
jal first_fit
jal allPrintingItems # Call the new procedure
jal write_to_file # ??????? print_bins ????
j Menu

Best_fit:
    # Clear arrays first
    jal empty
    jal empty2
    jal empty3
    
    li $v0,4
    la $a0,YES
    syscall
    
    la $t0, items           # Load address of items array
    lw $s1, items_count     # $s1 = number of items
    li $t2, 0               # $t2 = current item index (i)

loop_items:
    beq $t2, $s1, print_result # If processed all items, print results

    # Print which item we're processing
    li $v0, 4
    la $a0, msg_item_processing
    syscall

    li $v0, 2
    sll $t3, $t2, 2
    add $t4, $t0, $t3
    l.s $f12, 0($t4)        # $f12 = items[i]
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Initialize search variables
    li $t5, -1              # bestFitIndex = -1
    la $t9, bigFloat
    l.s $f1, 0($t9)         # bestRemaining = 1.1 (large value)

    la $t7, bins            # Load bins array address
    lw $t8, binCount        # $t8 = current bin count
    li $t6, 0               # $t6 = current bin index (j)

    # Print that we're searching for bins
    li $v0, 4
    la $a0, msg_bin_search
    syscall

search_bins:
    beq $t6, $t8, done_search # If checked all bins, proceed

    # Calculate bin address and check bounds
    sll $t9, $t6, 2
    add $s0, $t7, $t9       # $s0 = address of bins[j]

    # Check if address is within bounds
    la $s2, bins
    addi $s2, $s2, 400
    bge $s0, $s2, Menu      # Exit if out of bounds

    l.s $f4, 0($s0)         # $f4 = bins[j]
    l.s $f5, one_float      # $f5 = 1.0
    sub.s $f6, $f5, $f4     # $f6 = remaining space (1.0 - bins[j])

    add.s $f7, $f4, $f12    # $f7 = current_bin_sum + item
    l.s $f8, one_float
    c.eq.s $f7, $f8         # Does the sum equal exactly 1.0?
    bc1t use_this_bin

    # Check if item fits in this bin
    c.lt.s $f12, $f6        # if item <= remaining space
    bc1f skip_bin

    # Calculate how much space would remain after adding item
    sub.s $f7, $f6, $f12    # $f7 = remaining - item

    # Check if this is the best fit so far
    c.lt.s $f7, $f1         # if new remaining < best remaining
    bc1f skip_bin

    # Found a better bin
    mov.s $f1, $f7          # Update best remaining
    move $t5, $t6           # Update best bin index

skip_bin:
    addi $t6, $t6, 1        # Move to next bin
    j search_bins

use_this_bin:
    move $t5,$t6
    j done_search

done_search:
    bgez $t5, use_existing_bin # If found a bin, use it

    # No bin found - create new one
    li $v0, 4
    la $a0, msg_new_bin
    syscall

    lw $t8, binCount        # Get current bin count
    move $a0, $t8           # Print new bin number
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    sll $t9, $t8, 2
    add $s0, $t7, $t9       # Calculate address for new bin

    # Check bounds
    la $s2, bins
    addi $s2, $s2, 400
    bge $s0, $s2, Menu      # Exit if out of bounds

    s.s $f12, 0($s0)        # Store item in new bin

    # Update binItems and binItemCounts
    la $s3, binItems        # Load binItems array
    sll $t9, $t8, 4         # Each bin has space for 4 items (4 × 4 bytes)
    add $s4, $s3, $t9       # $s4 = address for this bin's items

    s.s $f12, 0($s4)        # Store first item in this bin

    la $s5, binItemCounts   # Load binItemCounts array
    sll $t9, $t8, 2
    add $s6, $s5, $t9
    li $t9, 1
    sw $t9, 0($s6)          # Set item count for this bin to 1

    addi $t8, $t8, 1        # Increment bin count
    sw $t8, binCount        # Store updated count

    j next_item

use_existing_bin:
    # Print which bin we're using
    li $v0, 4
    la $a0, msg_bin_found
    syscall

    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Update existing bin
    sll $t9, $t5, 2
    add $s0, $t7, $t9       # Calculate address of best bin

    l.s $f8, 0($s0)         # Get current bin value
    add.s $f9, $f8, $f12    # Add item to bin
    s.s $f9, 0($s0)         # Store updated value

    # Update binItems and binItemCounts
    la $s3, binItems        # Load binItems array
    sll $t9, $t5, 4         # Each bin has space for 4 items
    add $s4, $s3, $t9       # $s4 = address for this bin's items

    la $s5, binItemCounts   # Load binItemCounts array
    sll $t9, $t5, 2
    add $s6, $s5, $t9
    lw $t9, 0($s6)          # Get current item count for this bin

    sll $t7, $t9, 2         # Calculate offset for new item
    add $s7, $s4, $t7
    s.s $f12, 0($s7)        # Store new item in bin

    addi $t9, $t9, 1        # Increment item count
    sw $t9, 0($s6)          # Store updated count

next_item:
    addi $t2, $t2, 1        # Move to next item
    j loop_items

print_result:
    # Print total bins used
    li $v0, 4
    la $a0, msg_result
    syscall

    li $v0, 1
    lw $a0, binCount
    syscall

    li $v0, 4
    la $a0, newline
    syscall

continue_after_loop:
    jal allPrintingItems2
    jal write_to_file2
    j Menu

allPrintingItems2:
    # Clear All_item_inAllBins2 first
    la $t9, All_item_inAllBins2
    li $t8, 0
    li $t7, 1600            # 100 bins × 4 items × 4 bytes
clear_all_items:
    beqz $t7, end_clear
    sw $t8, 0($t9)
    addi $t9, $t9, 4
    subi $t7, $t7, 4
    j clear_all_items
end_clear:

    la $t0, All_item_inAllBins2 # Destination pointer
    lw $t1, binCount        # Number of bins
    li $t2, 0               # Current bin index
    la $t3, binItemCounts    # Pointer to bin_counts array
    la $t4, binItems        # Pointer to bins_items 2D array
    l.s $f6, float_half     # Load 0.5 into $f6

loop_bins_BF:
    beq $t2, $t1, end_loop_bins_BF # Exit loop if all bins processed
    lw $t5, 0($t3)          # Item count for current bin
    li $t6, 0               # Item index

loop_items2_BF:
    beq $t6, $t5, end_loop_items_BF # Exit loop if all items processed
    # Calculate item address: bins_items + (bin_index * 16) + (item_index *4)
    mul $t7, $t2, 16        # Bin offset (each bin is 16 bytes)
    sll $t8, $t6, 2         # Item offset (each item is 4 bytes)
    add $t7, $t7, $t8       # Total offset
    add $t7, $t4, $t7       # Address of the item in bins_items
    l.s $f4, 0($t7)         # Load the item value
    s.s $f4, 0($t0)         # Store in All_item_inAllBins
    addi $t0, $t0, 4        # Advance destination pointer
    addi $t6, $t6, 1        # Next item
    j loop_items2_BF

end_loop_items_BF:
    # Add 0.5 separator after the bin's items
    s.s $f6, 0($t0)
    addi $t0, $t0, 4
    # Move to next bin
    addi $t2, $t2, 1
    addi $t3, $t3, 4
    j loop_bins_BF

end_loop_bins_BF:
    # Calculate and store the total number of elements in All_item_inAllBins
    la $t9, All_item_inAllBins2
    sub $t9, $t0, $t9       # Total bytes used
    srl $t9, $t9, 2         # Divide by 4 to get element count
    sw $t9, all_items_count2
    jr $ra

write_to_file2:
    # Open file
    li $v0, 13
    la $a0, output_file
    li $a1, 1               # Write flag
    syscall
    move $s0, $v0           # Save file descriptor

    # Write "minimum number of required bins: "
    la $a0, min_bins_label
    jal strlenBF
    move $a2, $v0
    li $v0, 15
    move $a0, $s0
    la $a1, min_bins_label
    syscall

    # Write bin count
    lw $t0, binCount
    la $a0, buffer1
    move $a1, $t0
    jal int_to_strBF

    la $a0, buffer1
    jal strlenBF
    move $a2, $v0
    li $v0, 15
    move $a0, $s0
    la $a1, buffer1
    syscall

    # Write newline
    li $v0, 15
    move $a0, $s0
    la $a1, newline
    li $a2, 1
    syscall

    # Write "Bins contents:"
    la $a0, bins_contents_label
    jal strlenBF
    move $a2, $v0
    li $v0, 15
    move $a0, $s0
    la $a1, bins_contents_label
    syscall

    # Initialize counters
    li $s4, 1               # Bin number starts at 1
    li $s5, 0               # Flag for new bin (0 = need to print header)

    # Process all items
    la $s1, All_item_inAllBins2
    lw $s2, all_items_count2
    li $s3, 0               # Current item index

loop_items1BF:
    bge $s3, $s2, end_loop_BF # Exit if processed all items

    # Get current item
    sll $t4, $s3, 2
    add $t4, $s1, $t4
    l.s $f0, 0($t4)

    # Check if it's a separator (0.5)
    l.s $f6, five
    c.eq.s $f0, $f6
    bc1t handle_separator_BF

    # Check if we need to print bin header
    beqz $s5, print_bin_header

continue_after_header:
    # Convert float to string with 3 decimal places
    l.s $f1, thousand
    l.s $f2, half
    mul.s $f0, $f0, $f1
    add.s $f0, $f0, $f2
    cvt.w.s $f0, $f0
    mfc1 $t0, $f0

    # Convert to string
    la $a0, buffer1
    move $a1, $t0
    jal int_to_strBF

    # Format with decimal point
    la $t1, buffer1
    la $t2, buffer2
    jal strlenBF
    move $t3, $v0

    # Pad with zeros if needed
    li $t7, 4
    sub $t7, $t7, $t3       # Number of zeros to pad

    # Shift digits right
    move $t5, $t3
shift_loop_BF:
    beqz $t5, end_shift_BF
    addi $t6, $t5, -1
    addu $t8, $t1, $t6
    lb $t9, 0($t8)
    addu $t6, $t6, $t7
    addu $t8, $t1, $t6
    sb $t9, 0($t8)
    addi $t5, $t5, -1
    j shift_loop_BF
end_shift_BF:

    # Fill leading zeros
    li $t5, 0
fill_zeros_BF:
    beq $t5, $t7, end_fill_BF
    addu $t8, $t1, $t5
    li $t9, '0'
    sb $t9, 0($t8)
    addi $t5, $t5, 1
    j fill_zeros_BF
end_fill_BF:

    # Add decimal point
    add $t3, $t3, $t7
    addu $t8, $t1, $t3
    sb $zero, 0($t8)

    lb $t4, 0($t1)
    sb $t4, 0($t2)
    li $t4, '.'
    sb $t4, 1($t2)

    # Copy remaining digits
    li $t5, 1
    li $t6, 2
copy_loop_BF:
    bge $t5, $t3, end_copy_BF
    addu $t9, $t1, $t5
    lb $t8, 0($t9)
    addu $t7, $t2, $t6
    sb $t8, 0($t7)
    addi $t5, $t5, 1
    addi $t6, $t6, 1
    j copy_loop_BF
end_copy_BF:
    addu $t9, $t2, $t6
    sb $zero, 0($t9)

    # Write formatted number
    la $a0, buffer2
    jal strlenBF
    move $a2, $v0

    li $v0, 15
    move $a0, $s0
    la $a1, buffer2
    syscall

    # Write space
    li $v0, 15
    move $a0, $s0
    la $a1, space
    li $a2, 1
    syscall

    j next_item2_BF

print_bin_header:
    # Write "Bin X: "
    la $a0, bin_label
    jal strlenBF
    move $a2, $v0
    li $v0, 15
    move $a0, $s0
    la $a1, bin_label
    syscall

    # Write bin number
    la $a0, buffer1
    move $a1, $s4
    jal int_to_strBF

    la $a0, buffer1
    jal strlenBF
    move $a2, $v0
    li $v0, 15
    move $a0, $s0
    la $a1, buffer1
    syscall

    # Write ": "
    li $v0, 15
    move $a0, $s0
    la $a1, colon_space
    li $a2, 2
    syscall

    addi $s4, $s4, 1        # Increment bin number
    li $s5, 1               # Set flag that we printed header
    j continue_after_header

handle_separator_BF:
    # Write newline
    li $v0, 15
    move $a0, $s0
    la $a1, newline
    li $a2, 1
    syscall

    li $s5, 0               # Reset flag for next bin
    j next_item2_BF

next_item2_BF:
    addi $s3, $s3, 1
    j loop_items1BF

end_loop_BF:
    # Close file
    li $v0, 16
    move $a0, $s0
    syscall

    j Menu

# Helper functions
int_to_strBF:
    move $t0, $a0           # Buffer address
    move $t1, $a1           # Number to convert
    li $t3, 10              # Divisor

    beqz $t1, zero_case_BF  # Handle zero specially

convert_loop_BF:
    divu $t1, $t3           # Divide by 10
    mfhi $t4                # Remainder
    mflo $t1                # Quotient
    addi $t4, $t4, '0'      # Convert to ASCII
    sb $t4, 0($t0)          # Store digit
    addi $t0, $t0, 1        # Advance pointer
    bnez $t1, convert_loop_BF # Continue if quotient != 0

    sb $zero, 0($t0)        # Null-terminate

    # Reverse the string
    move $t5, $a0           # Start of buffer
    addi $t0, $t0, -1       # End of digits

reverse_loop_BF:
    bge $t5, $t0, done_BF
    lb $t6, 0($t5)
    lb $t7, 0($t0)
    sb $t7, 0($t5)
    sb $t6, 0($t0)
    addi $t5, $t5, 1
    addi $t0, $t0, -1
    j reverse_loop_BF

zero_case_BF:
    li $t4, '0'
    sb $t4, 0($t0)
    sb $zero, 1($t0)

done_BF:
    jr $ra

strlenBF:
    li $v0, 0               # Initialize length

strlen_loop_BF:
    lb $t0, 0($a0)          # Load byte
    beqz $t0, strlen_end_BF # If null terminator, exit
    addi $a0, $a0, 1        # Advance pointer
    addi $v0, $v0, 1        # Increment length
    j strlen_loop_BF

strlen_end_BF:
    jr $ra

#-----------------------------------------------------------
# First Fit bin packing algorithm
#-----------------------------------------------------------
#-----------------------------------------------------------
first_fit:
la $s0, items # Load items array address
lw $s1, items_count # Load items count
li $t9, 0 # Current item index
# Initialize bins
sw $zero, bins_count # Reset bin count

process_item:
bge $t9, $s1, end_ff # Process all items

# Load cur1rent item
mul $t0, $t9, 4
add $t0, $s0, $t0
l.s $f5, 0($t0) # $f5 = current item

li $t1, 0 # Bin index EVERY ONE START FROM FIRST INDEX
la $t2, bins # Bins remaining capacity
la $t3, bin_counts # Bin item counts
li $t4, 0 # Found flag

search_bin:
lw $t8, bins_count # ??? ??? ???????? ??????
bge $t1, $t8, add_new_bin_ff # ??? ?? ??? ???? ??????? ???? ??????

# ???? ?? ????? ????????
mul $t5, $t1, 4
add $t5, $t2, $t5
l.s $f6, 0($t5) # $f6 = ????? ???????? ??????? ??????

# ???? ??? ??? ?????? ????
c.le.s $f5, $f6 # ??? ??? ??? ?????? ? ????? ????????
bc1f next_bin_ff # ??? ??? ????? ??? ??????? ??????


# Place item in bin
sub.s $f6, $f6, $f5
s.s $f6, 0($t5) # Update remaining capacity

# Store item in 2D array
lw $t6, 0($t3) # Get current item count
mul $t7, $t1, 100 # Calculate row offset (25 items × 4 bytes)
mul $t8, $t6, 4 # Column offset
add $t7, $t7, $t8
la $t8, bins_items
add $t7, $t8, $t7
s.s $f5, 0($t7) # Store item

# Update item count
addi $t6, $t6, 1
sw $t6, 0($t3)

li $t4, 1 # Mark as placed
j next_item_ff

next_bin_ff:
addi $t1, $t1, 1
addi $t3, $t3, 4
j search_bin

add_new_bin_ff:
# Create new bin
lw $t0, bins_count
mul $t1, $t0, 4

# Initialize remaining capacity
l.s $f4, float_one
sub.s $f4, $f4, $f5
la $t2, bins
add $t2, $t2, $t1
s.s $f4, 0($t2)

# Initialize item count
la $t3, bin_counts
add $t3, $t3, $t1
li $t4, 1
sw $t4, 0($t3)

# Store first item
mul $t5, $t0, 100 # Row offset
la $t6, bins_items
add $t5, $t6, $t5
s.s $f5, 0($t5)

# Increment total bin count
addi $t0, $t0, 1
sw $t0, bins_count

next_item_ff:
addi $t9, $t9, 1
j process_item

end_ff:
jr $ra

#-----------------------------------------------------------
# Procedure to populate All_item_inAllBins with items and separators
allPrintingItems:
la $t0, All_item_inAllBins # Destination pointer
lw $t1, bins_count # Number of bins
li $t2, 0 # Current bin index
la $t3, bin_counts # Pointer to bin_counts array
la $t4, bins_items # Pointer to bins_items 2D array
l.s $f6, float_half # Load 0.5 into $f6

loop_bins:
beq $t2, $t1, end_loop_bins # Exit loop if all bins processed
lw $t5, 0($t3) # Item count for current bin
li $t6, 0 # Item index

loop_items2:
beq $t6, $t5, end_loop_items # Exit loop if all items processed
# Calculate item address: bins_items + (bin_index * 100) + (item_index *4)
mul $t7, $t2, 100 # Bin offset (each bin is 100 bytes)
sll $t8, $t6, 2 # Item offset (each item is 4 bytes)
add $t7, $t7, $t8 # Total offset
add $t7, $t4, $t7 # Address of the item in bins_items
l.s $f4, 0($t7) # Load the item value
s.s $f4, 0($t0) # Store in All_item_inAllBins
addi $t0, $t0, 4 # Advance destination pointer
addi $t6, $t6, 1 # Next item
j loop_items2

end_loop_items:
# Add 0.5 separator after the bin's items
s.s $f6, 0($t0)
addi $t0, $t0, 4
# Move to next bin
addi $t2, $t2, 1
addi $t3, $t3, 4
j loop_bins

end_loop_bins:
# Calculate and store the total number of elements in All_item_inAllBins
la $t9, All_item_inAllBins
sub $t9, $t0, $t9 # Total bytes used
srl $t9, $t9, 2 # Divide by 4 to get element count
sw $t9, all_items_count
jr $ra


#........................................................................
# ????? ??????? ??? ?????
write_to_file:
# ??? ????? ???????
li $v0, 13
la $a0, output_file
li $a1, 1
syscall
move $s0, $v0 # ??? ???? ????? ?? $s0

# ????? ??? "minimum number of required bins: "
la $a0, min_bins_label
jal strlen
move $a2, $v0
li $v0, 15
move $a0, $s0
la $a1, min_bins_label
syscall

# ????? bins_count ??? ????? ????????
lw $t0, bins_count
la $a0, buffer1
move $a1, $t0
jal int_to_str

la $a0, buffer1
jal strlen
move $a2, $v0
li $v0, 15
move $a0, $s0
la $a1, buffer1
syscall

# ????? ??? ???? ??? ?????
li $v0, 15
move $a0, $s0
la $a1, newline
li $a2, 1
syscall

# ????? ??? "Bins contents:"
la $a0, bins_contents_label
jal strlen
move $a2, $v0
li $v0, 15
move $a0, $s0
la $a1, bins_contents_label
syscall

# ????? ???? ???????? ?????? ???????
li $s4, 1 # ???? ???????? ???? ?? 1
li $s5, 1 # ????? ?????? ????? ???????

# ????? ????? ???????? ???? ???????
la $s1, All_item_inAllBins
lw $s2, all_items_count
li $s3, 0 # ?????? ??????

loop_items1:
# ?????? ??? ??? ??? ??? ????? ????? ???????
beq $s5, $zero, after_label
# ????? "Bin "
la $a0, bin_label
jal strlen
move $a2, $v0
li $v0, 15
move $a0, $s0
la $a1, bin_label
syscall

# ????? ??? ???????
la $a0, buffer1 # <-- Corrected line: use 'la' instead of 'move'
move $a1, $s4
jal int_to_str

la $a0, buffer1
jal strlen
move $a2, $v0
li $v0, 15
move $a0, $s0
la $a1, buffer1
syscall

# ????? ": "
li $v0, 15
move $a0, $s0
la $a1, colon_space
li $a2, 2
syscall

# ????? ???? ???????? ?????? ????? ???????
addi $s4, $s4, 1
li $s5, 0

after_label:
bge $s3, $s2, end_loop # ?????? ?????? ??? ??? ?????? ???? ???????

# ???? ????? ?????? ??????
sll $t4, $s3, 2
add $t4, $s1, $t4
l.s $f0, 0($t4)

# ?????? ??? ??? ?????? 0.5 (???? ??? ????????)
l.s $f6, five
c.eq.s $f0, $f6
bc1t handle_separator

# ????? ?????? ??? ?????
l.s $f1, thousand
l.s $f2, half
mul.s $f0, $f0, $f1
add.s $f0, $f0, $f2
cvt.w.s $f0, $f0
mfc1 $t0, $f0

# ????? ????? ?????? ??? ?????
la $a0, buffer1
move $a1, $t0
jal int_to_str

# ????? ??????? ?????? ??????? ???????
la $t1, buffer1
la $t2, buffer2
jal strlen
move $t3, $v0

li $t7, 4
sub $t7, $t7, $t3 # ??? ??????? ????????

# ????? ?????? ?????? ?????? ???????
move $t5, $t3
shift_loop:
beqz $t5, end_shift
addi $t6, $t5, -1
addu $t8, $t1, $t6
lb $t9, 0($t8)
addu $t6, $t6, $t7
addu $t8, $t1, $t6
sb $t9, 0($t8)
addi $t5, $t5, -1
j shift_loop
end_shift:

# ????? ??????? ?? ???????
li $t5, 0
fill_zeros:
beq $t5, $t7, end_fill
addu $t8, $t1, $t5
li $t9, '0'
sb $t9, 0($t8)
addi $t5, $t5, 1
j fill_zeros
end_fill:

# ????? ?????? ?????? ???????
add $t3, $t3, $t7
addu $t8, $t1, $t3
sb $zero, 0($t8)

lb $t4, 0($t1)
sb $t4, 0($t2)
li $t4, '.'
sb $t4, 1($t2)

# ??? ??????? ????????
li $t5, 1
li $t6, 2
copy_loop:
bge $t5, $t3, end_copy
addu $t9, $t1, $t5
lb $t8, 0($t9)
addu $t7, $t2, $t6
sb $t8, 0($t7)
addi $t5, $t5, 1
addi $t6, $t6, 1
j copy_loop
end_copy:
addu $t9, $t2, $t6
sb $zero, 0($t9)

# ????? ??????? ??? ?????
la $a0, buffer2
jal strlen
move $a2, $v0

li $v0, 15
move $a0, $s0
la $a1, buffer2
syscall

# ????? ????? ??? ??????
li $v0, 15
move $a0, $s0
la $a1, space
li $a2, 1
syscall

j next_item2

# ???? handle_separator:
handle_separator:
# ????? ??? ???? ??? ?????? ???? 0.5
li $v0, 15
move $a0, $s0
la $a1, newline
li $a2, 1
syscall

# ????? ??? ???????? ????????
lw $t0, bins_count # <-- ????? ??? ?????
bgt $s4, $t0, skip_label # <-- ??? ????? ????? ???????? ?? ??? ??????

# ????? ????? ?????? ????? ??????? ??????
li $s5, 1

skip_label: # <-- ????? ????? ????? ???????
j next_item2

next_item2:
addi $s3, $s3, 1
j loop_items1

end_loop:
# ????? ?????
li $v0, 16
move $a0, $s0
syscall

# ????? ????????
j Menu
# ==========================================
# ????? ????? ?????? ??? ?? (int_to_str)
int_to_str:
move $t0, $a0 # ??????? ?????
move $t1, $a1 # ????? ??????
li $t3, 10 # ?????? ??? 10

beqz $t1, zero_case # ???? ?????

convert_loop:
divu $t1, $t3 # ?????? ??? 10
mfhi $t4 # ??????
mflo $t1 # ??????
addi $t4, $t4, '0' # ????? ??? ???
sb $t4, 0($t0) # ????? ?????
addi $t0, $t0, 1 # ????? ??????
bnez $t1, convert_loop # ????? ??? ?? ???? ?????

sb $zero, 0($t0) # ????? ???????

# ??? ???????
move $t5, $a0 # ????? ????
addi $t0, $t0, -1 # ????? ????

reverse_loop:
bge $t5, $t0, done
lb $t6, 0($t5)
lb $t7, 0($t0)
sb $t7, 0($t5)
sb $t6, 0($t0)
addi $t5, $t5, 1
addi $t0, $t0, -1
j reverse_loop

zero_case:
li $t4, '0' # ???? ?????
sb $t4, 0($t0)
sb $zero, 1($t0)

done:
jr $ra

# ==========================================
# ???? ??? ??????? (strlen)
strlen:
li $v0, 0 # ???? ?????

strlen_loop:
lb $t0, 0($a0) # ????? ?????
beqz $t0, strlen_end # ??? ??? ????? ???????
addi $a0, $a0, 1 # ????? ??????
addi $v0, $v0, 1 # ????? ??????
j strlen_loop

strlen_end:
jr $ra


exit_program:
li ,$v0,10
syscall

empty:
la $t0, bins 
li $t1, 0 
li $t2, 400 

clear_loop:
beqz $t2, done_empty 
sb $t1, 0($t0) 
addi $t0, $t0, 1 
subi $t2, $t2, 1 
j clear_loop 

done_empty:
jr $ra

empty2:
la $t0, binItemCounts 
li $t1, 0 
li $t2, 400 

clear_loop2:
beqz $t2, done_empty2 
sb $t1, 0($t0) 
addi $t0, $t0, 1 
subi $t2, $t2, 1 
j clear_loop2 

done_empty2:
jr $ra

empty3:
la $t0, binItems 
li $t1, 0 
li $t2, 400 

clear_loop3:
beqz $t2, done_empty3 
sb $t1, 0($t0) 
addi $t0, $t0, 1 
subi $t2, $t2, 1 
j clear_loop2 

done_empty3:
jr $ra
