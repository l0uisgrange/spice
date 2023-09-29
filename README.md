<img src="https://github.com/l0uisgrange/spice/blob/main/Spice/Assets.xcassets/AppIcon.appiconset/512x512%202x%201.png" width="80">

# Spice circuit simulator

Spice 🌶️ is a native macOS simulator for electronic circuits that rivals LTSpice and other legacy software 🤮. It features a new, modern interface ⭐️ with easy-to-use features and smooth performance. Completely free and open source.

## Download

You can download the [latest version](https://github.com/l0uisgrange/spice/releases/latest) and run it directly.

#### Requirements
Spice works only on **macOS sonoma** 14.0+ and currently supports the following languages:
- 🇫🇷 French
- 🇬🇧 English

## File format

Spice supports the original SPICE netlists (files) developed in 1975 and used everywhere for circuit simulation. However, the app mainly uses it's own format `.spice`, which looks like this:
```text
* Data statements
R1 0 0 1 0 10 10 10 100
V1 0 1 0 0 10 0 0 DC 150
```

For more informations on how this works, please read the [Wiki](https://github.com/l0uisgrange/spice/wiki)

## Suggestions

Check my [roadmap](https://github.com/users/l0uisgrange/projects/2) to see what I'm working on. You can also suggest new features, bug fixes, or improvements to existing features by creating an issue!

## About me 👀

I'm a Swiss 🇨🇭 developer who is tired of seeing bad UX/UI in macOS apps in the engineering world. That's why I create beautiful, user-friendly apps that follow Apple Design Guidelines.

## Copyright ⚖️

Spice is an open-source project distributed under the GPL-3.0 license.
