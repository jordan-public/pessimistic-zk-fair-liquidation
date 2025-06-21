import token_registry.aleo;

// The 'leveraged_spot' program.
program leveraged_spot.aleo {
    const COLLATERAL_TOKEN_ID: field = 4086179070172029689989191504251673329323324697790262897954312563933915289279field;

    struct TimeSequence {
        start: u32,
        length: u32, // 0 means a single tick, 1 or more means a number of blocks
    }

    record Voucher {
        owner: address,
        amount: u128, // The amount of the token being bought.
        price: u128, // The price at which the token is bought.
        collateral_amount: u128, // The amount of collateral used for the purchase.
        block_no: u32, // The block number when the voucher was created.
    }

    transition time_sequence_key(
        start: u32,
        length: u32,
    ) -> field {
        let sequence: TimeSequence = TimeSequence { start, length };
        return BHP256::hash_to_field(sequence);
    }

    mapping low_watermarks: field => u128; // time_sequence_key => price low watermark

    async transition record_low_watermark(price: u128, block_no: u32) -> Future {
        return finalize_record_low_watermark(price, block_no);
    }
    async function finalize_record_low_watermark(price: u128, block_no: u32) {
        let length: u32 = 0u32;
        for i: u8 in 0u8..4u8 { // 0, 1, 2 for sequences of 0, 1, 10, 100 blocks
            let start: u32 = length == 0 ? block_no : block_no % length;
            // Calculate the key for the time sequence.
            let sequence: TimeSequence = TimeSequence { start, length };
            let key: field = BHP256::hash_to_field(sequence);
            // Get the current low watermark for this key.
            let current_low: u128 = Mapping::get_or_use(low_watermarks, key, price);
            // If the current low is zero or the new price is lower, update it.
            if (price < current_low) {
                Mapping::set(low_watermarks, key, price);
            }
        }
    }

    async transition buy(amount: u128, price: u128, collateral: token_registry.aleo/Token, collateral_amount: u128, block_no: u32) -> (token_registry.aleo/Token, Voucher, Future) {
        // Burn the collateral pessimistically
        let (change, fc): (token_registry.aleo/Token, Future) = token_registry.aleo/burn_private(collateral, collateral_amount);
        let voucher: Voucher = Voucher {
            owner: self.signer,
            amount,
            price,
            collateral_amount,
            block_no,
        };
        return (change, voucher, finalize_buy(price, block_no, fc));
    }
    async function finalize_buy(price: u128, block_no: u32, fc: Future) {
        assert(block.height == block_no);
        fc.await();

        // Record the low watermark for the current block.
        let length: u32 = 0u32;
        for i: u8 in 0u8..4u8 { // 0, 1, 2 for sequences of 0, 1, 10, 100 blocks
            let start: u32 = length == 0 ? block_no : block_no % length;
            // Calculate the key for the time sequence.
            let sequence: TimeSequence = TimeSequence { start, length };
            let key: field = BHP256::hash_to_field(sequence);
            // Get the current low watermark for this key.
            let current_low: u128 = Mapping::get_or_use(low_watermarks, key, price);
            // If the current low is zero or the new price is lower, update it.
            if (price < current_low) {
                Mapping::set(low_watermarks, key, price);
            }
        }

    }

    transition main(public a: u32, b: u32) -> u32 {
        let c: u32 = a + b;
        return c;
    }
}
