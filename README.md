# Pessimistic ZK Fair Leverage

## Abstract

Leveraged trading on-chain is challenging because everyone’s positions and stop-loss levels are publicly visible, leaving traders exposed to front-running, MEV, and flash-loan attacks that can unfairly force liquidations.

To eliminate this attack vector, we’ve developed a novel zero-knowledge approach that keeps each position’s liquidation thresholds and stop orders completely private. Instead of waiting for an attacker to trigger a forced sale, our system ***assumes every position is already liquidated*** and shifts the burden of proof onto the trader: they must supply a ZK proof that, under no possible market scenario, their position could have been liquidated. Only once that proof verifies do they recover their funds.

This inversion—“liquidate by default, prove otherwise”—ensures that no adversary can ever discover or manipulate another trader’s liquidation point, making on-chain leverage both safe and fair.

## Introduction

Let's not make a mistake: ***delinquent trading positions should be liquidated***.

### What this is and what it's not

This is:

- a marketplace for leveraged trading and fair liquidations using our novel Pessimistic ZK technique,
- NOT attempting order privacy. Such feature can be combined into this project from techniques already available in the Awesome Aleo collection,
- A marketplace that can be combined with any Order Book. Both Makers and Takers can take advantage of the liquidation fairness achieved,
- NOT a tool to evade liquidation of truly delinquent positions,
- a tool to avoid positions being liquidated by market manipulations.

## Leveraged Spot Trading

## Leveraged Perpetual Futures (Perps)

## Solution

## Implementation

## Future Work
