#!/bin/bash

L10N_DIR="./content/ko/"

#for L10N_FILE_PATH in $(find ./content/ko -name '*.md'); do  # - to add other file extention ( -or -name '*.doc')
#    echo "Localized file path: $FILE" 
#    echo "Original file path: ./content/en${FILE#./content/ko}"
#    echo "Check outdated by git diff --name-only"
#    git diff --name-only dev-ko main -- ./content/en${FILE#./content/ko}
#done

for L10N_FILE_PATH in $(find ${L10N_DIR} -name '*.md'); do
    echo "(DEBUG) L10N_FILE_PATH: ${L10N_FILE_PATH}"

    # Note - extracting a pattern-based substring (https://stackoverflow.com/a/19482947)
    FILE_PATH="${L10N_FILE_PATH#${L10N_DIR}}"
#    FILE_DIR="${FILE_PATH%/*}"
    FILE_DIR=$(dirname ${FILE_PATH})
    FILE_NAME=$(basename ${FILE_PATH})

    echo "(DEBUG) FILE_PATH: ${FILE_PATH}"
    echo "(DEBUG) FILE_DIR: ${FILE_DIR}"
    echo "(DEBUG) FILE_NAME: ${FILE_NAME}"
    echo "(DEBUG) Localized file path: $L10N_FILE_PATH"
    echo "(DEBUG) Original file path: ./content/en/${FILE_PATH}"

    mkdir -p ./outdated/${FILE_DIR}

    # Actually compare between the old and lastest English terms and log diff in the file
    if [[ -f "./content/en/${FILE_PATH}" ]]; then
        # File exists
        git diff ${OLD_BRANCH}..${LATEST_BRANCH} -- ./content/en/${FILE_PATH} > temp.diff

	# if changed (temp.diff is NOT EMPTY.)
        if [[ -s "temp.diff" ]]; then
            echo "(DEBUG) ${FILE_PATH} is outdated."
            mv temp.diff ./outdated/${FILE_PATH}
        fi

    else
        echo "(DEBUG) ${FILE_PATH} dose not exist."
        # File dose not exist (e.g, changed, renamed or removed)
        echo "Could not find ${FILE_PATH} in content/en/" > ./outdated/${FILE_PATH}
        echo "Need to check if it has been changed, renamed or removed" >> ./outdated/${FILE_PATH}
    fi
done
