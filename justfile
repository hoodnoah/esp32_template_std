# ESP32 Rust Template (std)
# Default target - change this to switch between ESP32 variants
# Options: esp32, esp32s2, esp32s3, esp32c2, esp32c3, esp32c6, esp32h2
TARGET := "esp32s3"

default:
    @just --list

# One-time setup: install esp toolchain for configured target
setup:
    cargo install espup cargo-espflash espflash ldproxy
    espup install --targets {{ TARGET }}
    @echo ""
    @echo "Setup complete. Restart shell: exit, then 'nix develop'"

# Setup all targets (Xtensa + RISC-V)
setup-all:
    cargo install espup cargo-espflash espflash ldproxy
    espup install
    @echo ""
    @echo "Setup complete. Restart shell: exit, then 'nix develop'"

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

# Clean everything including ESP-IDF cache (use after version changes)
clean-all:
    cargo clean
    rm -rf .embuild

# Show binary size info
size:
    cargo size --release -- -A

# Generate new project from esp-idf-template
new-project:
    cargo generate esp-rs/esp-idf-template