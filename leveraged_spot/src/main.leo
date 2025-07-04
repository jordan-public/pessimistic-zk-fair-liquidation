import token_registry.aleo;

// The 'leveraged_spot' program.
program leveraged_spot.aleo {
    const COLLATERAL_TOKEN_ID: field = 4086179070172029689989191504251673329323324697790262897954312563933915289279field;
    const DECIMALS_FACTOR: u128 = 1_000_000u128; // 6 decimals
    const MAX_PROOF_LENGTH: u8 = 2u8; // Maximum number of sequences - 2 for testing purposes; in production this should be 32
    
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

    mapping spot_price: u8 => u128; // 0 => spot_price

    async transition initialize() -> Future {
        let name: u128 = 318453955671054116610412u128; // "Collateral" ascii encoded
        let symbol: u128 = 1129270348u128; // "COLL" ascii encoded
        let decimals: u8 = 6u8;
        let max_supply: u128 = 10_000_000_000_000_000u128;
        let external_authorization_required: bool = false;
        let external_authorization_party: address = self.address;

        let f1: Future = token_registry.aleo/register_token(
            COLLATERAL_TOKEN_ID,
            name,
            symbol,
            decimals,
            max_supply,
            external_authorization_required,
            external_authorization_party
        );

        // Distribute supply intended for testing.
        let supply: u128 = max_supply / 10u128; // 10% of the total supply is minted for testing.
        let (payout, f2) : (token_registry.aleo/Token, Future) = token_registry.aleo/mint_private(
            COLLATERAL_TOKEN_ID,
            self.signer,
            supply,
            false,
            0u32
        );

        return finalize_initialize(f1, f2);
    }
    async function finalize_initialize(f1: Future, f2: Future) {
        f1.await();
        f2.await();

        // Fill mock sequences for testing purposes.
        let sequence: TimeSequence = TimeSequence { start: 9u32, length: 1u32 };
        let key: field = BHP256::hash_to_field(sequence);
        Mapping::set(low_watermarks, key, 100_000_000u128); // Set a mock low watermark for the sequence starting at block 10 with length 1
        sequence = TimeSequence { start: 10u32, length: 10u32 };
        key = BHP256::hash_to_field(sequence);
        Mapping::set(low_watermarks, key, 200_000_000u128); // Set a mock low watermark for the sequence starting at block 20 with length 1
        // A liqudation level of 90_000_000 (90 full tokens) should pass for the sequence starting at block 10 with length 1
     }

    async transition spot_price_oracle(price: u128, block_no: u32) -> Future {
        // This transition is used by the oracle to record the spot price.
        // It should be called by an oracle or a trusted entity.
        return finalize_spot_price_oracle(price, block_no);
    }
    async function finalize_spot_price_oracle(price: u128, block_no: u32) {
        // assert(block.height == block_no); commented out for testing purposes
        Mapping::set(spot_price, 0u8, price);
        // Record the low watermark for the current block.
        let length: u32 = 0u32;
        for i: u8 in 0u8..4u8 { // 0, 1, 2 for sequences of 0, 1, 10, 100 blocks
            let start: u32 = length == 0u32 ? block_no : block_no % length;
            // Calculate the key for the time sequence.
            let sequence: TimeSequence = TimeSequence { start, length };
            let key: field = BHP256::hash_to_field(sequence);
            // Get the current low watermark for this key.
            let current_low: u128 = Mapping::get_or_use(low_watermarks, key, price);
            // If the current low is zero or the new price is lower, update it.
            if (price < current_low) {
                Mapping::set(low_watermarks, key, price);
            }
            length = length == 0u32 ? 1u32 : length * 10u32; // Increase the length for the next iteration
        }
    }

    // Checking for the caller is intentionlly omitted for testing purposes.
    // In production, you should check that the caller is an oracle or buyer/seller.
    async transition record_low_watermark(price: u128, block_no: u32) -> Future {
        return finalize_record_low_watermark(price, block_no);
    }
    async function finalize_record_low_watermark(price: u128, block_no: u32) {
        let length: u32 = 0u32;
        for i: u8 in 0u8..4u8 { // 0, 1, 2 for sequences of 0, 1, 10, 100 blocks
            let start: u32 = length == 0u32 ? block_no : block_no % length;
            // Calculate the key for the time sequence.
            let sequence: TimeSequence = TimeSequence { start, length };
            let key: field = BHP256::hash_to_field(sequence);
            // Get the current low watermark for this key.
            let current_low: u128 = Mapping::get_or_use(low_watermarks, key, price);
            // If the current low is zero or the new price is lower, update it.
            if (price < current_low) {
                Mapping::set(low_watermarks, key, price);
            }
            length = length == 0u32 ? 1u32 : length * 10u32; // Increase the length for the next iteration
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
        // assert(block.height == block_no); commented out for testing purposes
        // price >= spot_price[0]; commented out for testing purposes
        fc.await();

        // !!! Block below commented out for testing purposes. We are not recording the current tick for testing, so we can spoof the trade time/block!
        // // Record the low watermark for the current block.
        // let length: u32 = 0u32;
        // for i: u8 in 0u8..4u8 { // 0, 1, 2 for sequences of 0, 1, 10 blocks; in production this should be at least 7 (million blocks)
        //     let start: u32 = length == 0u32 ? block_no : block_no % length;
        //     // Calculate the key for the time sequence.
        //     let sequence: TimeSequence = TimeSequence { start, length };
        //     let key: field = BHP256::hash_to_field(sequence);
        //     // Get the current low watermark for this key.
        //     let current_low: u128 = Mapping::get_or_use(low_watermarks, key, price);
        //     // If the current low is zero or the new price is lower, update it.
        //     if (price < current_low) {
        //         Mapping::set(low_watermarks, key, price);
        //     }
        //     length = length == 0u32 ? 1u32 : length * 10u32; // Increase the length for the next iteration
        // }
    }

//    async transition sell(voucher: Voucher, price: u128, block_no: u32, proof_starts: [u32; 32], proof_lengths: [u32; 32]) -> (token_registry.aleo/Token, Future) {
    async transition sell(voucher: Voucher, price: u128, block_no: u32, proof_starts: [u32; 2], proof_lengths: [u32; 2]) -> (token_registry.aleo/Token, Future) {
        // Calculate the liquidation level
        let liquidation_level: u128 = (DECIMALS_FACTOR * voucher.collateral_amount) / voucher.amount >= voucher.price ? 0u128 : 
            voucher.price - ((DECIMALS_FACTOR * voucher.collateral_amount) / voucher.amount);
        assert(voucher.price >= liquidation_level);
        assert(price >= liquidation_level);
        for i: u8 in 0u8..MAX_PROOF_LENGTH-1u8 {
            if proof_starts[i] != 0u32 {
                // Check that the proof starts and lengths are valid
                assert(proof_starts[i]+proof_lengths[i] == proof_starts[i+1u8]);
            }
        }
        let (payout, f) : (token_registry.aleo/Token, Future) = token_registry.aleo/mint_private(
            COLLATERAL_TOKEN_ID,
            voucher.owner,
            voucher.amount + ((price - voucher.price) * voucher.amount) / DECIMALS_FACTOR,
            false,
            0u32
        );
        return (payout, finalize_sell(f, price, block_no, liquidation_level, proof_starts, proof_lengths));
    }
//    async function finalize_sell(f: Future, price: u128, block_no: u32, liquidation_level: u128, proof_starts: [u32; 32], proof_lengths: [u32; 32]) {
    async function finalize_sell(f: Future, price: u128, block_no: u32, liquidation_level: u128, proof_starts: [u32; 2], proof_lengths: [u32; 2]) {
        // assert(block.height == block_no); commented out for testing purposes
        // price >= spot_price[0]; commented out for testing purposes
        for i: u8 in 0u8..MAX_PROOF_LENGTH {
            if (proof_starts[i] != 0u32) {
                // Check against liquidation level against the price low watermarks
                let sequence: TimeSequence = TimeSequence { start: proof_starts[i], length: proof_lengths[i] };
                let key: field = BHP256::hash_to_field(sequence);
                assert(liquidation_level <= Mapping::get(low_watermarks, key));
            }
        }
        f.await();
    }
}
