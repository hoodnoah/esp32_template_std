# ESP32 Rust Development Environment
# This template provides the Nix environment and convenience commands.
# Run `just init <name>` to generate the Rust project using the official esp-rs template.

default:
    @just --list

# Initialize project using official esp-rs template
init name:
    cargo generate esp-rs/esp-idf-template cargo --name {{name}}
    cp -r {{name}}/{Cargo.toml,.cargo,build.rs,src,sdkconfig.defaults,rust-toolchain.toml} ./
    rm -rf {{name}}
    @echo ""
    @echo "Project initialized! Next steps:"
    @echo "  1. Run 'just setup' to install the ESP toolchain"
    @echo "  2. Run 'just build' to compile"
    @echo "  3. Run 'just flash' to flash and monitor"

# Install ESP toolchain (run after init)
setup:
    cargo install espup cargo-espflash espflash ldproxy
    espup install
    @echo ""
    @echo "Setup complete. Restart your shell to pick up the new environment."

# Build firmware (debug)
build:
    cargo build

# Build firmware (release, size-optimized)
build-release:
    cargo build --release

# Flash and monitor
flash:
    cargo espflash flash --release --monitor --partition-table partitions.csv

# Flash only (no monitor)
flash-only:
    cargo espflash flash --release --partition-table partitions.csv

# Serial monitor
monitor:
    cargo espflash monitor

# Clean build artifacts
clean:
    cargo clean

# Clean everything including ESP-IDF cache
clean-all:
    cargo clean
    rm -rf .embuild

# Show binary size info
size:
    cargo size --release -- -A
