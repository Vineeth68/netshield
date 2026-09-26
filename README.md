# 🛡️ NetShield

**A self-hosted DNS firewall that blocks ads, trackers, and unsafe content — on every device, on every network, anywhere in the world.**

Built on a Raspberry Pi, protected by Tailscale, powered by Pi-hole.

> Team **Byteme** — Hackathon 2026

![Status](https://img.shields.io/badge/status-active-brightgreen)
![Platform](https://img.shields.io/badge/platform-Raspberry%20Pi-c51a4a)
![License](https://img.shields.io/badge/license-MIT-blue)

---

## Table of Contents

- [The Problem](#the-problem)
- [Our Solution](#our-solution)
- [How It Works](#how-it-works)
- [Live Proof](#live-proof)
- [Beyond a Single Wi-Fi](#beyond-a-single-wi-fi)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Hardware](#hardware)
- [Getting Started](#getting-started)
- [Roadmap](#roadmap)
- [Team](#team)
- [License](#license)

---

## The Problem

Ad blockers today only protect **one browser, on one device, on one network.**

| Issue | What it means |
|---|---|
| **Browser extensions** | Install on your phone, reinstall on your laptop, again on your tablet — every time, every device. |
| **Per-device setup** | Blocked in-browser but not in-app — YouTube, Instagram, and other mobile apps are never covered. |
| **No control off Wi-Fi** | Step off the home network onto mobile data and every protection disappears instantly. |

**Result:** people stay exposed to ads, trackers, and unwanted content the moment they leave a single controlled setup.

## Our Solution

A personal DNS firewall, built on a **$50 computer**, that follows the *user* instead of the *network*.

```
Raspberry Pi 4  ➜  Pi-hole Engine  ➜  Tailscale Mesh
```

- **Raspberry Pi 4** — runs Pi-hole, a DNS server that filters every request before it leaves the network.
- **Pi-hole Engine** — checks each domain against curated blocklists: ads, trackers, betting sites, and explicit content.
- **Tailscale Mesh** — a private, encrypted network that connects the Pi to every device, on any Wi-Fi, anywhere.

Every device on the mesh automatically routes its DNS through the Pi — no per-app setup, no browser extension.

## How It Works

**How a single request flows:**

1. **Device asks a question** — *"What's the address of this website?"*
2. **Pi-hole checks its list** — matched against ad, tracker, and betting-site blocklists.
3. **Blocked → dead end** — the domain never resolves; the page never loads.
4. **Allowed → Cloudflare** — the real address is looked up and returned through the Pi.

The blocked ad, tracker, or betting site never leaves the ground — the user simply never sees it.

## Live Proof

Real browser tests captured while the protected DNS path was active — the target (a betting site) never resolved:

<p align="center">
  <img src="docs/images/live-test-01-betting-site-blocked.png" width="45%" alt="Live test 1 — site blocked" />
  <img src="docs/images/live-test-02-betting-site-blocked.png" width="45%" alt="Live test 2 — site blocked" />
</p>

Both attempts resulted in `ERR_HTTP2_PROTOCOL_ERROR` — the target site did not load.

## Beyond a Single Wi-Fi

Protection that follows the **device**, not the **router**.

| Network | Protected? |
|---|---|
| Home Wi-Fi | ✅ Blocked |
| Hotel / hostel Wi-Fi | ✅ Blocked |
| Friend's hotspot | ✅ Blocked |
| Mobile data, anywhere | ✅ Blocked |

**How:** Tailscale builds an encrypted private mesh between the Pi and every registered device. Each device keeps a fixed Tailscale address and always routes its DNS through the Pi — regardless of the physical network it's connected to.

- No router access needed.
- No per-network setup.
- No admin permissions required.

## Features

- **Custom blocklists** — ads, trackers, adult content, and betting sites, curated and updated with one command.
- **Full audit dashboard** — live query log shows exactly what was requested, allowed, or blocked, in real time.
- **Family-safe by design** — doubles as a parental-control layer, no extra app installs on kids' devices.
- **Under $50 hardware** — runs on a Raspberry Pi drawing under 5 watts — cheaper and greener than any subscription filter.

## Tech Stack

| Layer | Technology |
|---|---|
| Hardware | Raspberry Pi 4 |
| DNS filtering | [Pi-hole](https://pi-hole.net/) |
| Remote mesh networking | [Tailscale](https://tailscale.com/) |
| Upstream resolver | Cloudflare DNS |

# SMART DETECTION ML LAYER
How it works:

Synthetic traffic generator — click "Start Simulation" and it streams fake DNS queries (mix of normal domains, known-bad domains, and DGA-style random/high-entropy domains) into the live feed.
Feature extraction — each query gets scored on request rate, domain entropy, subdomain depth, and time-of-day deviation.
Real Isolation Forest — trained in-browser on a baseline of normal traffic, then scores each new query for anomalousness (this is an actual small isolation forest, not a canned rule).
Two-tier detection — known-bad domains get caught instantly by the static blocklist; novel suspicious traffic gets caught by the ML layer.
LLM explainer — click any flagged or blocked row, then "Explain with LLM" to get a live, plain-language explanation of why it looked suspicious, generated on the spot from that query's actual feature values.

## Hardware

- Raspberry Pi 4 (2GB+ RAM)
- MicroSD card (16GB minimum, Class 10)
- Ethernet cable (recommended for the Pi) or stable Wi-Fi
- Power supply (5V/3A USB-C)

**Total cost: ~$50**, drawing under 5 watts — cheaper and greener than a subscription filtering service.

## Getting Started

> These are the general setup steps — see [`scripts/`](scripts/) for install helpers.

1. **Flash Raspberry Pi OS Lite** onto your MicroSD card and boot the Pi on your network.
2. **Install Pi-hole**:
   ```bash
   curl -sSL https://install.pi-hole.net | bash
   ```
3. **Install Tailscale** on the Pi and every device you want protected:
   ```bash
   curl -fsSL https://tailscale.com/install.sh | sh
   sudo tailscale up
   ```
4. **Set the Pi as the DNS server** for the Tailscale mesh (via `tailscale up --accept-dns` on clients, or by configuring split-DNS in the [Tailscale admin console](https://login.tailscale.com/admin/dns)).
5. **Load custom blocklists** — see [`config/pihole/custom-blocklists.txt`](config/pihole/custom-blocklists.txt) — via Pi-hole's **Group Management → Adlists** screen or the `pihole -g` command.
6. **Verify** — from a device on mobile data (off your home Wi-Fi entirely), confirm a known ad/tracker/betting domain fails to resolve.

Full step-by-step instructions: [`scripts/install.sh`](scripts/install.sh) and [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

## Roadmap

- [ ] One-command installer script (Pi-hole + Tailscale + blocklists in a single run)
- [ ] Pre-built SD card image for flash-and-go setup
- [ ] Mobile companion app for toggling protection per device
- [ ] Scheduled/parental-control time windows (e.g., block gaming domains after bedtime)
- [ ] Multi-Pi failover for larger households

## Team

**Team Byteme** — Hackathon 2026

## License

Released under the [MIT License](LICENSE).
