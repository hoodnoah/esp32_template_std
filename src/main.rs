use esp_idf_svc::hal::prelude::Peripherals;
use esp_idf_svc::log::EspLogger;
use esp_idf_svc::sys::link_patches;
use log::info;

fn main() -> anyhow::Result<()> {
    // Required ESP-IDF patches
    link_patches();

    // Initialize logging
    EspLogger::initialize_default();

    info!("Starting ESP32 application");

    // Take ownership of peripherals
    let _peripherals = Peripherals::take()?;

    // Your application code here

    info!("Setup complete, entering main loop");

    loop {
        std::thread::sleep(std::time::Duration::from_secs(1));
    }
}
