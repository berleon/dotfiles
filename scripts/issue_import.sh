#!/bin/bash

# Check if file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <issues_file>"
    exit 1
fi

file="$1"

# Check if file exists
if [ ! -f "$file" ]; then
    echo "Error: File $file does not exist"
    exit 1
fi

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed"
    exit 1
fi

# Check if logged in to GitHub
if ! gh auth status &> /dev/null; then
    echo "Error: Not logged in to GitHub. Please run 'gh auth login' first"
    exit 1
fi

# Function to check if a label exists
check_label() {
    local label="$1"
    gh label list | grep -q "^$label\s"
    return $?
}

# Function to create a label
create_label() {
    local label="$1"
    echo "Creating label: $label"
    gh label create "$label" --color "#0366d6" || {
        echo "Error: Failed to create label '$label'"
        return 1
    }
}

# Extract issues and titles
declare -a issues
declare -a titles
declare -a labels
current_issue=""
issue_count=0

# First pass: collect all unique labels
declare -A unique_labels
while IFS= read -r line || [ -n "$line" ]; do
    if [[ "$line" =~ ^\[(.*?)\] ]]; then
        IFS=',' read -ra LABEL_ARRAY <<< "${BASH_REMATCH[1]}"
        for label in "${LABEL_ARRAY[@]}"; do
            # Trim whitespace
            label=$(echo "$label" | xargs)
            unique_labels["$label"]=1
        done
    fi
done < "$file"

# Show all unique labels found
echo "Found the following labels:"
echo "-------------------------"
declare -a missing_labels
for label in "${!unique_labels[@]}"; do
    echo "- $label"
    if ! check_label "$label"; then
        missing_labels+=("$label")
    fi
done
echo "-------------------------"

# If there are missing labels, ask to create them
if [ ${#missing_labels[@]} -gt 0 ]; then
    echo -e "\nThe following labels do not exist:"
    for label in "${missing_labels[@]}"; do
        echo "- $label"
    done
    read -p "Create all missing labels? (y/n): " answer
    if [[ $answer =~ ^[Yy]$ ]]; then
        echo "Creating labels..."
        for label in "${missing_labels[@]}"; do
            if create_label "$label"; then
                echo "Successfully created label: $label"
            fi
        done
    else
        echo "Label creation skipped"
        exit 0
    fi
else
    echo "All labels already exist"
fi

# Reset file reading to collect issues
while IFS= read -r line || [ -n "$line" ]; do
    if [[ "$line" == "---"* ]]; then
        if [ ! -z "$current_issue" ]; then
            issues[$issue_count]="$current_issue"
            # Get the first line as title
            first_line=$(echo "$current_issue" | head -n1)
            # Extract label from brackets and clean title
            if [[ $first_line =~ ^\[(.*?)\] ]]; then
                labels[$issue_count]="${BASH_REMATCH[1]}"
                titles[$issue_count]="${first_line#*] }"
            else
                labels[$issue_count]=""
                titles[$issue_count]="$first_line"
            fi
            ((issue_count++))
        fi
        current_issue=""
    else
        if [ -z "$current_issue" ]; then
            current_issue="$line"
        else
            current_issue="${current_issue}"$'\n'"$line"
        fi
    fi
done < "$file"

# Add the last issue if exists
if [ ! -z "$current_issue" ]; then
    issues[$issue_count]="$current_issue"
    first_line=$(echo "$current_issue" | head -n1)
    if [[ $first_line =~ ^\[(.*?)\] ]]; then
        labels[$issue_count]="${BASH_REMATCH[1]}"
        titles[$issue_count]="${first_line#*] }"
    else
        labels[$issue_count]=""
        titles[$issue_count]="$first_line"
    fi
    ((issue_count++))
fi

# Show all titles with labels
echo -e "\nFound the following issues:"
echo "-------------------------"
for i in "${!titles[@]}"; do
    if [ -n "${labels[$i]}" ]; then
        echo "$((i+1)). [${labels[$i]}] ${titles[$i]}"
    else
        echo "$((i+1)). ${titles[$i]}"
    fi
done
echo "-------------------------"

# Ask for confirmation to import all issues
read -p "Import all these issues? (y/n): " import_answer
if [[ $import_answer =~ ^[Yy]$ ]]; then
    echo "Importing issues..."
    for i in "${!issues[@]}"; do
        title="${titles[$i]}"
        # Get everything except the first line as body
        body=$(echo "${issues[$i]}" | tail -n +2)
        label_arg=""

        if [ -n "${labels[$i]}" ]; then
            echo "Creating issue: [${labels[$i]}] $title"
            # Handle multiple labels separated by commas
            IFS=',' read -ra LABEL_ARRAY <<< "${labels[$i]}"
            for label in "${LABEL_ARRAY[@]}"; do
                # Trim whitespace
                label=$(echo "$label" | xargs)
                label_arg="$label_arg --label $label"
            done
        else
            echo "Creating issue: $title"
        fi

        gh issue create --title "$title" $label_arg --body "$body"
        echo "Issue created successfully!"
    done
    echo -e "\nImport process completed!"
else
    echo "Import cancelled"
fi