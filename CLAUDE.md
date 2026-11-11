# Vrat (package: vrat / com.itsash.vrat)

Offline fasting and festival calendar with reminders, in English and Hindi.
Computes the current and next year for a chosen city. INTERNET is used only
by the update check in Settings.

## Engine (`lib/engine/`)

A copy of the Panchang app's engine (`../panchang/lib/engine/`; there is no
shared package, keep the two in step by copying). Meeus Sun (ch. 25) and Moon
(ch. 47), mean Lahiri ayanamsa, tithi/nakshatra/yoga segments with exact end
times, sunrise/sunset (upper limb), moonrise (disc centre after parallax, the
Drik convention), summer-time rules by country. Accuracy against Drik Panchang
(New Delhi): sunrise/sunset and moonrise/moonset within 0.5 min, tithi ends
within about 2 min (ours about 1.3 min late). See Panchang's `CLAUDE.md`.

## Rules (`lib/vrat/`)

- `rules.dart`: declarative table. A `Rule` = id, kind, tithi indices (0..29),
  `Anchor` (sunrise, daytime, purvahna, madhyahna, aparahna, pradosh, nishita,
  moonrise), optional amanta month, `exceptMonths`, `adhika` (monthly vrats
  also in adhika months; festivals only in nija months), `bhadraFree`.
  Day chosen = the civil day on which the tithi overlaps the anchor most
  (ties: first); if it never meets the anchor, the day with most daylight in
  it. Bhadra rules (Raksha Bandhan, Holika Dahan) ignore Vishti karana time
  and, if Bhadra covers the whole anchor, take the next day.
  Chosen per observance (verified against Drik, see tests): Ekadashi = udaya
  (sunrise) tithi, Smarta; Pradosh = pradosh; Purnima and Amavasya = aparahna;
  Sankashti and Karwa Chauth = moonrise; Vinayaka and Ganesh Chaturthi,
  Ram Navami = madhyahna; Akshaya Tritiya = forenoon (see below); Masik Shivratri and Maha Shivratri
  = nishita; Dussehra, Bhai Dooj = aparahna; Diwali, Dhanteras = pradosh;
  Janmashtami = day with most Ashtami daylight (udaya, Vaishnava reckoning).
- `calendar.dart`: `VratCalendar(place).build(from, to)` builds tithi segments
  for the span, labels each with its amanta month (adhika when the Sun stays
  in one rashi between new moons), applies every rule, adds Holi (day after
  Holika Dahan), Makar Sankranti (Sun enters sidereal Makara; after sunset =
  next day), Ekadashi names (Krishna paksha named by purnimanta month, Padmini
  and Parama in adhika months), Hari Vasara (first quarter of Dwadashi) and
  the parana window (next day from the later of sunrise and Hari Vasara end,
  to the earlier of Dwadashi end and the end of the first fifth of the day,
  or madhyahna if that is already past).
- `catalog.dart`: English and Hindi name, significance, method and "how the
  date is decided" for every id; Ekadashi variants in `ekadashiNames`.
- Monthly rules skip the months where a festival replaces them (Magha
  Shivratri -> Maha Shivratri, Ashwin Ashtami -> Durga Ashtami, Ashwin
  Chaturthi -> Karwa Chauth, Bhadrapada Chaturthi -> Ganesh Chaturthi).

### Match with Drik (New Delhi, 2026-27)

All Ekadashi (49/49), Pradosh, Purnima, Amavasya, Sankashti, Vinayaka, Masik
Shivratri and Durgashtami dates match, and so do all 44 festival dates. Three
rules are fitted to Drik's published dates (cut-offs are empirical, not
published by Drik): `_pickEkadashi` in `calendar.dart` (Ekadashi at two
sunrises: first day unless Dashami within 144 min before that sunrise, then the
second; Ekadashi covering a sunrise for under 48 min: the day it began),
Holika Dahan (when Bhadra covers the whole pradosh, the next day only if
Purnima ends within 96 min of that day's sunset, else the same day in Bhadra's
tail; 2026-03-03, 2027-03-21) and Akshaya Tritiya (first day with at least
48 min of Tritiya in the forenoon; 2026-04-19, 2027-05-09). Only a Smarta day
is listed; Drik also shows a separate Vaishnava/Gauna day in some months (e.g.
Yogini 2026-07-11, Kamika 2027-07-30). That pattern was not derivable from the
tithi data alone, so it is not modelled; the detail page shows when Ekadashi
ends. The reference lists are in `test/reference.dart`. Ram Navami 2026
follows the Smarta day (03-26); ISKCON keeps 03-27.

Tithi end bias: new and full moons from the engine agree with USNO to the
minute (2026-02-17 12:01:50, 03-03 11:38:41, 03-19 01:24:26, 04-02 02:12:48
UTC against 12:01, 11:38, 01:23, 02:12), so the engine is consistent; the
remaining ~1 min lag against Drik is about what minute truncation plus
Swiss-Ephemeris/ΔT conventions explain and is left as is.

## Reminders

`lib/notify/reminders.dart`: `planReminders` (pure, tested) gives the evening
before and the morning of each followed observance at the chosen local times
of the place, from now on, nearest 120. `Reminders` schedules them with
`flutter_local_notifications` (`zonedSchedule` with absolute UTC instants), exact
alarms when `canScheduleExactNotifications`, inexact otherwise. The
plugin's `ScheduledNotificationBootReceiver` (manifest) restores them after a
reboot; the app also reschedules on every start and every settings change.
Notification icon: `res/drawable/ic_notification.xml` (white diya). Pinned to
`flutter_local_notifications ^22.3.3`: 23.x needs compileSdk 37 and AGP 9.1
(androidx.core 1.19), which this Flutter toolchain (AGP 9.0.1) lacks. Needs core
library desugaring (build.gradle.kts) and the permissions in the manifest.

## Code layout

- `lib/app/app_model.dart`: settings, `follow` set (monthly kinds by name,
  festivals by id), computed observances (`Isolate.run`), `refresh()`.
- `lib/ui/`: `home_screen.dart` (Upcoming, Calendar), `upcoming_page.dart`
  (UiCountdown card + list), `calendar_page.dart`, `detail_screen.dart`,
  `follow_screen.dart`, `settings_screen.dart` (language, location, follow,
  reminders, then `UiUpdateSection` and `UiDeveloperSection`),
  `location_screen.dart`, `format.dart`.
- Tests: `test/calendar_test.dart` (Drik comparison, festivals, parana,
  catalog), `test/app_test.dart` (reminder plan, settings, widget test).

## Commands

- `make run`, `make build` (release APK), `make test`, `make clean`.
- Icon: SVG sources in `assets/icon/` -> `rsvg-convert -w 1024 -h 1024` to
  `*-1024.png`, then `dart run flutter_launcher_icons`.

## Conventions

- minSdk 26. UI only from the shared `theme` package; no hardcoded colors (the
  maroon accent is `UiApp(accent:)`). Bilingual text through `AppModel.t(en,
  hi)`, `Names` and the catalog.

## Release (Ash Store)

- `store.json` (id `vrat`, repo its-ash/vrat), `store.mk`, `index.html` +
  `CNAME` (`vrat.itsash.in`). See `../ash-store/store-kit/STORE.md`.
- `make deploy` = bump version -> build -> commit, tag `vX.Y.Z`, push -> GitHub
  release with `vrat.apk` -> topics, homepage, Pages. Never create releases,
  tags or asset names by hand.
- Do not edit `store.mk` here. Edit `../ash-store/store-kit/store.mk`, then run
  `make store-sync` at the workspace root.
