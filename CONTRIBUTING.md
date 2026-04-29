# Contributing to Automation ROI Tracker

Thanks for your interest in improving this project! Whether you found a bug, have a feature idea, or want to improve the code, contributions are welcome.

## How to Contribute

### Reporting Bugs

If something's not working right:

1. Check if someone already reported it in the Issues section
2. If not, create a new issue with:
   - What you were trying to do
   - What you expected to happen
   - What actually happened
   - Screenshots if applicable
   - Your Power BI Desktop version

### Suggesting Features

Got an idea for improvement?

1. Open an issue describing:
   - The problem you're trying to solve
   - How your feature would help
   - Any implementation ideas (optional)

### Submitting Code Changes

Want to fix a bug or add a feature?

1. **Fork the repository**
2. **Create a branch** for your changes
   - Name it something descriptive: `fix-ytd-calculation` or `add-quarterly-view`
3. **Make your changes**
   - Keep changes focused (one feature/fix per PR)
   - Add comments explaining why, not just what
   - Test your changes thoroughly
4. **Submit a Pull Request**
   - Describe what you changed and why
   - Link to any related issues

## Code Guidelines

### Power Query (M Language)

- Use meaningful variable names
- Add comments for complex logic
- Handle missing columns with error handling
- Keep transformations modular

Example:
```m
// Good
#"Added TotalTC" = Table.AddColumn(
    #"Previous Step",
    "TotalTC",
    each [AutomatedTC] + [ManualTC] + [ThirdPartyTC],
    type number
)

// Not ideal
#"Step1" = Table.AddColumn(#"Step0", "Col1", each [A]+[B]+[C], type number)
```

### DAX Measures

- Use VAR for readability
- Add comments explaining the logic
- Use DIVIDE instead of / for null handling
- Format for readability

Example:
```dax
// Good
AutoPercent = 
VAR TotalTCs = SUM(FactROI[AutomatedTC]) + SUM(FactROI[ManualTC])
RETURN
    DIVIDE(SUM(FactROI[AutomatedTC]), TotalTCs)

// Not ideal
AutoPercent = SUM(FactROI[AutomatedTC])/(SUM(FactROI[AutomatedTC])+SUM(FactROI[ManualTC]))
```

### Documentation

- Update README.md if you add features
- Add comments to code explaining complex parts
- Keep language simple and friendly
- Use examples where helpful

## Questions?

Not sure about something? Open an issue and ask! No question is too basic.

## Code of Conduct

Be respectful and constructive. We're all here to learn and improve.

---

Thanks for making this project better!
