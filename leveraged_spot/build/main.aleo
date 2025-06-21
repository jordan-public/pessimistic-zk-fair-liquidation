import credits.aleo;
import token_registry.aleo;
program leveraged_spot.aleo;

record Voucher:
    owner as address.private;
    amount as u128.private;
    price as u128.private;
    collateral_amount as u128.private;
    block_no as u32.private;

struct TokenMetadata:
    token_id as field;
    name as u128;
    symbol as u128;
    decimals as u8;
    supply as u128;
    max_supply as u128;
    admin as address;
    external_authorization_required as boolean;
    external_authorization_party as address;

struct TokenOwner:
    account as address;
    token_id as field;

struct TimeSequence:
    start as u32;
    length as u32;

mapping low_watermarks:
    key as field.public;
    value as u128.public;

mapping spot_price:
    key as u8.public;
    value as u128.public;

function initialize:
    call token_registry.aleo/register_token 4086179070172029689989191504251673329323324697790262897954312563933915289279field 318453955671054116610412u128 1129270348u128 6u8 10000000000000000u128 false leveraged_spot.aleo into r0;
    div 10000000000000000u128 10u128 into r1;
    call token_registry.aleo/mint_private 4086179070172029689989191504251673329323324697790262897954312563933915289279field self.signer r1 false 0u32 into r2 r3;
    async initialize r0 r3 into r4;
    output r4 as leveraged_spot.aleo/initialize.future;

finalize initialize:
    input r0 as token_registry.aleo/register_token.future;
    input r1 as token_registry.aleo/mint_private.future;
    await r0;
    await r1;
    cast 9u32 1u32 into r2 as TimeSequence;
    hash.bhp256 r2 into r3 as field;
    set 100000000u128 into low_watermarks[r3];
    cast 10u32 10u32 into r4 as TimeSequence;
    hash.bhp256 r4 into r5 as field;
    set 200000000u128 into low_watermarks[r5];

function time_sequence_key:
    input r0 as u32.private;
    input r1 as u32.private;
    cast r0 r1 into r2 as TimeSequence;
    hash.bhp256 r2 into r3 as field;
    output r3 as field.private;

function spot_price_oracle:
    input r0 as u128.private;
    input r1 as u32.private;
    async spot_price_oracle r0 r1 into r2;
    output r2 as leveraged_spot.aleo/spot_price_oracle.future;

finalize spot_price_oracle:
    input r0 as u128.public;
    input r1 as u32.public;
    set r0 into spot_price[0u8];
    is.eq 0u32 0u32 into r2;
    rem r1 0u32 into r3;
    ternary r2 r1 r3 into r4;
    cast r4 0u32 into r5 as TimeSequence;
    hash.bhp256 r5 into r6 as field;
    get.or_use low_watermarks[r6] r0 into r7;
    lt r0 r7 into r8;
    branch.eq r8 false to end_then_0_0;
    set r0 into low_watermarks[r6];
    branch.eq true true to end_otherwise_0_1;
    position end_then_0_0;
    position end_otherwise_0_1;
    mul 0u32 10u32 into r9;
    is.eq r9 0u32 into r10;
    rem r1 r9 into r11;
    ternary r10 r1 r11 into r12;
    cast r12 r9 into r13 as TimeSequence;
    hash.bhp256 r13 into r14 as field;
    get.or_use low_watermarks[r14] r0 into r15;
    lt r0 r15 into r16;
    branch.eq r16 false to end_then_0_2;
    set r0 into low_watermarks[r14];
    branch.eq true true to end_otherwise_0_3;
    position end_then_0_2;
    position end_otherwise_0_3;
    mul r9 10u32 into r17;
    is.eq r17 0u32 into r18;
    rem r1 r17 into r19;
    ternary r18 r1 r19 into r20;
    cast r20 r17 into r21 as TimeSequence;
    hash.bhp256 r21 into r22 as field;
    get.or_use low_watermarks[r22] r0 into r23;
    lt r0 r23 into r24;
    branch.eq r24 false to end_then_0_4;
    set r0 into low_watermarks[r22];
    branch.eq true true to end_otherwise_0_5;
    position end_then_0_4;
    position end_otherwise_0_5;
    mul r17 10u32 into r25;
    is.eq r25 0u32 into r26;
    rem r1 r25 into r27;
    ternary r26 r1 r27 into r28;
    cast r28 r25 into r29 as TimeSequence;
    hash.bhp256 r29 into r30 as field;
    get.or_use low_watermarks[r30] r0 into r31;
    lt r0 r31 into r32;
    branch.eq r32 false to end_then_0_6;
    set r0 into low_watermarks[r30];
    branch.eq true true to end_otherwise_0_7;
    position end_then_0_6;
    position end_otherwise_0_7;
    mul r25 10u32 into r33;

