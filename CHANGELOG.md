# Changelog

### 0.2.3 (January 28, 2020)
- [BUGFIX] Fix another scoring issue

### 0.2.2 (January 27, 2020)
- [BUGFIX] Fix another scoring issue

### 0.2.1 (January 26, 2020)
- [BUGFIX] Remove debug information from option output
- [IMPROVEMENT] Add debug option to display scoring info
- [BUGFIX] Fixed scoring for comma separated numbers

### 0.2 (January 26, 2020)
- [IMPROVEMENT] Add scoring model to better handle cases that needed prompting before, like comma-separated numbers
- [IMPROVEMENT] Correct line escaping even on lines that don't have incorrect commas to ensure correct parsing of generated CSV down the line
- [IMPROVEMENT] Use ruby csv library to generate lines instead of handling escaping cases manually

### 0.1.1 (January 24, 2020)
- [BUGFIX] handle case where all columns are equal widths
- [BUGFIX] Improve error message
- [IMPROVEMENT] simplify slicing [\#1](https://github.com/jkeen/comma_splice/pull/1) ([AlexMooney](https://github.com/AlexMooney))

### 0.1.0 (August 5th, 2019)
- Initial Release
