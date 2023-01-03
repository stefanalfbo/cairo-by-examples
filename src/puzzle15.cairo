struct Location {
    row: felt,
    col: felt,
}

// Cairo does not have a < operator. The reason is that in the Cairo
// machine the is-less-than operation is a complicated operation, therfore
// the algorithm below.
func verify_valid_location(loc: Location*) {
    // A statement of the form tempvar a = <expr>; allocates
    // one memory cell, names it a, and assigns it the value of <expr>.
    tempvar row = loc.row;
    // Check that row is in the range 0-3.
    assert row * (row - 1) * (row - 2) * (row - 3) = 0;

    tempvar col = loc.col;
    // Check that col is in the range 0-3.
    assert col * (col - 1) * (col - 2) * (col - 3) = 0;

    // Must explicitly use return() at the end of the
    // function even if there are no return values.
    return ();
}

func verify_adjacent_locations(loc0: Location*, loc1: Location*) {
    // It allocates the memory required for the local variables of
    // the function. This should be the first statement in a function
    // which uses local
    alloc_locals;
    local row_diff = loc0.row - loc1.row;
    local col_diff = loc0.col - loc1.col;

    if (row_diff == 0) {
        // The row coordinate is the same. Make sure the
        // difference in col is 1 or -1.
        assert col_diff * col_diff = 1;

        return ();
    } else {
        // Verify the difference in row is 1 or -1.
        assert row_diff * row_diff = 1;
        // Verify that the col coordinate is the same.
        assert col_diff = 0;

        return ();
    }
}

func verify_location_list(loc_list: Location*, n_steps) {
    // Always verify that the location is valid, even if
    // n_steps = 0 (remember that there is always one more
    // location that steps).
    verify_valid_location(loc=loc_list);

    if (n_steps == 0) {
        assert loc_list.row = 3;
        assert loc_list.col = 3;

        return ();
    }

    verify_adjacent_locations(loc0=loc_list, loc1=loc_list + Location.SIZE);

    verify_location_list(loc_list=loc_list + Location.SIZE, n_steps=n_steps - 1);
    // verify_last_location(locations=loc_list);

    return ();
}

from starkware.cairo.common.registers import get_fp_and_pc

func main() {
    alloc_locals;

    // Try to change the value of row from 0 to 10 and recompil and run
    // the program.
    local loc_tuple: (Location, Location, Location, Location, Location) = (
        Location(row=0, col=2),
        Location(row=1, col=2),
        Location(row=1, col=3),
        Location(row=2, col=3),
        Location(row=3, col=3),
    );

    // Get the value of the frame pointer register (fp) so that
    // we can use the address of loc_tuple.
    let (__fp__, _) = get_fp_and_pc();

    // Since the tuple elements are next to each other, we can
    // use the address of loc_tuple as a pointer to the 5
    // locations.
    verify_location_list(loc_list=cast(&loc_tuple, Location*), n_steps=4);

    return ();
}

// Compile and run the program
// cairo-compile src/puzzle15.cairo  --output comp/puzzle15_compiled.json
// cairo-run --program=comp/puzzle15_compiled.json
