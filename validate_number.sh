#!/bin/bash

# ==============================================================================
# Phone Number Validator for Phone_data_base
#
# Author: Michael-dev-tech
# Repository: https://github.com/Michael-dev-tech/Phone_data_base
# Description: This script reads 'phone_data.txt' and validates that each
#              phone number contains a correct number of digits.
# ==============================================================================

# --- Configuration ---
DATA_FILE="phone_data.txt"
MIN_DIGITS=8
MAX_DIGITS=15

# --- Colors for Output ---
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_RESET='\033[0m'

# --- Script Logic ---

# 1. Check if the data file exists
if [ ! -f "$DATA_FILE" ]; then
    echo -e "${C_RED}Error: Data file '$DATA_FILE' not found! Make sure it's in the same directory.${C_RESET}"
    exit 1
fi

echo "🔍 Starting validation of phone numbers in '$DATA_FILE'..."
echo "Rule: Phone numbers must contain between $MIN_DIGITS and $MAX_DIGITS digits."
echo "------------------------------------------------------------------"

# Initialize counters
line_number=0
error_count=0

# 2. Read the file line by line
while IFS= read -r line; do
    ((line_number++))

    # Skip empty lines or lines without the "Phone:" keyword
    if [[ -z "$line" || ! "$line" == *"Phone:"* ]]; then
        continue
    fi

    # 3. Extract the number part of the string
    # Uses 'sed' to get everything after "Phone: "
    phone_string=$(echo "$line" | sed 's/.*Phone: //')

    # 4. Clean the string to keep only digits (0-9)
    # The 'tr' command deletes any character that is NOT a digit
    phone_digits=$(echo "$phone_string" | tr -cd '0-9')

    # 5. Count the number of digits
    digit_count=${#phone_digits}

    # 6. Check if the count is outside the valid range
    if [ "$digit_count" -lt "$MIN_DIGITS" ] || [ "$digit_count" -gt "$MAX_DIGITS" ]; then
        ((error_count++))
        echo -e "${C_YELLOW}ALERT: Invalid format found on line ${line_number}.${C_RESET}"
        echo "  -> Reason: Found ${digit_count} digits, but expected between ${MIN_DIGITS}-${MAX_DIGITS}."
        echo "  -> Content: \"$line\""
        echo "" # Add a blank line for readability
    fi
done < "$DATA_FILE"

# 7. Print a final summary
echo "------------------------------------------------------------------"
if [ "$error_count" -eq 0 ]; then
    echo -e "${C_GREEN}✅ Validation complete. All phone numbers are formatted correctly!${C_RESET}"
else
    echo -e "${C_RED}❌ Validation complete. Found ${error_count} numbers with formatting errors.${C_RESET}"
fi
