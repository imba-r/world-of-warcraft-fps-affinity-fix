# World of Warcraft FPS Affinity Fix

CPU affinity + priority helper for **World of Warcraft (WoW)** to improve FPS stability on certain CPU-bound systems.

This project was created after noticing significant FPS drops and stuttering in World of Warcraft despite low GPU usage. Manually setting CPU affinity and process priority fixed the issue, but had to be repeated after every restart. This script automates that process.

## What it does

- Monitors `Wow.exe`
- Sets CPU affinity (disables CPU 0–3, enables 4–15 by default)
- Sets process priority to **RealTime** (with automatic fallback to **High**)
- Re-applies settings after WoW restarts
- Logs all events with timestamps (`FPS.log`)

## Tested on

- AMD Ryzen 7 3800XT (8C/16T)
- Windows 10 / 11
- World of Warcraft 12.0.1

Note: Build numbers may change over time. This script does not rely on specific game files and should work across future minor builds unless process behavior changes.

## Requirements

- Windows 10 or 11
- World of Warcraft (Retail or Classic)
- Administrator rights (required for RealTime priority)

## Usage

1. Start World of Warcraft via Battle.net
2. Run `FPS.bat` **as Administrator**
3. Leave the script running in the background

You can start the script before or after launching WoW.

## Configuration

Edit `FPS.ps1`:

- `$Affinity = [IntPtr]0xFFF0` — CPU mask (default enables cores 4–15)
- `$TryRealTime = $true` — try RealTime priority first (fallback to High)
- `$IntervalSec = 2` — monitor interval in seconds

## Notes

- RealTime priority can cause system instability on some setups. If that happens, set `$TryRealTime = $false`.
- This script does not modify game files or memory.

## Disclaimer

Use at your own risk.
Not affiliated with Blizzard Entertainment.
