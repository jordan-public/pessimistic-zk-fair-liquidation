# ZK Fair Leverage

## Abstract

Leveraged trading is difficult to implement on-chain, as all participants' information is public, making them vulnerable to market manipulations. Such manipulations cause
leveraged positions to be unfairly liquidated, because the attacker can easily discover the liquidation price points and/or stop orders. They range from temporary positions to manipulate spot markets, MEV attacks and Flash Loan attacks.

To prevent such unfairness, we implemented a novel technique leveraging Zero Knowledge (ZK) technology, in which these liquidation points and/or stop orders stay private.
Having such information private makes the fair liquidation difficult. To solve this, our implementation pessimistically assumes that the position in question is a priory
liquidated. Then the burden of proof lays with the position holder to demonstrate that no liquidation could possibly occur and recover their funds. Such proof reliably
works due to ZK.

## Introduction

## Solution

## Implementation

## Future Work
