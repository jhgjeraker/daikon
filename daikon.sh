#!/bin/bash

# Get the absolute path of the script.
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# Activate Python environment.
source "$SCRIPT_DIR/venv/bin/activate"

tmpfile='/tmp/daikon'
model="gpt-3.5-turbo"

# Check if there is at least one argument
if [ $# -lt 1 ]; then
    echo "Error: At least one argument is required"
    echo "Usage: $0 command [some message with spaces ...]"
    exit 1
fi

# Get the required command argument
command="$1"

# Remove the first argument from the argument list
shift

# Combine all remaining arguments into a single string
message="$*"
echo "$message" > $tmpfile

# Define the model functions
completion() {
    openai api completions.create \
        --model text-davinci-003 \
        --prompt "$(cat $tmpfile)" \
        --temperature 0.7 \
        --max-tokens 256 \
        --stream
    echo ""
}

chat_completion() {
    openai api chat_completions.create \
        --model gpt-3.5-turbo \
        --message user "$(cat $tmpfile)" \
        --temperature 0.7 \
        --max-tokens 256
    echo ""
}

jisho_api() {
    jisho search word "$(cat $tmpfile)"
}

# Define an associative array mapping model names to their functions
declare -A model_map
model_map=( ["gpt-3.5-turbo"]=chat_completion ["text-davinci-003"]=completion )

# Get the list of valid models from the keys of the associative array
valid_models=( "${!model_map[@]}" )

# Function to check if the provided model is valid
is_valid_model() {
    local input_model="$1"
    for valid_model in "${valid_models[@]}"; do
        if [[ "$input_model" == "$valid_model" ]]; then
            return 0
        fi
    done
    return 1
}

if ! is_valid_model "$model"; then
    echo "Invalid model: $model"
    echo "Valid models: ${valid_models[*]}"
    exit 1
fi

if [[ "$message" == "ocr" ]]; then
    maim -s --hidecursor /tmp/capture.png
    ocr_text=$(echo "<args>" | nc 127.0.0.1 9929)
    echo "$ocr_text" > $tmpfile
    nvim $tmpfile
fi

if [[ "$command" == "jisho" ]]; then
    res=$(jisho_api)
elif [[ "$command" == "llm" ]]; then
    res=$(${model_map["$model"]})
else
    echo 'Usage: >> jisho|llm ocr|message'
fi

echo "$res"