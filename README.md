# Production Machines and Maintenance Log for Business Central

![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg) ![Business Central 25+](https://img.shields.io/badge/Business%20Central-25%2B-0B7E8A) ![AL](https://img.shields.io/badge/language-AL-5C2D91)

**Know which machine ran each production order, and when it was last serviced.**

<!-- DEMO: record a 30-60 second screen capture, save it as docs/images/demo.gif, then replace this comment with:
![Demo](docs/images/demo.gif) -->

## Why

Business Central tracks work centers and machine centers for capacity planning. It doesn't track the physical machines on the floor: which press ran an order, when it was serviced, what the last safety check found. That history usually lives in a binder or a spreadsheet.

## What it does

- **Machine register** with code, name, location, description and blocked flag.
- **Machine log** of maintenance, QA, safety and other entries, with date and user. The log type list can be extended.
- **Attachments** (manuals, photos, certificates) on the machine card.
- **Machine field on released production orders**, limited to machines at the order's location, with drill-down to the machine card.

## Setup

1. Search for **Machines** and add your machines.
2. Open a machine card and use **Machine Log** to add entries.
3. On a released production order, choose the **Machine**.
4. Assign `MID MACHINES` to the people who maintain machines. Business Premium users also get access through the bundled extension of `D365 BUS PREMIUM`.

Production orders require the Business Central **Premium** license.

## Install

**From a release (no build tools needed)**
1. Download the `.app` file from the latest [release](../../releases).
2. In Business Central, open **Extension Management** → **Manage** → **Upload Extension** and select the file.
3. Assign the permission set listed below to the people who use it.

**From source**
1. Clone this repo and open `ProductionMachines` in VS Code with the [AL Language extension](https://marketplace.visualstudio.com/items?itemName=ms-dynamics-smb.al).
2. Put your sandbox name and tenant ID in `.vscode/launch.json`, then run **AL: Download Symbols**.
3. Press **F5** to publish to your sandbox.

Always test in a sandbox before you install in production.

## Technical details

| | |
|---|---|
| Object ID range | 50170–50189 |
| Object prefix | `MID` |
| Dependencies | Base Application, System Application |
| Permission set(s) | `MID MACHINES` |
| Business Central | Online, version 25 or later |

## Need help with this app?

[Midstream Integrations](https://www.MidstreamIntegrations.com) installs, adapts and supports these extensions, and builds new ones for your process.
**[Book a 20-minute call](https://midstreamintegrations.com/contact)** · intro@MidstreamIntegrations.com

## Contributing

Issues and pull requests are welcome; see [CONTRIBUTING](https://github.com/Midstream-Integrations/.github/blob/main/CONTRIBUTING.md).
Found a security problem? Please follow the [security policy](https://github.com/Midstream-Integrations/.github/blob/main/SECURITY.md) instead of opening a public issue.

## License

[MIT](LICENSE) © Midstream Integrations
