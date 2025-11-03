#!/usr/bin/env bash
# Usage:
#   source Scripts/xcd.sh
#   xcd

xcd() {
    # Ensure the helper CLI is available before proceeding.
    if ! command -v xcodecd >/dev/null 2>&1; then
        printf '%s\n' "error: xcodecd command not found in PATH" >&2
        return 1
    fi

    # Refuse to run when stdout is not an interactive terminal.
    if [ ! -t 1 ]; then
        printf '%s\n' "error: xcodecd requires an interactive terminal; run this function inside a TTY session" >&2
        return 1
    fi

    # Determine the temporary directory, preferring \$TMPDIR when present.
    local tmpdir=${TMPDIR:-/tmp}

    # Create a transcript file that will capture the interactive session.
    local transcript
    transcript=$(mktemp "$tmpdir/xcd.XXXXXX") || {
        printf '%s\n' "error: unable to create temporary file for xcd transcript" >&2
        return 1
    }

    # Ensure the transcript is cleaned up regardless of early exits.
    trap 'rm -f "$transcript"' RETURN

    # Run xcodecd inside script(1) so its output can be examined afterwards.
    script -q "$transcript" xcodecd
    local xcd_status=$?
    if [ $xcd_status -ne 0 ]; then
        printf '%s\n' "error: failed to obtain target path from xcd" >&2
        return 1
    fi

    # Read the final non-empty line from the transcript as the destination path.
    local target_path
    target_path=$(tr -d '\r' <"$transcript" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e '/^$/d' | tail -n 1)

    # Abort if no path was captured; otherwise change into the destination.
    if [ -z "$target_path" ]; then
        printf '%s\n' "error: xcd did not produce any output" >&2
        return 1
    fi

    builtin cd "$target_path"
}
