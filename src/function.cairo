// Code based on "Hello, Cairo", https://www.cairo-lang.org/docs/hello_cairo/intro.html

// Instruct the Cairo compiler to use the "output" builtin
%builtins output

// Standard library to allocate a new memory segement
from starkware.cairo.common.alloc import alloc
// Library to write to the output
from starkware.cairo.common.serialize import serialize_word

// Recursively computes the sum of the memory elements at addresses:
// arr + 0, arr +1, ..., arr + (size - 1).
func array_sum(arr: felt*, size: felt) -> felt {
    if (size == 0) {
        return 0;
    }

    // Note that you don’t have to write arr= and size= but it is
    // recommended as it increases the readability of the code. The
    // memory is immutable therefore the recursive call is needed here.
    let sum_of_rest = array_sum(arr=arr + 1, size=size - 1);

    // Either arr[0] or [arr] can be used for the value of the first
    // element of the array ([...] is the dereference operator, so
    // [arr] is the value of the memory at address arr).
    return arr[0] + sum_of_rest;
}

// Assumes that the size of arr is even and computes the product of
// all the even entries of the array
func array_product_of_even_entries(arr: felt*, size: felt) -> felt {
    if (size == 0) {
        return 0;
    }

    let result = array_product_of_even_entries(arr=arr + 2, size=size - 2);

    return arr[0] + result;
}

func test_run_sum{output_ptr: felt*}() {
    // Declare a constant
    const ARRAY_SIZE = 3;

    // Allocate an array
    let (ptr) = alloc();

    // Populate some values in the array.
    assert [ptr] = 9;
    assert [ptr + 1] = 16;
    assert [ptr + 2] = 25;

    // Call array_sum to compute the sum of the elements
    let sum = array_sum(arr=ptr, size=ARRAY_SIZE);

    // Write the sum to the program output.
    serialize_word(sum);

    return ();
}

func test_run_product{output_ptr: felt*}() {
    // Declare a constant
    const ARRAY_SIZE = 4;

    // Allocate an array
    let (ptr) = alloc();

    // Populate some values in the array.
    assert [ptr] = 1;
    assert [ptr + 1] = 2;
    assert [ptr + 2] = 3;
    assert [ptr + 3] = 4;

    // Call array_product_of_even_entries
    let result = array_product_of_even_entries(arr=ptr, size=ARRAY_SIZE);

    // Write the result to the program output.
    serialize_word(result);

    return ();
}

// The starting point of the Cairo program. The output_ptr declares an
// "implicit argument"
func main{output_ptr: felt*}() {
    test_run_sum();

    test_run_product();

    return ();
}

// Compile and run the program
// cairo-compile src/function.cairo --output comp/function_compiled.json
// layout is used since the program is using the output builtin
// cairo-run --program=comp/function_compiled.json --print_output --layout=small
