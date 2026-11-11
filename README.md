# Vrat

Ekadashi, Pradosh, Sankashti and festival dates for your city, with reminders, offline.

**[Website](https://vrat.itsash.in)** · **[Download APK](https://github.com/its-ash/vrat/releases/latest/download/vrat.apk)** · Get it in **[Ash Store](https://store.itsash.in)**

## Features

- **Upcoming list** of the next vrats and festivals with a countdown to the
  first, and a **calendar** of the year. Tap any day for the details.
- **Vrats**: Ekadashi (named, with the parana time and Hari Vasara), Pradosh,
  Purnima, Amavasya, Sankashti Chaturthi with moonrise, Vinayaka Chaturthi,
  Masik Shivratri and Masik Durgashtami.
- **Festivals**: Makar Sankranti, Vasant Panchami, Maha Shivratri, Holika
  Dahan and Holi, both Navratris, Ram Navami, Hanuman Jayanti, Akshaya
  Tritiya, Guru Purnima, Raksha Bandhan, Janmashtami, Ganesh Chaturthi,
  Durga Ashtami, Dussehra, Karwa Chauth (with moonrise), Dhanteras, Diwali,
  Govardhan Puja, Bhai Dooj and Chhath.
- **Meaning and method** for each in English and Hindi, and a note on how the
  date is decided and where traditions differ.
- **Reminders** the evening before and on the morning, for the observances you
  follow, at times you choose. They come back after a reboot.
- **Your city** from a built-in list (or the nearest one by GPS, once).
- **Offline and private**: dates are worked out on your phone. The only
  network call is the update check in Settings.

## Install

- **Ash Store**: install [Ash Store](https://store.itsash.in) once, then install and update Vrat from it.
- **APK**: download the [latest APK](https://github.com/its-ash/vrat/releases/latest/download/vrat.apk) on your phone and open it. Allow your browser to install unknown apps if Android asks.

Requires Android 8.0 (API 26) or later. On Android 13 and later Vrat asks for
permission to show notifications.

## Accuracy

Dates are computed from the Sun and Moon (Meeus series, Lahiri ayanamsa) and
checked against Drik Panchang for New Delhi in 2026 and 2027: Pradosh, Purnima,
Amavasya, Vinayaka Chaturthi, Masik Shivratri, Masik Durgashtami and Sankashti
all agree on every date (moonrise within 2 minutes); 46 of 49 Ekadashi dates
agree; 61 of 66 festival dates agree. The rest differ by one day where
printed almanacs differ among themselves (Bhadra, Smarta or Vaishnava
reckoning). Each detail page says how the day is chosen.

## Develop

Needs Flutter ≥ 3.44 and the shared theme package at `../theme`.

```bash
make run      # run on a connected device
make test     # flutter analyze + flutter test
make build    # release APK
make deploy   # bump version, build, tag, push, GitHub release (see store.mk)
```

## Release

`make deploy` follows the Ash Store kit (`store.mk`, `store.json`): it bumps the
version in `pubspec.yaml`, builds, commits, tags `vX.Y.Z`, pushes, and publishes
a GitHub release with `vrat.apk`. Ash Store and the website pick up the new
version from that release.

## Project layout

```
lib/
├── main.dart                 # UiApp + AppScope
├── engine/                   # pure Dart astronomy (copy of Panchang's engine)
├── vrat/
│   ├── rules.dart            # declarative table: tithi + anchor per observance
│   ├── calendar.dart         # applies the rules, Ekadashi names and parana
│   ├── observance.dart       # Observance, ObsKind
│   └── catalog.dart          # English and Hindi texts
├── notify/reminders.dart     # reminder plan + flutter_local_notifications
├── data/                     # names, offline cities
├── app/app_model.dart        # settings, following, computed dates
└── ui/                       # upcoming, calendar, detail, follow, settings
```

See `CLAUDE.md` for details.

## License

No license file is included yet.

Built by [itsash.in](https://itsash.in).
