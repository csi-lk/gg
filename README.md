# Git Goodies (gg)

Aliases and helpers for many git related tasks to speed up my workflow

Originally adapted from [GitGoodies](https://github.com/qw3rtman/gg), my version has some different functions and generally focuses on speed.

There is still a lot TODO, i'll get around to it as I need it :)

## Installation

### Linux / MacOS

```bash
curl -fsSL git.io/fpEqU | bash
```

## Usage

| command       | does                                                                                 |
| ------------- | ------------------------------------------------------------------------------------ |
| gg s          | git status                                                                           |
| gg ch <thing> | git checkout <thing>                                                                 |
| gg pl         | git pull                                                                             |
| gg cpr        | git checkout master && git pull && git checkout <currentBranch> && git rebase master |
| gg p          | git push                                                                             |
| gg pf         | git push force                                                                       |
| gg l          | git history oneline                                                                  |
| gg lc         | git history latest commit                                                            |
| gg r <number> | git rebase HEAD~<number> -i                                                          |
| gg st         | add all files and stash                                                              |
| gg stp        | stash pop latest                                                                     |
| gg clean      | delete local branches not on master                                                  |
| gg b <name>   | create and checkout branch <name>, if exists check it out                            |
| gg bd <name>  | delete branch                                                                        |
| gg cf <scope> | git commit fixup <scope>                                                             |
| gg pr         | create new github pull request for current branch                                    |
| gg t          | create a tag                                                                         |
| gg td <name>  | delete a tag <name>                                                                  |

## Development

Make sure you clone recursivley as am using submodules for bats

```bash
git clone --recursive git@github.com:csi-lk/gg.git
```

All functions are in the one file, the [gg bin](./bin/gg)

## Testing

Unit testing using [bats](https://github.com/sstephenson/bats) with [support](https://github.com/ztombol/bats-support) and [assert](https://github.com/ztombol/bats-assert) libs

All tests are defined in [the one file](./test/gg.bats)

### Setting Up

Install bats with brew (macOS)

```bash
brew install bats
```

or with yarn / npm

```bash
yarn install
```

### Running

```bash
bats test
```

or

```bash
yarn test
```

---

🧔 Be sure to checkout [my other repos](https://github.com/csi-lk/) and [website / blog](https://csi.lk)
