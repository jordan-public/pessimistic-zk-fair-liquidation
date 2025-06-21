# Demo

## Video

The video can be found [here](./video.mp4) and on [YouTube]().

## Demo testing

To start the Amareleo test node, from the root folder of the repo run:
```zsh
./run_node.sh
```
and keep the terminal running.

In another terminal, the programs can be installed from the ```leveraged_spot``` folder using:
```zsh
./install.sh
```

This not only installs the program, but also prepares it for testing as follows:
- Creates the Collateral token and mints sufficient amount to the caller.
- Populates 2 mock price low watermark sequences:
    - Block 9 for 1 block with price low watermark of 100.00.
    - Block 10 for 10 blocks with price low watermark of 200.00.
- This sequence should accommodate proving that a trade from block 9 to block 20 does not get liquidated if the liquidation price is 90.00. Note that the price of 90.00 is represented as 90_000_000u128 (6 decimals).
