#!/bin/zsh
set -e
#set -x

. ./.env

# Help message
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Usage: $0 [--private-key <key>] <amount>u128 <price>u128 <collateral_token_record> <collateral_amount>u128 <block_no>u32"
    exit 0
fi

# Parse optional --private-key parameter
if [[ "$1" == "--private-key" ]]; then
    PRIVATE_KEY=$2
    shift 2
fi

# Parameter validation
if [[ $# -eq 0 ]] || [[ $# -gt 7 ]]; then
    echo "Error: Invalid number of parameters"
    echo "Use --help for usage information"
    exit 1
fi

echo "Payment: $1"

leo execute --private-key $PRIVATE_KEY --yes --local --broadcast\
    buy $1 $2 $3 $4 $5