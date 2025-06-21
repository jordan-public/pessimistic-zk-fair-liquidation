# Pessimistic ZK Fair Leverage

## Abstract

Leveraged trading on-chain is challenging because everyone’s positions and stop-loss levels are publicly visible, leaving traders exposed to front-running, MEV, and flash-loan attacks that can unfairly force liquidations.

To eliminate this attack vector, we’ve developed a novel zero-knowledge approach that keeps each position’s liquidation thresholds and stop orders completely private. Instead of waiting for an attacker to trigger a forced sale, our system ***assumes every position is already liquidated*** and shifts the burden of proof onto the trader: they must supply a ZK proof that, under no possible market scenario, their position could have been liquidated. Only once that proof verifies do they recover their funds.

This inversion—“liquidate by default, prove otherwise”—ensures that no adversary can ever discover or manipulate another trader’s liquidation point, making on-chain leverage both safe and fair.

## Introduction

Let's not make a mistake: ***delinquent trading positions should be liquidated***.

### What this is and what it's not

This is:

- a market Position Management solution for Leveraged Spot and Leveraged Perpetual Futures (Perps) protocols,
- a marketplace for leveraged trading and fair liquidations using our novel Pessimistic ZK technique,
- NOT attempting order privacy. Such feature can be combined into this project from techniques already available in the Awesome Aleo collection,
- A marketplace that can be combined with any Order Book. Both Makers and Takers can take advantage of the liquidation fairness achieved,
- NOT a tool to evade liquidation of truly delinquent positions,
- a tool to avoid positions being liquidated by market manipulations.

### Leveraged Spot Trading - anatomy



![spotandlev](../images/spotandlev.png)

### Leveraged Perpetual Futures (Perps) - anatomy

Futures Contracts without leverage are not practical. A farmer would use Futures Contracts to hedge against crops price fluctuations. Yet they do not want or have the funds to cover the entire crops proceeds in advance. Instead
they leverage to commensurate the expected proceeds difference due to crops
price fluctuation.

Perpetual Futures (Perps) are simply never-expiring rollovers of frequently expiring Futures Contracts. Upon expiration and rollover to a newer contract
the difference between the new and the old contract (which could be negative)
is paid by the holder to the issuer in form of a "funding rate". The funding rate also reflects the difference between the Perp and the Spot prices.

Our Pessimistic ZK Fair Leverage Position Management technique could be implemented in conjunction with a Perp Order Book marketplace, and it would
manage the liquidation of the leveraged positions. However, to avoid dealing
with Funding Rates and lifetime management of the Perp contracts, we will
stay with leveraged spot trading marketplace and leave the Perp implementation
for the future.

## Solution

### Why Pessimistic

- Avoid position health calculation by 3rd party (FHE or MPC solution too expensive).
- Avoid active participation / keepers.

## Implementation

### Trade History Record

![timeseriesstore](timeseriesstore.png)

### Position funding

### Proof of non-delinquency

## Future Work
