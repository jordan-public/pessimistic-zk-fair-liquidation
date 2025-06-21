// The 'test_leveraged_spot' test program.
import leveraged_spot.aleo;
program test_leveraged_spot.aleo {
    @test
    script test_it() {
        let result: u32 = leveraged_spot.aleo/main(1u32, 2u32);
        assert_eq(result, 3u32);
    }

    @test
    @should_fail
    transition do_nothing() {
        let result: u32 = leveraged_spot.aleo/main(2u32, 3u32);
        assert_eq(result, 3u32);
    }
}
