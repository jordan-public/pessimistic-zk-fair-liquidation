# ZK Fair Leverage

## Abstract

Leveraged trading on-chain is challenging because everyone’s positions and stop-loss levels are publicly visible, leaving traders exposed to front-running, MEV, and flash-loan attacks that can unfairly force liquidations.

To eliminate this attack vector, we’ve developed a novel zero-knowledge approach that keeps each position’s liquidation thresholds and stop orders completely private. Instead of waiting for an attacker to trigger a forced sale, our system ***assumes every position is already liquidated*** and shifts the burden of proof onto the trader: they must supply a ZK proof that, under no possible market scenario, their position could have been liquidated. Only once that proof verifies do they recover their funds.

This inversion—“liquidate by default, prove otherwise”—ensures that no adversary can ever discover or manipulate another trader’s liquidation point, making on-chain leverage both safe and fair.

## Introduction

## Solution

## Implementation

## Future Work
