<img src="https://github.com/l0uisgrange/spice/blob/main/Spice/Assets.xcassets/AppIcon.appiconset/512x512%202x%201.png" width="80">

# Spice circuit simulator

Spice 🌶️ is a native macOS simulator for electronic circuits that rivals LTSpice and other legacy software 🤮. It features a new, modern interface ⭐️ with easy-to-use features and smooth performance. Completely free and open source.

## Download

You can download the latest version for MacOS 14+ and run it directly.

## File format

Spice uses and supports the original SPICE netlists (files) developed in 1975 and used everywhere for circuit simulation. It looks like this:
```text
* Data statements
R1 1 2 1k
V1 1 0 DC 5V
```
| Component | Date statement |
| :-- | :-- |
| Voltage source | `V<name> <node1> <node2> DC <value>` |
| Current source | `I<name> <node1> <node2> DC <value>` |

For more informations, please read the ![Wiki](https://github.com/l0uisgrange/spice/wiki)

## Languages support

Spice currently supports the following languages:
- 🇫🇷 French
- 🇬🇧 English

## Suggestions

You can see my [roadmap](https://github.com/users/l0uisgrange/projects/2) to see what I am working on and suggest modifications by creating an Issue.

## About me 👀

I'm a Swiss 🇨🇭 developer who is tired of seeing bad UX/UI in macOS apps in the engineering world. That's why I create beautiful, user-friendly apps that follow Apple Design Guidelines.

## Copyright ⚖️

Spice is an open-source project distributed under the MIT license.
