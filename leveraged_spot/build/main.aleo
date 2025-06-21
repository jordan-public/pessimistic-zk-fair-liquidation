import credits.aleo;
import token_registry.aleo;
program leveraged_spot.aleo;

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

function main:
    input r0 as u32.public;
    input r1 as u32.private;
    add r0 r1 into r2;
    output r2 as u32.private;
