#!/usr/bin/env fish
# Usage:
#   source Scripts/xcd.fish
#   xcd

function xcd --description 'Select a recent Xcode project and move to the directory'
    # Ensure the helper CLI is available before proceeding.
    if not type -q xcodecd
        echo "error: xcodecd command not found in PATH" 1>&2
        return 1
    end

    # Refuse to run when stdout is not an interactive terminal.
    if not test -t 1
        echo "error: xcodecd requires an interactive terminal; run this function inside a TTY session" 1>&2
        return 1
    end
    
    # Determine the temporary directory, preferring $TMPDIR when present.
    set -l tmpdir "/tmp"
    if set -q TMPDIR
        set tmpdir "$TMPDIR"
    end

    # Create a transcript file that will capture the interactive session.
    set -l transcript (mktemp "$tmpdir/xcd.XXXXXX")
    if not test -f "$transcript"
        echo "error: unable to create temporary file for xcd transcript" 1>&2
        return 1
    end

    # Run xcodecd inside script(1) so its output can be examined afterwards.
    script -q "$transcript" "xcodecd"
    set -l xcd_status $status
    if test $xcd_status -ne 0
        rm -f "$transcript"
        echo "error: failed to obtain target path from xcd" 1>&2
        return 1
    end

    # Read the final non-empty line from the transcript as the destination path.
    set -l target_path ""
    for line in (string replace -a '\r' '' (cat "$transcript"))
        if test -n (string trim -- "$line")
            set target_path (string trim -- "$line")
        end
    end
    rm -f "$transcript"

    # Abort if no path was captured; otherwise change into the destination.
    if test -z "$target_path"
        echo "error: xcd did not produce any output" 1>&2
        return 1
    end

    cd "$target_path"
end
