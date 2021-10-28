#!/usr/bin/env bats

load 'lib/bats-support/load'
load 'lib/bats-assert/load'

TMP_DIRECTORY=$(mktemp -d)

# Setup git repo in temp dir to test functions against
# --------------------------------------------------------------------

setup() {
    cd $TMP_DIRECTORY
    echo 'setting up'
    gg i
    git config user.email "test@csi.lk"
    git config user.name "gg test"
    echo "test file" > test_file
    git add test_file
    run git commit -m "test commit"
}

# If tests pass delete temp git repo
# --------------------------------------------------------------------

teardown() {
    if [ $BATS_TEST_COMPLETED ]; then
        echo "Deleting $TMP_DIRECTORY"
        rm -rf $TMP_DIRECTORY
    else
        echo "** Did not delete $TMP_DIRECTORY, as test failed **"
    fi
    cd $BATS_TEST_DIRNAME
}

# The tests
# --------------------------------------------------------------------

@test "Invoke: no param prints help" {
    run gg
    assert_success
    assert_line --partial "simple git aliases"
}

@test "Status" {
    run gg s
    assert_success
    assert_line --partial "On branch master"
}

@test "Add: all files" {
    run touch test1.md
    run gg a
    assert_success
    assert_line --partial "Added all files"
    assert_line --partial "new file:   test1.md"
}

@test "Add: specfic file" {
    run touch test2.md
    run gg a test2.md
    assert_success
    assert_line --partial "Added: test2.md"
    assert_line --partial "new file:   test2.md"
}

@test "Status" {
    run gg s
    assert_success
    assert_line --partial "On branch master"
}

@test "Checkout: no param" {
    run gg ch
    assert_failure
    assert_line --partial "Missing parameter: thing to checkout"
}

@test "Checkout: branch" {
    git branch test
    run gg ch test
    assert_line --partial "Switched to branch 'test'"
}

@test "Pull" {
    run gg pl
    assert_success
    assert_line --partial "git-pull"
}

# TODO: Learn how to test interactive input
# @test "Checkout Pull Rebase" {
#     # Setup
#     gg b test
#     gg ch master
#     echo "test file 2" > test_file2
#     git add test_file2
#     git commit -m "test commit 2"
#     gg ch test
#     # Assert
#     run gg cpr
#     assert_success
# }

@test "Push" {
    run gg p
    assert_success
    assert_line --partial "Could not read from remote repository."
}

@test "Force Push" {
    run gg pf
    assert_success
    assert_line --partial "Strap in, we're force pushing..."
}

@test "Log" {
    run gg l
    assert_success
    assert_line --partial "test commit"
}

@test "Latest commit message" {
    run gg lc
    assert_success
    assert_line --partial "test commit"
}

# TODO: Learn how to test interactive input
# @test "Rebase" {
#     run gg r
#     assert_failure
#     assert_line --partial "Missing parameter: thing to checkout"
# }

# @test "Rebase: no param" {
#     run gg r
#     assert_failure
#     assert_line --partial "Missing parameter: thing to checkout"
# }

@test "Stash" {
    echo "test file 2" > test_file2
    run gg st
    assert_success
    assert_line --partial "Saved working directory"
}

@test "Stash Pop" {
    echo "test file 2" > test_file2
    gg st
    run gg stp
    assert_success
    assert_line --partial "new file:   test_file2"
}

@test "Branch" {
    run gg b test
    assert_success
    assert_line --partial "Switched to a new branch 'test'"
}

@test "Branch: no param" {
    run gg b
    assert_success
    assert_line --partial "All Branches:"
}

@test "Branch delete" {
    git branch test
    run gg bd test
    assert_success
    assert_line --partial "Deleted branch test"
}

@test "Branch delete: no param" {
    run gg bd
    assert_failure
    assert_line --partial "Missing parameter: branch name to delete"
}

@test "Github: Pull Request" {
    git remote add origin https://github.com/csi-lk/gg
    run gg pr
    assert_success
    assert_line --partial "Opening pull request for branch: master"
}

@test "Gitlab: Pull Request" {
    git remote add origin git@gitlab.com:csilk/gg.git
    run gg pr
    assert_success
    assert_line --partial "Opening pull request for branch: master"
}

@test "Github: Open URL" {
    git remote add origin https://github.com/csi-lk/gg
    run gg o
    assert_success
    assert_line --partial "Opening repo url: https://github.com/csi-lk/gg"
}

@test "Gitlab: Open URL" {
    git remote add origin git@gitlab.com:csilk/gg.git
    run gg o
    assert_success
    assert_line --partial "Opening repo url: https://gitlab.com/csilk/gg"
}

@test "Pull request log" {
    git branch prl
    run gg ch prl
    echo "test prl" > test_prl
    run gg a
    run git commit -m "feat: test adding commit" -m "commit body" -m "TICKET-123"
    run gg prl
    assert_success
    assert_line --partial "Log output for PR..."
    assert_line --partial "feat:"
    assert_line --partial "commit body"
    assert_line --partial "TICKET"
    assert_line --partial "Copied to clipboard"
}

@test "Tag create" {
    git remote add origin https://github.com/csi-lk/gg
    run gg t test-tag
    assert_success
    run gg t
    assert_line --partial "test-tag"
}

@test "Tag delete" {
    git remote add origin https://github.com/csi-lk/gg
    run gg t test-tag
    assert_success
    run gg td test-tag
    assert_success
    assert_line --partial "Deleted tag 'test-tag'"
}

@test "Tag delete: no param" {
    git remote add origin https://github.com/csi-lk/gg
    run gg td
    assert_failure
    assert_line --partial "Missing parameter: tag name to delete"
}

@test "Display Help" {
    run gg -h
    assert_success
    assert_line --partial "simple git aliases"
}

@test "Unknown Command" {
    run gg test
    assert_failure
    assert_line --partial "Unknown command: 'test'"
}

@test "Clean" {
    run gg clean
    assert_success
    assert_line --partial "All Branches:"
}