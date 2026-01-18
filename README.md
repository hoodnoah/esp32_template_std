# ESP32 Rust Template (std)

A template for ESP32 development with Rust using `esp-idf-svc` (std environment). Uses Nix flakes for reproducible system dependencies and `espup` for the Rust toolchain.

## Quick Start

```bash
nix develop              # Enter development shell
just setup               # Install ESP Rust toolchain (one-time)
exit && nix develop      # Restart shell to pick up toolchain
just build               # Compile
just flash               # Flash to device and monitor
```

## Configuration

### Target Selection

Default target is **ESP32-S3**. To change targets, update these files:

| File | What to change |
|------|----------------|
| `justfile` | `TARGET := "esp32s3"` → your target |
| `.cargo/config.toml` | `[build] target` and `[env] MCU` |

**Available targets:**

| Chip | Architecture | Target Triple | MCU Value |
|------|--------------|---------------|-----------|
| ESP32 | Xtensa | `xtensa-esp32-espidf` | `esp32` |
| ESP32-S2 | Xtensa | `xtensa-esp32s2-espidf` | `esp32s2` |
| ESP32-S3 | Xtensa | `xtensa-esp32s3-espidf` | `esp32s3` |
| ESP32-C2 | RISC-V | `riscv32imc-esp-espidf` | `esp32c2` |
| ESP32-C3 | RISC-V | `riscv32imc-esp-espidf` | `esp32c3` |
| ESP32-C6 | RISC-V | `riscv32imac-esp-espidf` | `esp32c6` |
| ESP32-H2 | RISC-V | `riscv32imac-esp-espidf` | `esp32h2` |

After changing targets, run `just setup` again to install the appropriate toolchain.

### Environment Variables

Copy `.env.example` to `.env` for compile-time configuration:

```bash
cp .env.example .env
```

Variables in `.env` are injected at build time via `build.rs` and accessible with `env!("VAR_NAME")`.

### ESP-IDF Version

Set in `.cargo/config.toml`:

```toml
[env]
ESP_IDF_VERSION = "v5.3.3"
```

### Flash Partitions

`partitions.csv` defines the flash layout:
- `nvs`: 24KB non-volatile storage
- `phy_init`: 4KB PHY calibration
- `factory`: 3MB application

Adjust sizes based on your needs and flash size.

### Stack Size

`sdkconfig.defaults` sets an 8KB main task stack. Rust typically needs more stack than C. Increase if you encounter stack overflows.

## Project Structure

```
├── .cargo/config.toml    # Build target, linker, ESP-IDF version
├── .env.example          # Template for secrets (WiFi, MQTT, etc.)
├── .envrc                # Direnv: auto-loads nix flake
├── build.rs              # Loads .env vars into build
├── Cargo.toml            # Dependencies
├── flake.nix             # Nix dev shell (system deps)
├── justfile              # Task runner
├── partitions.csv        # Flash partition layout
├── rust-toolchain.toml   # ESP Rust toolchain
├── sdkconfig.defaults    # ESP-IDF SDK config
└── src/main.rs           # Application entry point
```

## Commands

| Command | Description |
|---------|-------------|
| `just setup` | Install ESP toolchain for configured target |
| `just setup-all` | Install toolchains for all ESP32 variants |
| `just build` | Debug build |
| `just build-release` | Release build (size-optimized) |
| `just flash` | Flash and monitor |
| `just flash-only` | Flash without monitor |
| `just monitor` | Serial monitor only |
| `just clean` | Remove build artifacts |
| `just size` | Show binary size breakdown |

## Dependencies

**Nix provides:**
- rustup, cmake, ninja, pkg-config
- LLVM/clang (for bindgen)
- Python 3.12 with pyserial
- picocom, just, cargo-generate

**espup installs:**
- ESP Rust toolchain (Xtensa LLVM fork or RISC-V target)
- ldproxy linker wrapper

**Cargo dependencies:**
- `esp-idf-svc`: Full ESP-IDF bindings with std support
- `log`: Logging facade
- `anyhow`: Error handling

## Using as a GitHub Template

### Setting Up the Template Repository

1. Push this repository to GitHub:
   ```bash
   git add -A
   git commit -m "Initial ESP32 Rust template"
   git remote add origin git@github.com:USERNAME/esp32_template.git
   git push -u origin main
   ```

2. On GitHub, go to repository **Settings** → **General**

3. Check **Template repository** under the repository name

### Creating a New Project from the Template

**Option 1: GitHub Web UI**
1. Go to your template repository on GitHub
2. Click the green **Use this template** button
3. Select **Create a new repository**
4. Name your new project and create it
5. Clone the new repository locally

**Option 2: GitHub CLI**
```bash
gh repo create my-esp32-project --template USERNAME/esp32_template --clone
cd my-esp32-project
```

**Option 3: Git clone + remote swap**
```bash
git clone git@github.com:USERNAME/esp32_template.git my-esp32-project
cd my-esp32-project
rm -rf .git
git init
git add -A
git commit -m "Initial commit from esp32_template"
```

### After Creating a New Project

1. Update `Cargo.toml`:
   ```toml
   [package]
   name = "your_project_name"
   ```

2. Adjust target if needed (see Configuration section)

3. Set up the environment:
   ```bash
   nix develop
   just setup
   ```

4. Create `.env` from `.env.example` if using WiFi/MQTT
