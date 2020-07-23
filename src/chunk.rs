extern crate libc;

use libc::c_int;
use std::ffi::CStr;
use std::os::raw::c_char;

#[link(name = "chunking", kind = "static")]
extern "C" {
    pub fn __ae_init(
        min: ::std::os::raw::c_int,
        max: ::std::os::raw::c_int,
        avg: ::std::os::raw::c_int,
    );

    pub fn __ae_chunk_data(
        p: *mut ::std::os::raw::c_uchar,
        n: ::std::os::raw::c_int,
    ) -> ::std::os::raw::c_int;
}

//Paper title: "AE: An Asymmetric Extremum Content Defined Chunking Algorithm for Fast and Bandwidth-Efficient Data Deduplication"
//http://ranger.uta.edu/~jiang/publication/Conferences/2015/2015-INFOCOM-AE-%20An%20Asymmetric%20Extremum%20Content%20Defined%20Chunking%20Algorithm%20for%20Fast%20and%20Bandwidth-Efficient%20Data%20Deduplication.pdf
static mut WIN_SIZ: c_int = 0;
static mut CHK_MAX: c_int = 0;
static mut CHK_MIN: c_int = 0;

#[no_mangle]
pub extern "C" fn ae_init(min: c_int, max: c_int, avg: c_int) {
    let e = 2.718281828;
    unsafe { WIN_SIZ = (avg as f64 / (e - 1.0) as f64) as c_int };
    unsafe {
        CHK_MAX = max;
        CHK_MIN = min;
    };
}

/*
Input: input string, Str; left length of the input string, L;
Output: chunked position (cut-point), i
1: Predefined values: window size, w; length of interval S;
2: function AECHUNKING(Str, L)
3:     i <- 1
4:     max:value <- Str[i]:value
5:     max:position <- i
6:     i <- i + 1
7:     while i < L do
8:         if Str[i]:value <= max:value then
9:            if i = max:position + w then
10:              return i
11:           end if
12:        else
13:           max:value <- Str[i]:value
14:           max:position <- i
15:        end if
16:        i <- i + 1
17:    end while
18:    return L
19: end function
*/

#[no_mangle]
pub extern "C" fn ae_chunk_data(p: *const c_char, n: c_int) -> c_int {
    let winsz = unsafe { WIN_SIZ };
    let chkmax = unsafe { CHK_MAX };
    if n <= winsz + 8 {
        return n;
    }
    let mut i: usize = 1;
    let slen = n as usize;
    let buf = unsafe { CStr::from_ptr(p).to_bytes() };
    let mut maxv = buf[i];
    let mut maxp = i;
    i = i + 1;
    while i < slen {
        if buf[i] <= maxv {
            if i == (maxp + winsz as usize) || i == chkmax as usize {
                return i as c_int;
            }
        } else {
            maxv = buf[i];
            maxp = i;
        }
        i = i + 1;
    }
    return n;
}
