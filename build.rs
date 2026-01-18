use std::env;
use std::path::PathBuf;

fn main() {
    // Load .env file if it exists
    let manifest_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let env_path = manifest_dir.join(".env");

    if env_path.exists() {
        println!("cargo:rerun-if-changed=.env");
        dotenvy::from_path(&env_path).ok();

        // Re-export environment variables for use in code via env!() macro
        for (key, value) in dotenvy::from_path_iter(&env_path).unwrap().flatten() {
            println!("cargo:rustc-env={}={}", key, value);
        }
    }

    // ESP-IDF build system integration
    embuild::espidf::sysenv::output();
}
