/* automatically generated by rust-bindgen 0.54.1 */

extern "C" {
    pub fn __ae_init(
        min: ::std::os::raw::c_int,
        max: ::std::os::raw::c_int,
        avg: ::std::os::raw::c_int,
    );
}
extern "C" {
    pub fn __ae_chunk_data(
        p: *mut ::std::os::raw::c_uchar,
        n: ::std::os::raw::c_int,
    ) -> ::std::os::raw::c_int;
}
