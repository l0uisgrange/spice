![](https://img.shields.io/github/downloads/l0uisgrange/spice/total?color=blue)
![](https://img.shields.io/github/v/release/l0uisgrange/spice?label=production)
![](https://img.shields.io/github/v/tag/l0uisgrange/spice?label=development)
![](https://img.shields.io/github/issues/l0uisgrange/spice)


<img src="https://github.com/l0uisgrange/spice/assets/70532216/7f39514e-b40a-4744-b328-4aff1338e34c" width="45" align="left">

# Spice circuit simulator

Introducing Spice 🌶️, the next-generation electronic circuit simulator. It rivals legacy softwares 🤮, but with a new, modern interface ⭐️ with easy-to-use features and smooth performance. Totally free and open source.

## Getting started

> [!IMPORTANT]
> This project is still under development 👷‍♂️. The first stable and full-featured version will be v1.0.0. If you want to be notified when this version is released, please click on the ⭐️ star of this project. The v1.0.0 will also be signed and released on the App Store.

You can download the [latest version](https://github.com/l0uisgrange/spice/releases/latest) and run it directly.

### Requirements
Spice only runs on 
- **macOS** 14.0+
- **iPadOS** 17.2+
- **iOS** 17.2+

and currently supports the following languages:

- 🇩🇰 Danish
- 🇬🇧 English
- 🇫🇷 French
- 🇩🇪 German
- 🇮🇹 Italian

As I am just a human being like you, I would really appreciate your help in correcting translations into your language. Please [open an issue](https://github.com/l0uisgrange/spice/issues/new/choose) to start.

## File format

Spice is planned 📋 to support the universal SPICE netlists (files), developed in 1975 and widely used for circuit simulation. However, it mainly uses it's own `.sp` format, which looks like this:

```text
* Wires
W -40.0 -110.0 50.0 -110.0
W -40.0 -130.0 50.0 -130.0
* Components
R 0.0 -70.0 X 0.0
L -80.0 -10.0 T 0.0
C 120.0 -70.0 X 0.0
```

For more information on how this works, see the documentation 📚 [Wiki](https://github.com/l0uisgrange/spice/wiki).

## Suggestions

Check out the following roadmap to see what I'm working on. You can also suggest new features, bug fixes or improvements to existing features by creating a [new issue](https://github.com/l0uisgrange/spice/issues/new) or by opening a [new discussion](https://github.com/l0uisgrange/spice/discussions/new?category=ideas)!

- [x] Circuit drawing ✍️
- [ ] Circuit simulation 🖲️
- [ ] Circuit analysis ⏱️
- [ ] App update and installation ⏳

## About me 👀

I'm a Swiss 🇨🇭 developer who is tired of seeing bad UX/UI in macOS apps in the engineering world. That's why I create beautiful, user-friendly apps that follow Apple's design guidelines.

## License 

<div style="display: flex;">
<img width="30" src="https://github.com/l0uisgrange/spice/assets/70532216/c5f95c98-1cb6-4219-899c-74be020b8769">
<img width="30" src="https://github.com/l0uisgrange/spice/assets/70532216/e6f3ca6f-51f0-4e88-a573-528987391962">
<img width="30" src="https://github.com/l0uisgrange/spice/assets/70532216/27233635-680e-463d-beff-2d283df99bad">
<img width="30" src="https://github.com/l0uisgrange/spice/assets/70532216/eecf491e-006c-4afb-ab0d-6518570d7dc3">
</div>

This project is distributed under the CC BY-NC-ND 4.0 license ⚖️. The full license is available on the [Creative Common](https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode.en) website.



