#!/bin/zsh
set -e
#set -x

cd ..
. ./.env

# Help message
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    # echo "Usage: $0 [--private-key <key>] <voucher_record> <price>u128 <block_no>u32 <proof_starts: [u32; 32]> <proof_lengths: [u32; 32]>"
    echo "Usage: $0 [--private-key <key>] <voucher_record> <price>u128 <block_no>u32 <proof_starts: [u32; 2]> <proof_lengths: [u32; 2]>"
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
    sell $1 $2 $3 $4 $5