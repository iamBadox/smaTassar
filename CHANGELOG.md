# Changelog

All notable changes to **Små Tassar** will be documented here.

---

## [0.7.0] - 2026-03-30

### Fixed
- Male ♂ and female ♀ symbols now display correctly (switched from SF Symbols to Unicode characters for reliability)

---

## [0.6.0] - 2026-03-30

### Changed
- App display name is now "Små Tassar" (shown under the icon and in iOS settings)

---

## [0.5.0] - 2026-03-30

### Fixed
- Litter chart lines now correctly use each puppy's collar color instead of all appearing red

---

## [0.4.0] - 2026-03-30

### Changed
- Sex indicator now uses ♂/♀ symbols instead of arrows, in light blue and light pink
- Puppy name placeholder changed from "Bella" to "Alva"

---

## [0.3.0] - 2026-03-30

### Added
- Edit support for litters — swipe right on a litter to edit its name
- Edit support for puppies — swipe right on a puppy to edit all fields (name, color, sex, birth weight, birth date)
- Edit support for weight entries — swipe right on a weight entry to correct it
- Delete support for litters, puppies, and weight entries — swipe left to delete

---

## [0.2.0] - 2026-03-30

### Added
- Optional name field for puppies
- Puppy name shown in the puppy list, detail screen, and as the page title

---

## [0.1.0] - 2026-03-27

### Added
- Initial release
- Add and manage litters (name, mark as complete / reopen)
- Add puppies to a litter with collar color, sex, birth weight, and birth date/time
- Log weight updates for each puppy
- Individual puppy growth chart (line chart by collar color)
- Litter-wide overlay chart showing all puppies' growth together
- All data stored locally on device using SwiftData (no account or internet required)
