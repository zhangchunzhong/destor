extern crate libc;

use libc::c_int;
use std::ffi::CStr;
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn yesnotoi(s: *const c_char) -> c_int {
    let st = unsafe { CStr::from_ptr(s).to_string_lossy().into_owned() };
    if st.eq_ignore_ascii_case("yes") {
        1
    } else if st.eq_ignore_ascii_case("no") {
        0
    } else {
        -1
    }
}
