#!/bin/bash

# Source environment variables
. /etc/environment

if [ "$MODE" = "easy" ]; then
    exec rsgain easy $OPTIONS /music
elif [ "$MODE" = "custom" ]; then
    # Find all supported audio files recursively in /music

    echo "Searching for audio files in /music..."

    mapfile -t AUDIO_FILES < <(find /music -type f \( \
        -iname "*.aiff" -o \
        -iname "*.flac" -o \
        -iname "*.ape" -o \
        -iname "*.mp2" -o \
        -iname "*.mp3" -o \
        -iname "*.m4a" -o \
        -iname "*.mpc" -o \
        -iname "*.ogg" -o \
        -iname "*.oga" -o \
        -iname "*.spx" -o \
        -iname "*.opus" -o \
        -iname "*.tak" -o \
        -iname "*.wav" -o \
        -iname "*.wv" -o \
        -iname "*.wma" \
    \))
    if [ ${#AUDIO_FILES[@]} -eq 0 ]; then
        echo "No audio files found in /music"
        exit 1
    fi

    echo "Found ${#AUDIO_FILES[@]} audio files. Processing rsgain custom..."

    for file in "${AUDIO_FILES[@]}"; do
        rsgain custom $OPTIONS "$file" || echo "Failed to process $file"
    done

    echo "rsgain processing completed."
else
    echo "Invalid MODE: $MODE. Must be 'easy' or 'custom'"
    exit 1
fi