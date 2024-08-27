#!/bin/bash

# Define the directories for storing the compressed videos
high_dir="high"
medium_dir="medium"
low_dir="low"

# Create the directories if they don't exist
mkdir -p "$high_dir" "$medium_dir" "$low_dir"

# Initialize the report file
report_file="compression_report.txt"
echo -e "File Name       | Original Size | High (Size, Time)  | Medium (Size, Time)  | Low (Size, Time)" > "$report_file"
echo -e "------------------------------------------------------------------------------------------------" >> "$report_file"

# Convert bytes to human-readable format
human_readable_size() {
    echo $(numfmt --to=iec-i --suffix=B --format="%.1f" "$1")
}

# Function to compress video and collect data
compress_video() {
    input_file="$1"
    filename=$(basename "$input_file" .mp4)
    original_size=$(stat -c%s "$input_file")
    orig_size_human=$(human_readable_size "$original_size")

    # Compress with high quality
    start_time_high=$(date +%s)
    high_output="$high_dir/${filename}_high.mp4"
    ffmpeg -y -i "$input_file" -preset slow -crf 18 -c:v libx264 -vf "format=yuv420p" "$high_output" &
    pid_high=$!

    # Compress with medium quality
    start_time_medium=$(date +%s)
    medium_output="$medium_dir/${filename}_medium.mp4"
    ffmpeg -y -i "$input_file" -preset medium -crf 23 -c:v libx264 -vf "format=yuv420p" "$medium_output" &
    pid_medium=$!

    # Compress with low quality
    start_time_low=$(date +%s)
    low_output="$low_dir/${filename}_low.mp4"
    ffmpeg -y -i "$input_file" -preset fast -crf 28 -c:v libx264 -vf "format=yuv420p" "$low_output" &
    pid_low=$!

    # Record the sizes and times when each compression completes
    {
        wait $pid_high
        end_time_high=$(date +%s)
        high_time_taken=$((end_time_high - start_time_high))
        high_size=$(stat -c%s "$high_output")
        high_size_human=$(human_readable_size "$high_size")
    } &

    {
        wait $pid_medium
        end_time_medium=$(date +%s)
        medium_time_taken=$((end_time_medium - start_time_medium))
        medium_size=$(stat -c%s "$medium_output")
        medium_size_human=$(human_readable_size "$medium_size")
    } &

    {
        wait $pid_low
        end_time_low=$(date +%s)
        low_time_taken=$((end_time_low - start_time_low))
        low_size=$(stat -c%s "$low_output")
        low_size_human=$(human_readable_size "$low_size")
    } &

    # Wait for all compressions to complete before recording data
    wait

    # Append data to the report
    printf "%-15s | %-13s | %-18s | %-18s | %-18s\n" "$filename" "$orig_size_human" "$high_size_human, ${high_time_taken}s" "$medium_size_human, ${medium_time_taken}s" "$low_size_human, ${low_time_taken}s" >> "$report_file"
}

# Loop through all MP4 files in the current directory
for video_file in *.mp4; do
    compress_video "$video_file" &
done

wait

echo "Video compression completed. Report saved to $report_file."
