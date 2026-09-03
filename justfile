@_default:
  just --list --unsorted

# Run all recipes
run-all: format-all check-all build-all

# List all TODO items in the repository
list-todos:
  grep -R -n \
  --exclude-dir=.quarto \
  --exclude-dir=_book \
  --exclude-dir=_site \
  --exclude-dir=.git \
  --exclude=justfile \
  --exclude=copier.yaml \
  "TODO" .

# Install or update the pre-commit hooks
install-precommit:
  # Install pre-commit hooks
  uvx pre-commit install
  uvx pre-commit run --all-files
  uvx pre-commit autoupdate

# Run all formatters
format-all: format-md

# Format Markdown files
format-md:
  # Use both rumdl and panache, for different purposes
  uvx rumdl fmt --silent
  uvx --from panache-cli panache format . --quiet

# Run all check recipes
check-all: check-spelling check-urls

# Check for spelling errors in files
check-spelling:
  uvx typos --config .config/typos.toml

# Install lychee from https://lychee.cli.rs/guides/getting-started/
# Check that URLs work with lychee
check-urls:
  lychee . \
    --verbose \
    --extensions md,qmd \
    --exclude "github\.com" \
    --exclude-path "_badges.qmd"

# Run all build recipes
build-all: build-contributors build-readme build-website

# Re-build the README file from the Quarto version
build-readme:
  uvx --from quarto quarto render README.qmd --to gfm

# Generate a Quarto include file with the contributors
build-contributors:
  sh ./tools/get-contributors.sh sdca-latam/curso-GLED-2026 > includes/_contributors.qmd

# Build Quarto website
build-website:
  quarto render

# Preview the website with automatic reload on changes
preview-website:
  quarto preview

# Check for and apply updates from the template
update-from-template:
  uvx copier update --defaults

# Reset repo changes to match the template
reset-from-template:
  uvx copier recopy --defaults
