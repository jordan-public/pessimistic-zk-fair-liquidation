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

function time_sequence_key:
    input r0 as u32.private;
    input r1 as u32.private;
    cast r0 r1 into r2 as TimeSequence;
    hash.bhp256 r2 into r3 as field;
    output r3 as field.private;

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
    branch.eq r8 false to end_then_0_0;
    set r0 into low_watermarks[r6];
    branch.eq true true to end_otherwise_0_1;
    position end_then_0_0;
    position end_otherwise_0_1;
    is.eq 0u32 0u32 into r9;
    rem r1 0u32 into r10;
    ternary r9 r1 r10 into r11;
    cast r11 0u32 into r12 as TimeSequence;
    hash.bhp256 r12 into r13 as field;
    get.or_use low_watermarks[r13] r0 into r14;
    lt r0 r14 into r15;
    branch.eq r15 false to end_then_0_2;
    set r0 into low_watermarks[r13];
    branch.eq true true to end_otherwise_0_3;
    position end_then_0_2;
    position end_otherwise_0_3;
    is.eq 0u32 0u32 into r16;
    rem r1 0u32 into r17;
    ternary r16 r1 r17 into r18;
    cast r18 0u32 into r19 as TimeSequence;
    hash.bhp256 r19 into r20 as field;
    get.or_use low_watermarks[r20] r0 into r21;
    lt r0 r21 into r22;
    branch.eq r22 false to end_then_0_4;
    set r0 into low_watermarks[r20];
    branch.eq true true to end_otherwise_0_5;
    position end_then_0_4;
    position end_otherwise_0_5;
    is.eq 0u32 0u32 into r23;
    rem r1 0u32 into r24;
    ternary r23 r1 r24 into r25;
    cast r25 0u32 into r26 as TimeSequence;
    hash.bhp256 r26 into r27 as field;
    get.or_use low_watermarks[r27] r0 into r28;
    lt r0 r28 into r29;
    branch.eq r29 false to end_then_0_6;
    set r0 into low_watermarks[r27];
    branch.eq true true to end_otherwise_0_7;
    position end_then_0_6;
    position end_otherwise_0_7;

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
    is.eq block.height r1 into r3;
    assert.eq r3 true;
    await r2;
    is.eq 0u32 0u32 into r4;
    rem r1 0u32 into r5;
    ternary r4 r1 r5 into r6;
    cast r6 0u32 into r7 as TimeSequence;
    hash.bhp256 r7 into r8 as field;
    get.or_use low_watermarks[r8] r0 into r9;
    lt r0 r9 into r10;
    branch.eq r10 false to end_then_0_8;
    set r0 into low_watermarks[r8];
    branch.eq true true to end_otherwise_0_9;
    position end_then_0_8;
    position end_otherwise_0_9;
    is.eq 0u32 0u32 into r11;
    rem r1 0u32 into r12;
    ternary r11 r1 r12 into r13;
    cast r13 0u32 into r14 as TimeSequence;
    hash.bhp256 r14 into r15 as field;
    get.or_use low_watermarks[r15] r0 into r16;
    lt r0 r16 into r17;
    branch.eq r17 false to end_then_0_10;
    set r0 into low_watermarks[r15];
    branch.eq true true to end_otherwise_0_11;
    position end_then_0_10;
    position end_otherwise_0_11;
    is.eq 0u32 0u32 into r18;
    rem r1 0u32 into r19;
    ternary r18 r1 r19 into r20;
    cast r20 0u32 into r21 as TimeSequence;
    hash.bhp256 r21 into r22 as field;
    get.or_use low_watermarks[r22] r0 into r23;
    lt r0 r23 into r24;
    branch.eq r24 false to end_then_0_12;
    set r0 into low_watermarks[r22];
    branch.eq true true to end_otherwise_0_13;
    position end_then_0_12;
    position end_otherwise_0_13;
    is.eq 0u32 0u32 into r25;
    rem r1 0u32 into r26;
    ternary r25 r1 r26 into r27;
    cast r27 0u32 into r28 as TimeSequence;
    hash.bhp256 r28 into r29 as field;
    get.or_use low_watermarks[r29] r0 into r30;
    lt r0 r30 into r31;
    branch.eq r31 false to end_then_0_14;
    set r0 into low_watermarks[r29];
    branch.eq true true to end_otherwise_0_15;
    position end_then_0_14;
    position end_otherwise_0_15;

function main:
    input r0 as u32.public;
    input r1 as u32.private;
    add r0 r1 into r2;
    output r2 as u32.private;
