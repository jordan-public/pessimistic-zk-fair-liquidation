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

To achieve a liquidation level of 90.00 we should Buy at price of 100.00 and supply collateral that supports a loss of 10.00 at quantity of 10.00 (10_000_000u128), which is
a 100.00 (100_000_000u128) Collateral tokens.

Before we continue, let's discover the address of the caller:
```zsh
. ./.env
leo account import $PRIVATE_KEY
```
and get
```
  Private Key  APrivateKey1zkp8CZNn3yeCseEtxuVPbDCwSyhGW6yZKUYKfgXmcpoGPWH
     View Key  AViewKey1mSnpFFC8Mj4fXbK5YiWgZ3mjiV8CxA79bYNa8ymUpTrw
      Address  aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px
```

Let's discover the record owned by the caller:
```zsh
snarkos developer scan --network 1 --private-key $PRIVATE_KEY --endpoint $ENDPOINT --last 10
```
and get
```
[
  "{  owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px.private,  amount: 1000000000000000u128.private,  token_id: 4086179070172029689989191504251673329323324697790262897954312563933915289279field.private,  external_authorization_required: false.private,  authorized_until: 0u32.private,  _nonce: 2107208295950156637983696270872624494810300754073278544675795292499547565865group.public}"
]
```

To enter the above mentioned position we can use:
```zsh
./buy.sh 10_000_000u128 100_000_000u128 "{  owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px.private,  amount: 1000000000000000u128.private,  token_id: 4086179070172029689989191504251673329323324697790262897954312563933915289279field.private,  external_authorization_required: false.private,  authorized_until: 0u32.private,  _nonce: 2107208295950156637983696270872624494810300754073278544675795292499547565865group.public}" 100_000_000u128 9u32
```

BTW, the parameters are:
amount: u128, price: u128, collateral: token_registry.aleo/Token, collateral_amount: u128, block_no: u32

This should yield a Voucher record that we can use later when selling:
```zsh
snarkos developer scan --network 1 --private-key $PRIVATE_KEY --endpoint $ENDPOINT --last 10
```
and get
```
[
  "{  owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px.private,  amount: 999999900000000u128.private,  token_id: 4086179070172029689989191504251673329323324697790262897954312563933915289279field.private,  external_authorization_required: false.private,  authorized_until: 0u32.private,  _nonce: 1435481678981767755495000967389829673867951986581909743914879266875681954005group.public}",
  "{  owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px.private,  amount: 10000000u128.private,  price: 100000000u128.private,  collateral_amount: 100000000u128.private,  block_no: 9u32.private,  _nonce: 6274424817420633236995244422371240911312564129374341076526740748552102064097group.public}"
]
```

Instead of waiting for a long time, we have mocked up the price low watermarks in the ```initialize()``` call for testing purpose.
We can try to sell in the 20th block and obtain a successful proof. Let's sell at 110.00 in the 20th block (the verification against ```block.height``` is
commented out for testing purposes):
```zsh
./sell.sh "{  owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px.private,  amount: 10000000u128.private,  price: 100000000u128.private,  collateral_amount: 100000000u128.private,  block_no: 9u32.private,  _nonce: 6274424817420633236995244422371240911312564129374341076526740748552102064097group.public}" 110_000_000u128 20u32 "[9u32, 10u32]" "[1u32, 10u32]"
```
BTW, the parameters are: voucher: Voucher, price: u128, block_no: u32, proof_starts: [u32; 32], proof_lengths: [u32; 32]

After successful proof of non-liquidation the transaction completes and we can see the returned Collateral using:
```zsh
snarkos developer scan --network 1 --private-key $PRIVATE_KEY --endpoint $ENDPOINT --last 10
```
and get
```
[
  "{  owner: aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px.private,  amount: 110000000u128.private,  token_id: 4086179070172029689989191504251673329323324697790262897954312563933915289279field.private,  external_authorization_required: false.private,  authorized_until: 0u32.private,  _nonce: 6543577859012498918834172810594525447738388656059670988484030035194790288080group.public}"
]
```

This demonstrates the full operation. If we were to exit at the price of 80.00 instead of 110.00 the Sell call would fail as it would obviously fail to prove that there was no liquidation at price below 90.00.