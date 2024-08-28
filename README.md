# Video Compression Script

This script automates the process of compressing video files into three different quality levels (high, medium, and low) using `ffmpeg`. It supports parallel processing to efficiently handle multiple files and compression levels, making it ideal for batch video processing tasks.

## Features

- **Human-Readable Report**: Generates a detailed report with file sizes and compression times in a human-readable format.
- **Customizable Compression Settings**: Configurable compression presets and CRF values for different quality levels.
- **Organized Output**: Saves compressed files in separate directories (`high`, `medium`, `low`) and names them appropriately.

## Requirements

- **`ffmpeg`**: Ensure `ffmpeg` is installed on your system. You can install it via the [FFmpeg official website](https://ffmpeg.org/download.html) or package managers like `apt`, `brew`, etc.

## Usage

1. **Download or Copy the Script**:
   - Download the `compress_videos.sh` script file from this repository or copy its contents.

2. **Make the Script Executable**:
   ```bash
   chmod +x compress_videos.sh
   ```

3. **Prepare Your Videos**:
   Place the video files you want to compress into the same directory as the script.

4. **Run the Script**:
   ```bash
   ./compress_videos.sh
   ```
   The script will process all `.mp4` files in the directory, compress them into three quality levels, and generate a report.

5. **Check the Report**:
   After execution, a report file named `compression_report.txt` will be created in the directory with details about each file's compression.

## Script Details

- **Directories**: 
  - `high/` - For high-quality compressed videos.
  - `medium/` - For medium-quality compressed videos.
  - `low/` - For low-quality compressed videos.

- **Compression Settings**:
  - **High Quality**: Uses `-preset slow` and `-crf 18`.
  - **Medium Quality**: Uses `-preset medium` and `-crf 23`.
  - **Low Quality**: Uses `-preset fast` and `-crf 28`.

- **Output Format**:
  - Files are named based on the original file name with `_high`, `_medium`, or `_low` suffixes.

## Example Report

Here’s an example of how the report looks:

```
File Name       | Original Size | High (Size, Time)  | Medium (Size, Time)  | Low (Size, Time)
------------------------------------------------------------------------------------------------
s4_15mins       | 476 MB        | 285 MB, 40s        | 190 MB, 30s          | 140 MB, 25s
another_video   | 762 MB        | 478 MB, 60s        | 310 MB, 45s          | 245 MB, 35s
```

## Contributing

Feel free to contribute to this project by submitting issues, feature requests, or pull requests. Please ensure that any contributions adhere to the script’s coding standards and functionality.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