function record_low_watermark:
    input r0 as u128.private;
    input r1 as u32.private;
    async record_low_watermark r0 r1 into r2;
    output r2 as leveraged_spot.aleo/record_low_watermark.future;

finalize record_low_watermark:
    input r0 as u128.public;
    input r1 as u32.public;
    is.eq 0u32 0u32 into r2;
    rem r1 0u32 into r3;
    ternary r2 r1 r3 into r4;
    cast r4 0u32 into r5 as TimeSequence;
    hash.bhp256 r5 into r6 as field;
    get.or_use low_watermarks[r6] r0 into r7;
    lt r0 r7 into r8;
    branch.eq r8 false to end_then_0_8;
    set r0 into low_watermarks[r6];
    branch.eq true true to end_otherwise_0_9;
    position end_then_0_8;
    position end_otherwise_0_9;
    is.eq 0u32 0u32 into r9;
    rem r1 0u32 into r10;
    ternary r9 r1 r10 into r11;
    cast r11 0u32 into r12 as TimeSequence;
    hash.bhp256 r12 into r13 as field;
    get.or_use low_watermarks[r13] r0 into r14;
    lt r0 r14 into r15;
    branch.eq r15 false to end_then_0_10;
    set r0 into low_watermarks[r13];
    branch.eq true true to end_otherwise_0_11;
    position end_then_0_10;
    position end_otherwise_0_11;
    is.eq 0u32 0u32 into r16;
    rem r1 0u32 into r17;
    ternary r16 r1 r17 into r18;
    cast r18 0u32 into r19 as TimeSequence;
    hash.bhp256 r19 into r20 as field;
    get.or_use low_watermarks[r20] r0 into r21;
    lt r0 r21 into r22;
    branch.eq r22 false to end_then_0_12;
    set r0 into low_watermarks[r20];
    branch.eq true true to end_otherwise_0_13;
    position end_then_0_12;
    position end_otherwise_0_13;
    is.eq 0u32 0u32 into r23;
    rem r1 0u32 into r24;
    ternary r23 r1 r24 into r25;
    cast r25 0u32 into r26 as TimeSequence;
    hash.bhp256 r26 into r27 as field;
    get.or_use low_watermarks[r27] r0 into r28;
    lt r0 r28 into r29;
    branch.eq r29 false to end_then_0_14;
    set r0 into low_watermarks[r27];
    branch.eq true true to end_otherwise_0_15;
    position end_then_0_14;
    position end_otherwise_0_15;

function buy:
    input r0 as u128.private;
    input r1 as u128.private;
    input r2 as token_registry.aleo/Token.record;
    input r3 as u128.private;
    input r4 as u32.private;
    call token_registry.aleo/burn_private r2 r3 into r5 r6;
    cast self.signer r0 r1 r3 r4 into r7 as Voucher.record;
    async buy r1 r4 r6 into r8;
    output r5 as token_registry.aleo/Token.record;
    output r7 as Voucher.record;
    output r8 as leveraged_spot.aleo/buy.future;

