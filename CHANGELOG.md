# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased] - 

### Fixed
- Fix compile error calling `.compare_versions` with `Pond::VERSION`

## [2.0.0] - 2024-04-16

### Added
- Add `Pond.drain(&)` class method

### Changed
- Replace internal fiber collection with an internal counter

### Fixed
- Reduce memory footprint for long running processes

### Removed
- Remove `Pond#<<` method
- Remove `Pond.drain(Fiber)` class method
- Remove `Pond.drain(Array(Fiber))` class method
- Remove `Pond#fill(Fiber)` overload
- Remove `Pond#fill(Array(Fiber))` overload

## [1.0.1] - 2024-02-14

### Fixed
- Replace `Fiber.yield` with `sleep 1.microsecond` in loops to reduce CPU load

## [1.0.0] - 2023-05-29

### Added
- First stable release

## [0.3.5] - 2023-03-06

### Changed
- Update GitHub actions
- Change argument type of `Pond.drain(Array(Fiber))` to `Indexable(Fiber)`

## [0.3.4] - 2022-03-17

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
