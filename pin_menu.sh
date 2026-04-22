#!/bin/bash

echo "=================================="
echo "           PIN MENU               "
echo "=================================="
echo "1. Generate PIN"
echo "2. Exit"
echo "=================================="
echo "Enter your choice (1 or 2): $CHOICE"
echo ""

# Function to generate 4-digit PIN
generate_pin() {
    shuf -i 1000-9999 -n 1
}

if [ "$CHOICE" = "1" ]; then
    PIN=$(generate_pin)
    echo "Generated 4-digit PIN: $PIN"

elif [ "$CHOICE" = "2" ]; then
    echo "Exiting..."

else
    echo "Invalid input. Please enter 1 or 2."
fi