finalize buy:
    input r0 as u128.public;
    input r1 as u32.public;
    input r2 as token_registry.aleo/burn_private.future;
    await r2;
    is.eq 0u32 0u32 into r3;
    rem r1 0u32 into r4;
    ternary r3 r1 r4 into r5;
    cast r5 0u32 into r6 as TimeSequence;
    hash.bhp256 r6 into r7 as field;
    get.or_use low_watermarks[r7] r0 into r8;
    lt r0 r8 into r9;
    branch.eq r9 false to end_then_0_16;
    set r0 into low_watermarks[r7];
    branch.eq true true to end_otherwise_0_17;
    position end_then_0_16;
    position end_otherwise_0_17;
    is.eq 0u32 0u32 into r10;
    rem r1 0u32 into r11;
    ternary r10 r1 r11 into r12;
    cast r12 0u32 into r13 as TimeSequence;
    hash.bhp256 r13 into r14 as field;
    get.or_use low_watermarks[r14] r0 into r15;
    lt r0 r15 into r16;
    branch.eq r16 false to end_then_0_18;
    set r0 into low_watermarks[r14];
    branch.eq true true to end_otherwise_0_19;
    position end_then_0_18;
    position end_otherwise_0_19;
    is.eq 0u32 0u32 into r17;
    rem r1 0u32 into r18;
    ternary r17 r1 r18 into r19;
    cast r19 0u32 into r20 as TimeSequence;
    hash.bhp256 r20 into r21 as field;
    get.or_use low_watermarks[r21] r0 into r22;
    lt r0 r22 into r23;
    branch.eq r23 false to end_then_0_20;
    set r0 into low_watermarks[r21];
    branch.eq true true to end_otherwise_0_21;
    position end_then_0_20;
    position end_otherwise_0_21;
    is.eq 0u32 0u32 into r24;
    rem r1 0u32 into r25;
    ternary r24 r1 r25 into r26;
    cast r26 0u32 into r27 as TimeSequence;
    hash.bhp256 r27 into r28 as field;
    get.or_use low_watermarks[r28] r0 into r29;
    lt r0 r29 into r30;
    branch.eq r30 false to end_then_0_22;
    set r0 into low_watermarks[r28];
    branch.eq true true to end_otherwise_0_23;
    position end_then_0_22;
    position end_otherwise_0_23;

function sell:
    input r0 as Voucher.record;
    input r1 as u128.private;
    input r2 as u32.private;
    input r3 as [u32; 32u32].private;
    input r4 as [u32; 32u32].private;
    mul 1000000u128 r0.collateral_amount into r5;
    div r5 r0.amount into r6;
    gte r6 r0.price into r7;
    mul 1000000u128 r0.collateral_amount into r8;
    div r8 r0.amount into r9;
    sub r0.price r9 into r10;
    ternary r7 0u128 r10 into r11;
    gte r0.price r11 into r12;
    assert.eq r12 true;
    gte r1 r11 into r13;
    assert.eq r13 true;
    is.neq r3[0u32] 0u32 into r14;
    add r3[0u32] r4[0u32] into r15;
    is.eq r15 r3[1u32] into r16;
    not r14 into r17;
    or r16 r17 into r18;
    assert.eq r18 true;
    sub r1 r0.price into r19;
    mul r19 r0.amount into r20;
    div r20 1000000u128 into r21;
    add r0.amount r21 into r22;
    call token_registry.aleo/mint_private 4086179070172029689989191504251673329323324697790262897954312563933915289279field r0.owner r22 false 0u32 into r23 r24;
    async sell r24 r1 r2 r11 r3 r4 into r25;
    output r23 as token_registry.aleo/Token.record;
    output r25 as leveraged_spot.aleo/sell.future;

finalize sell:
    input r0 as token_registry.aleo/mint_private.future;
    input r1 as u128.public;
    input r2 as u32.public;
    input r3 as u128.public;
    input r4 as [u32; 32u32].public;
    input r5 as [u32; 32u32].public;
    is.neq r4[0u32] 0u32 into r6;
    branch.eq r6 false to end_then_0_24;
    cast r4[0u32] r5[0u32] into r7 as TimeSequence;
    hash.bhp256 r7 into r8 as field;
    get low_watermarks[r8] into r9;
    lte r3 r9 into r10;
    assert.eq r10 true;
    branch.eq true true to end_otherwise_0_25;
    position end_then_0_24;
    position end_otherwise_0_25;
    is.neq r4[1u32] 0u32 into r11;
    branch.eq r11 false to end_then_0_26;
    cast r4[1u32] r5[1u32] into r12 as TimeSequence;
    hash.bhp256 r12 into r13 as field;
    get low_watermarks[r13] into r14;
    lte r3 r14 into r15;
    assert.eq r15 true;
    branch.eq true true to end_otherwise_0_27;
    position end_then_0_26;
    position end_otherwise_0_27;
    await r0;
