# Contributing

Thanks for your interest in improving the AI Memory Guide!

## How to Contribute

### Report Issues
- Open an [issue](https://github.com/Qu4ntking/ai-memory-guide/issues) for bugs, broken links, or unclear content

### Suggest Improvements
- Open an issue with the `enhancement` label
- Describe what you'd like to see and why

### Submit Changes
1. Fork the repo
2. Create a branch (`git checkout -b feature/my-improvement`)
3. Make your changes
4. Test any script changes locally (`bash scripts/memory-health.sh`)
5. Commit (`git commit -m 'Add: description of change'`)
6. Push (`git push origin feature/my-improvement`)
7. Open a Pull Request

## What We're Looking For

- **New patterns** — Anti-amnesia techniques, write-through improvements
- **Platform guides** — Integration docs for Claude Code, Cursor, Windsurf, etc.
- **Script improvements** — Bug fixes, new checks, cross-platform compatibility
- **Templates** — New file templates for common use cases
- **Translations** — The guide in other languages
- **Case studies** — How you use this system in practice

## Style Guide

- Keep language direct and practical
- Code examples should be copy-pasteable
- Scripts must work with `bash` + `yq` (no Python/Node required)
- Frontmatter on every `.md` file in `templates/`

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
