#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

DATA_FILE="${1:-}"
TMPDIR="$(mktemp -d)"

clean_exit() {
    rm -rf "$TMPDIR"
}
trap "clean_exit" EXIT

if [ -z "$DATA_FILE" ]; then
    echo "ERROR: Data file not set."
    exit 1
fi

echo "Fetching repositories..."
if [ "${GITHUB_TOKEN:-UNSET}" = "UNSET" ]; then
    REPOS=$(curl -s -f https://api.github.com/users/jlesage/repos?per_page=1000 | grep '"name"' | grep 'docker-' | cut -d':' -f2 | tr -d '", ')
else
    REPOS=$(curl -H "Authorization: token $GITHUB_TOKEN" -s -f https://api.github.com/users/jlesage/repos?per_page=1000 | grep '"name"' | grep 'docker-' | cut -d':' -f2 | tr -d '", ')
fi
if [ "${REPOS:-UNSET}" = "UNSET" ]; then
    echo "ERROR: No repository found."
    echo "--------------------------------------"
    curl https://api.github.com/users/jlesage/repos
    echo "--------------------------------------"
    exit 1
fi

echo > "$DATA_FILE"

for REPO in $REPOS; do
    echo "Fetching appdefs from jlesage/$REPO..."

    FRIENDLY_NAME=

    if [ -z "$FRIENDLY_NAME" ]; then
        set +e
        curl -f -s -o "$TMPDIR"/$REPO.appdefs.yml https://raw.githubusercontent.com/jlesage/$REPO/master/appdefs.yml
        RC=$?
        set -e
        if [ $RC -eq 0 ]; then
            FRIENDLY_NAME="$(cat "$TMPDIR"/$REPO.appdefs.yml | sed -n 's|.*friendly_name: \(.*\)|\1|p')"
        fi
    fi

    if [ -z "$FRIENDLY_NAME" ]; then
        set +e
        curl -f -s -o "$TMPDIR"/$REPO.appdefs.xml https://raw.githubusercontent.com/jlesage/$REPO/master/appdefs.xml
        RC=$?
        set -e
        if [ $RC -eq 0 ]; then
            FRIENDLY_NAME="$(cat "$TMPDIR"/$REPO.appdefs.xml | sed -n 's|.*<friendly_name>\(.*\)</friendly_name>|\1|p')"
        fi
    fi

    if [ -z "$FRIENDLY_NAME" ]; then
        echo "  -> File not found.  Skipping."
        continue
    fi

    NAME="$(echo $REPO | sed 's|^docker-||')"
    echo "- name: $NAME" >> "$DATA_FILE"
    echo "  friendlyName: $FRIENDLY_NAME" >>  "$DATA_FILE"
done
