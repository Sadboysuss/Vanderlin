// rust_g.dm - DM API for rust_g extension library
//
// To configure, create a `rust_g.config.dm` and set what you care about from
// the following options:
//
// #define RUST_G "path/to/rust_g"
// Override the .dll/.so detection logic with a fixed path or with detection
// logic of your own.
//
// #define RUSTG_OVERRIDE_BUILTINS
// Enable replacement rust-g functions for certain builtins. Off by default.

#define rustg_dmi_strip_metadata(fname) call_ext(RUST_G, "dmi_strip_metadata")(fname)

#define rustg_git_revparse(rev) call_ext(RUST_G, "rg_git_revparse")(rev)
#define rustg_git_commit_date(rev) call_ext(RUST_G, "rg_git_commit_date")(rev)

#define rustg_log_write(fname, text) call_ext(RUST_G, "log_write")(fname, text)
/proc/rustg_log_close_all() return call_ext(RUST_G, "log_close_all")()
