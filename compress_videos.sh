#!/bin/bash

# Define directories and report file
high_dir="high"
medium_dir="medium"
low_dir="low"
report_file="compression_report.txt"

# Create directories
mkdir -p "$high_dir" "$medium_dir" "$low_dir"

# Initialize report
echo -e "File Name       | Original Size | High (Size, Time)  | Medium (Size, Time)  | Low (Size, Time)" > "$report_file"
echo -e "------------------------------------------------------------------------------------------------" >> "$report_file"

# Function to get file size
get_size() {
    local file="$1"
    local size
    size=$(ls -lh "$file" | awk '{print $5}')
    echo "$size"
}

# Function to compress video and collect data
compress_video() {
    local input_file="$1"
    local filename=$(basename "$input_file" .mp4)

    # Original size
    local original_size=$(get_size "$input_file")

    # High quality compression
    local start_time_high=$(date +%s)
    local high_output="$high_dir/${filename}_high.mp4"
    ffmpeg -y -i "$input_file" -preset slow -crf 20 -c:v libx264 -vf "format=yuv420p" "$high_output"
    local end_time_high=$(date +%s)
    local high_time_taken=$((end_time_high - start_time_high))
    local high_size=$(get_size "$high_output")

    # Medium quality compression
    local start_time_medium=$(date +%s)
    local medium_output="$medium_dir/${filename}_medium.mp4"
    ffmpeg -y -i "$input_file" -preset medium -crf 24 -c:v libx264 -vf "format=yuv420p" "$medium_output"
    local end_time_medium=$(date +%s)
    local medium_time_taken=$((end_time_medium - start_time_medium))
    local medium_size=$(get_size "$medium_output")

    # Low quality compression
    local start_time_low=$(date +%s)
    local low_output="$low_dir/${filename}_low.mp4"
    ffmpeg -y -i "$input_file" -preset fast -crf 30 -c:v libx264 -vf "format=yuv420p" "$low_output"
    local end_time_low=$(date +%s)
    local low_time_taken=$((end_time_low - start_time_low))
    local low_size=$(get_size "$low_output")

    # Append to report
    printf "%-15s | %-13s | %-18s | %-18s | %-18s\n" "$filename" "$original_size" "$high_size, ${high_time_taken}s" "$medium_size, ${medium_time_taken}s" "$low_size, ${low_time_taken}s" >> "$report_file"
}

# Process all MP4 files
for video_file in *.mp4; do
    compress_video "$video_file"
done

echo "Video compression completed. Report saved to $report_file."
