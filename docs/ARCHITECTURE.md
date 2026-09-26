# Architecture

## Overview

NetShield sits between every protected device and the internet at the **DNS layer**, rather than the browser or app layer. This is what lets it block ads, trackers, and unwanted sites inside native apps (not just browsers) and off the home network entirely.

```
┌────────────┐        ┌─────────────────┐        ┌───────────────┐        ┌────────────┐
│  Device    │──DNS──▶│  Tailscale Mesh │──DNS──▶│  Raspberry Pi │──DNS──▶│ Cloudflare │
│ (anywhere) │        │ (encrypted VPN) │        │   (Pi-hole)   │        │ (upstream) │
└────────────┘        └─────────────────┘        └───────────────┘        └────────────┘
```

## Request Flow

1. **Device asks a question** — e.g. `GET junglee-rummy.in` triggers a DNS lookup for `junglee-rummy.in`.
2. **Tailscale routes the DNS query** through the encrypted mesh back to the Raspberry Pi, regardless of which physical Wi-Fi or mobile network the device is actually using.
3. **Pi-hole checks its blocklists** — the domain is matched against curated lists (ads, trackers, betting sites, explicit content).
4. **Decision:**
   - **Blocked** → Pi-hole returns a null/blocked response. The domain never resolves, so the page never loads (`ERR_HTTP2_PROTOCOL_ERROR` or similar in-browser).
   - **Allowed** → Pi-hole forwards the query to the upstream resolver (Cloudflare), gets the real IP, and returns it to the device.

## Why Tailscale?

A traditional Pi-hole setup only filters DNS for devices *on the same local network* as the Pi (typically via router DHCP settings). The moment a device leaves that Wi-Fi, it falls back to its carrier's or the new network's default DNS — and all filtering disappears.

Tailscale solves this by giving every registered device a **fixed virtual address** on a private mesh network. Devices are configured (via Tailscale's DNS settings) to always send DNS queries through the Pi's Tailscale address — whether they're on home Wi-Fi, a hotel network, a friend's hotspot, or mobile data.

This means:
- No router configuration needed on unfamiliar networks.
- No admin/root permissions required on the device.
- Protection is tied to the *device's identity on the mesh*, not the network it happens to be using.

## Components

| Component | Role |
|---|---|
| **Raspberry Pi 4** | Always-on host for Pi-hole; draws under 5W. |
| **Pi-hole** | DNS sinkhole — resolves or blocks based on blocklists; provides the query-log dashboard. |
| **Tailscale** | WireGuard-based mesh VPN; gives every device a stable path back to the Pi. |
| **Blocklists** | Curated domain lists for ads, trackers, betting, and explicit content (see `config/pihole/`). |
| **Cloudflare DNS** | Upstream resolver used for any domain that isn't blocked. |

## Dashboard & Auditing

Pi-hole's built-in web dashboard (`http://<pi-address>/admin`) provides:
- A live query log of every DNS request seen by the network.
- Per-client breakdowns (which device asked for what).
- One-click enable/disable of blocking, and blocklist management.
