# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased] - 

### Added
- Ensure support for *Crystal* v1.3.0

## [0.3.3] - 2021-12-25

### Added
- Add support for *Crystal* v1.2

### Fixed
- Fix segmentation fault while reading fibers collection
- Clear *Pond* when all fibers are dead
- Check fiber is alive before adding to pond

## [0.3.2] - 2021-06-28

### Fixed
- Fix [segfault][segfault] while removing dead fibers

[segfault]: https://github.com/GrottoPress/mel/runs/2932323566?check_suite_focus=true

## [0.3.1] - 2021-06-21

### Added
- Add `Pond#fill` overload that accepts an array of fibers

### Fixed
- Ensure dead fibers continue to be removed whenever pond is refilled

## [0.3.0] - 2021-06-18

### Changed
- Allow refilling and draining a drained pond

### Added
- Add `Pond#size` that returns number of fibers in a pond

### Changed
- Replace travis-ci with GitHub actions

## [0.2.0] - 2021-03-31

### Added
- Add `Pond.drain` class methods

## [0.1.0] - 2021-03-25

### Added
- Initial public release
