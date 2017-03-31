OLD_IFS=$IFS
IFS=$(echo -en "\n\b")

count=0
for file_path in $(git ls-files -om --exclude-from=.gitignore --exclude="Pods" | grep ".swift$"); do
    export SCRIPT_INPUT_FILE_$count="$file_path"
    count=$(( count + 1 ))
done
for file_path in $(git diff --cached --name-only | grep ".swift$"); do
    export SCRIPT_INPUT_FILE_$count="$file_path"
    count=$(( count + 1 ))
done

export SCRIPT_INPUT_FILE_COUNT=$count

if (( $count > 0 )); then
    ${PODS_ROOT}/SwiftLint/swiftlint autocorrect --use-script-input-files --config .swiftlint.yml
    ${PODS_ROOT}/SwiftLint/swiftlint lint --use-script-input-files --config .swiftlint.yml
fi

IFS=$OLD_IFS
