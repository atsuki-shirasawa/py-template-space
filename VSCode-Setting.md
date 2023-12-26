<!-- @format -->

# Python 開発環境設定方法（Visual Studio Code）

## はじめに

### 開発環境の統一化の目的

- コーディング規約をチームで共有すると、コードの可読性があがり、結果として生産性やコード品質向上につながることが期待
- 一方でコーディング規約は学習・運用コストがかかるため、規約だけ策定してもそのまま形骸化する可能性がある
- 形骸化を防ぐため、リンターやフォーマッター、コードエディタの拡張機能を有効活用して、コード規約違反の箇所に対して警告を表示したり、自動整形する事が可能
- 本書は Python コーディング規約を快適に守るため、[Visual Studio Code](https://code.visualstudio.com/)（以下：VS Code）用のツール導入手順を示す

### 前提：コードエディタについて

- 本書では Microsoft が無料で提供している VS Code をコードエディタとして利用した際の導入手順について記載
- 利用するコードエディタ、IDE は各エンジニアによって**信仰の自由があるため、必ずしも VS Code を利用しなければならないと言うわけではない**
- 他社エディタを利用する際でも、同様のリンターやフォーマッターが利用できるのであれば、設定することを推奨（本書では記述対象外）

## Visual Studio Code 設定方法

### VS Code 拡張機能インストール

- コーディング規約を快適に遵守するために、以下の Python 向け拡張機能を VS Code にインストール

  | #   | 拡張機能                                                                                             | 機能概要                            |
  | :-- | :--------------------------------------------------------------------------------------------------- | :---------------------------------- |
  | 1   | [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)                       | Python 言語サーバー                 |
  | 2   | [autoDocstring](https://marketplace.visualstudio.com/items?itemName=njpwerner.autodocstring)         | docstring を半自動で生成            |
  | 3   | [Black Formatter](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter)     | Black によるフォーマッター          |
  | 4   | [Ruff](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff)                       | Ruff によるリンター兼フォーマッター |
  | 5   | [Mypy Type Checker](https://marketplace.visualstudio.com/items?itemName=ms-python.mypy-type-checker) | Mypy による型チェックリンター       |

#### 1. [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)

- Microsoft 公式の Python 言語拡張サーバーであり、VS Code で Python をコーディングするには、必須の拡張機能
  - コーディング補完
  - コードスニペット
  - デバッガ
  - リンター（静的解析）
  - フォーマッター（コード自動整形）
  - Jupyter Notebook 連携
- 本拡張機能のインストールにより、以下の拡張機能がパックでインストールされるが問題なし
  - Pylance：コーディング補完
  - Jupyter：Jupyte Notebook 連携

#### 2. [autoDocstring](https://marketplace.visualstudio.com/items?itemName=njpwerner.autodocstring)

- パブリックな関数やクラスに対しては、それらを説明する docstring を必ず記載するよう規約で定義
- VS Code の拡張機能である[autoDocstring](https://marketplace.visualstudio.com/items?itemName=njpwerner.autodocstring)で半自動で docstring を生成できるように設定

#### 3. [Black Formatter](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter)

- Black によるフォーマッター拡張機能
- 2023 年 12 月時点でプレビュー版であるが、Microsoft が開発しており、継続開発が期待されるため採用

#### 4. [Ruff](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff)

- Rust で実装された高速なリンター兼フォーマッター
- 500 以上のチェック項目があり、flake8 や isort などのルールをサポート

#### 5. [Mypy Type Checker](https://marketplace.visualstudio.com/items?itemName=ms-python.mypy-type-checker)

- コードを型アノテーションを付ける構文([PEP 484](https://www.python.org/dev/peps/pep-0484/))に基づき、チェックしてくれるリンター
- Black と同様に 2023 年 12 月時点でプレビュー版であるが、Microsoft が開発しており、継続開発が期待されるため採用

### setting.json 追記

- エディタ上で拡張機能やリンターやフォーマッターの機能を有効活用にするため、VS Code の設定条件を記載する json ファイルに以下の記述を追記

- 設定ファイル`（~/Library/Application Support/Code/User/settings.json）`に下記設定内容を追記

  `settings.json`抜粋

  ```json
  {
    /*
      auto-seve & format on save
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
      "editor.defaultFormatter": "ms-python.black-formatter",
    },
    "black-formatter.args": [
      "--line-length=79",
    ],
    /*
      docstring style : Google Style
    */
    "autoDocstring.docstringFormat": "google",
    /*
      vertical rulers
    */
    "editor.rulers": [
      79
    ],
    /*
      enable Mypy linter
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

    //以下、リンターやフォーマッターの設定に影響のない範囲であれば、各自自由にカスタマイズして良い
    ...
  }

  ```

- また上記以外の VS Code の拡張機能などはリンターやフォーマッターの設定に影響のない範囲であれば、各自自由にカスタマイズして良い

## プロジェクトへのリンター・フォーマッター設定方法

### ライブラリインストール

- 開発時に必要なリンター、フォーマッターをインストール

  ```
  poetry add --group dev black mypy ruff
  ```

  | #   | 目的                      | パッケージ                                       | 機能概要                                                                                                            | Github Star 数<br />（2023 年 12 月時点） |
  | :-- | :------------------------ | :----------------------------------------------- | :------------------------------------------------------------------------------------------------------------------ | ----------------------------------------- |
  | 1   | リンター                  | [mypy](https://mypy.readthedocs.io/en/stable/)   | 型チェックを行なってくれるリンター                                                                                  | 16.9K                                     |
  | 2   | リンター兼 フォーマッター | [Ruff](https://beta.ruff.rs/docs/)               | Rust で flake8 や isort などの既存のリンターを再実装した高速なリンター兼フォーマッター                              | 21.6K                                     |
  | 3   | フォーマッター            | [black](https://black.readthedocs.io/en/stable/) | 他のフォーマッターよりも制限が厳しく、pep8 で明確に規定されていないが不揃いだと気になりがちな細かなスタイルまで統一 | 35.7K                                     |

### 設定方法

- Mypy、Ruff、black の設定内容はすべて`pyproject.toml`に記述する事で VSCode の拡張機能や開発ワークスペースでもそのルールが適用されるため、ここにルールを記述

- `pyproject.toml` は PEP で提案されているパッケージのビルドに必要なデータを定義するファイルフォーマット

  - `target-version`のみ実行環境の Python バージョンに書き換えが必要

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
  target-version = <Set Python Version. expected one of "py37", "py38", "py39", "py310", "py311")>

  [tool.ruff.per-file-ignores]
  # ignore assert error only in unnit-test
  "test_*.py" = ["S101"]
  "*_test.py" = ["S101"]

  [tool.ruff.pydocstyle]
  convention = "google"

  [tool.ruff.mccabe]
  max-complexity = 10
  ```

### mypy

- 型チェックを行なってくれるリンター
- [mypy 1.8.0 documentation](https://mypy.readthedocs.io/en/stable/)

#### 設定内容

```toml
show_column_numbers = true
ignore_missing_imports = true
disallow_untyped_defs = true
no_implicit_optional = true
warn_return_any = true
warn_unused_ignores = true
warn_redundant_casts = true
```

- `show_column_numbers = true` : エラー発生箇所の行数/列数を表示
- `ignore_missing_imports = true` : import 先のチェックを行わない
- `disallow_untyped_defs = true` : 関数定義の引数/戻り値に型アノテーション必須
- `no_implicit_optional = true` : 引数に`None`を取る場合型アノテーションに`Optional`必須
- `warn_return_any = true` : 戻り値が `Any` 型ではない関数の戻り値の型アノテーションが `Any` のとき警告
- `warn_unused_ignores = true` : mypy エラーに該当しない箇所に`# type: ignore` コメントが付与されていたら警告
- `warn_redundant_casts = true` : 冗長なキャストに警告

### black

- 他のフォーマッターよりも制限が厳しいフォーマッター
- pep8 で明確に規定されていないが不揃いだと気になりがちな細かなスタイルまで統一
- [Black 23.12.0 documentation](https://black.readthedocs.io/en/stable/index.html)

#### 設定内容

```
[tool.black] line-length = 79
```

- `line-length` : 1 行あたりの最大文字数を 79 文字（[PEP 規定](https://peps.python.org/pep-0008/#maximum-line-length)）に設定

### ruff

- Rust で flake8 や isort などの既存のリンターを再実装した高速なリンター兼フォーマッター

#### 設定内容

```toml
[tool.ruff]
line-length = 79
select = [
    "E",    # pycodestype error
    "W",    # pycodestyle warning
    "F",    # pyflakes
    "C90",  # mccabe
    "I",    # isort
    "D",    # pydocstyle
    "B",    # flake8-bugbear
    "COM",  # flake8-commas
    "S",    # flake8-bandit
    "PTH",  # flake8-use-pathlib
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

- `[tool.ruff]` : Ruff の基本ルールを指定
  - `line-length`：1 行あたりの最大文字数を 79 文字（[PEP 規定](https://peps.python.org/pep-0008/#maximum-line-length)）に設定
  - `select` : 適応するルール一覧
    - `E` : コードスタイルチェックツールの`pycodestype`のエラー
    - `W` : コードスタイルチェックツールの`pycodestype`の警告
    - `F` : 文法チェックツールの`pyflakes`
    - `C90` : コードの複雑度（循環的複雑度）を図るツール`mccabe`
    - `I` : import スタイルチェックツール`isort`
    - `D` : docstring のコードスタイルチェックツール`pydocstyle`
    - `B` : バグになりそうなコードを検知するツール`flake8-bugbear`
    - `COM` :配列などの文末に comma を入れるためのツール`flake8-commas`
    - `S` :コードのセキュリティ問題をチェックしてくれるツール`flake8-bandit`
    - `PTH` : パス操作で`Pathlib`を推奨するツール`flake8-use-pathlib`
  - `ignore` : `select`で指定したルールからチェック除外としたいルールを指定
    - `D415` : docstrting の説明文の最後が「`.`」「`?`」「`!`」である必要はないため、ルールから除外
    - `E501` : 1 行あたりの最大文字数制限は`black`でチェック済みのため、ルールから除外
      - [ruff は日本語等の非 ASCII 文字で正しい文字数がカウントできない仕様](https://github.com/charliermarsh/ruff/issues/3825)で有るため、現段階では無視
  - `unfixable` : 自動フォーマットを無効にするルールを指定（エラーは出すが自動修正はしない）
    - `F401` : 使われていない import は自動フォーマット対象外
    - `F841` : 使われていない変数は自動フォーマット対象外
  - `target-version` : プロジェクトの Python バージョンを指定（`"py37"`, `"py38"`, `"py39"`, `"py310"`, `"py311"`, `"py312"`）
- `[tool.ruff.per-file-ignores]` : ファイルごとに無視するルールを指定
  - テストコードにおいて`S101`（`Use of assert detected`）エラーは無視
- `[tool.ruff.pydocstyle]` : `pydocstyle`に関する設定
  - `convention = "google"` : `pydocstyle`は[Google スタイル](https://google.github.io/styleguide/pyguide.html)
- `[tool.ruff.mccabe]` : `mccabe`に関する設定
  - `max-complexity = 10` : [循環的複雑度](https://ja.wikipedia.org/wiki/循環的複雑度)の許容値を`10`とする
    - 循環的複雑度の目安：（引用：[循環的複雑度](https://jp.mathworks.com/discovery/cyclomatic-complexity.html) ）
      - 10 以下：非常に良い構造（バグ混入確率 : 25%）
      - 30 以上：構造的なリスクあり（バグ混入確率 : 40%）
      - 50 以上：テスト不可能（バグ混入確率 : 70%）
      - 75 以上：いかなる変更も誤修正を生む（バグ混入確率 : 98%）

## リンター・フォーマッターの一括実行

- VS Code では開いているファイルのみがリンター・フォーマッターの対象となるため、プロジェクト全体のコードに対して実行する場合は、`Makefile`を用意すると便利

### Makefile の記述例

```makefile
SOURCE_FILES=./app
TEST_FILES=./tests

lint:
 poetry run mypy ${SOURCE_FILES} ${TEST_FILES}
 poetry run ruff check ${SOURCE_FILES} ${TEST_FILES}

format:
 poetry run ruff check ${SOURCE_FILES} ${TEST_FILES} --fix-only --exit-zero
 poetry run black ${SOURCE_FILES} ${TEST_FILES} --diff
```

#### リンター実行

```shell
make lint
```

#### フォーマッター実行

```shell
make format
```
