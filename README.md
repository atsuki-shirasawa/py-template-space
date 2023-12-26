<!-- @format -->

# python-template-workspace

## Dev Framework

- Code Editor [Visual Stuido Code](https://code.visualstudio.com/)
- Python package & Dependency management： [Poetry](https://python-poetry.org/)
- Formatter: [black](https://black.readthedocs.io/en/stable/), [ruff](https://beta.ruff.rs/docs/)
- Linter: [mypy](https://github.com/python/mypy)
- Unittest: [pytest](https://docs.pytest.org/en/7.0.x/)
- Automates testing: [tox](https://tox.wiki/en/latest/)
- Command interface: [click](https://click.palletsprojects.com//)

## Template

### VSCode Settings

`.vscode/settings.json`

```json
{
  /*
    auto-seve & format on save for all files
*/
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit",
    "source.organizeImports": "explicit"
  },
  /*
    enable Black formatter
*/
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter"
  },
  "black-formatter.args": ["--line-length=79"],
  /*
    mypy settings
*/
  "mypy-type-checker.args": [
    "--show-column-numbers",
    "--ignore-missing-imports",
    "--disallow-untyped-defs",
    "--no-implicit-optional",
    "--warn-return-any",
    "--warn-unused-ignores",
    "--warn-redundant-casts"
  ],
  /*
    docstring style : Google Style
*/
  "autoDocstring.docstringFormat": "google",
  /*
    vertical rulers
*/
  "editor.rulers": [79]
}
```

### Linter & Formatter Settings

`pyproject.toml`

```toml
[tool.mypy]
show_column_numbers = true
ignore_missing_imports = true
disallow_untyped_defs = true
no_implicit_optional = true
warn_return_any = true
warn_unused_ignores = true
warn_redundant_casts = true

[tool.black]
line-length = 79

[tool.ruff]
line-length = 79
select = [
    "E",   # pycodestype error
    "W",   # pycodestyle warning
    "F",   # pyflakes
    "C90", # mccabe
    "I",   # isort
    "D",   # pydocstyle
    "B",   # flake8-bugbear
    "COM", # flake8-commas
    "S",   # flake8-bandit
    "PTH", # flake8-use-pathlib
]
ignore = [
    "D415", # pydocstyle about First line should end with a '.' , '?' or '!'
    "E501", # line too long, handled by black
]
unfixable = [
    "F401", # disable auto-fix for unused-imports
    "F841", # disable auto-fix for unused-variable
]
target-version = <Set Python Version. expected one of "py37", "py38", "py39", "py310", "py311", "py312")>

[tool.ruff.per-file-ignores]
# ignore assert error only in unnit-test
"test_*.py" = ["S101"]
"*_test.py" = ["S101"]

[tool.ruff.pydocstyle]
convention = "google"

[tool.ruff.mccabe]
max-complexity = 10
```
