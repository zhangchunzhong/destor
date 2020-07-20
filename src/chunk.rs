extern crate libc;

use libc::c_int;
use std::os::raw::c_char;

//Paper title: "AE: An Asymmetric Extremum Content Defined Chunking Algorithm for Fast and Bandwidth-Efficient Data Deduplication"
//http://ranger.uta.edu/~jiang/publication/Conferences/2015/2015-INFOCOM-AE-%20An%20Asymmetric%20Extremum%20Content%20Defined%20Chunking%20Algorithm%20for%20Fast%20and%20Bandwidth-Efficient%20Data%20Deduplication.pdf

static mut window_size: c_int = 0;

#[no_mangle]
pub extern "C" fn ae_init(_min : c_int, _max : c_int, avg : c_int) {
    let e = 2.718281828;
	unsafe { window_size = (avg as f64 / (e-1.0) as f64) as c_int }; 
}

#[no_mangle]
pub extern "C" fn ae_chunk_data(p: *const c_char, n : c_int) -> c_int {
    0    
}
