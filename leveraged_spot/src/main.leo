// The 'leveraged_spot' program.
program leveraged_spot.aleo {
    transition main(public a: u32, b: u32) -> u32 {
        let c: u32 = a + b;
        return c;
    }
}
