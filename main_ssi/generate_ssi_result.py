import re
import csv
import os
import argparse


def main():
    parser = argparse.ArgumentParser(description="Generate SSI result.")
    parser.add_argument(
        "--log_file",
        type=str,
        help="The path to the log file.",
        default="sphere2vec_sphereC+model_nabirds_ebird_meta_0.1_Sphere2Vec-sphereC+_inception_v3_0.0005_64_0.0010000_1_512_leakyrelu_none_ratio0.100-random-fix.log",
    )
    args = parser.parse_args()

    log_file_name = os.path.join("..", "models", "ssi", args.log_file)
    print(f"Processing log file: {log_file_name}")

    max_top1_acc = {}

    # Read the log file
    with open(log_file_name, "r") as file:
        log_content = file.read()

    # Use regular expression to find all the SSI parameter blocks
    ssi_blocks = re.findall(
        r"############## SSI Parameters #################\n(.*?)Top 10\tLocEnc acc \(\%\)",
        log_content,
        re.DOTALL,
    )

    # Parse each block to extract Train Sample Ratio, Run Time, and SSI Loop, along with Top 1 accuracies
    for block in ssi_blocks:
        # Extract the Train Sample Ratio, Run Time, and SSI Loop
        params = re.search(
            r"Train Sample Ratio: (.*?)\nRun Time: (.*?)\nSSI Loop: (.*?)\n", block
        )
        # if not block:
        #     print("Empty block found")
        #     continue
        # else:
        #     print("\nCurrent block being processed:", block)

        if params:
            run_time = int(params.group(2))
            ssi_loop = int(params.group(3))
            print(f"\nRun Time: {run_time}, SSI Loop: {ssi_loop}")

            # Initialize the dictionary for the run if not already present
            if run_time not in max_top1_acc:
                max_top1_acc[run_time] = {}

            # Find all Top 1 accuracy values within this block
            top1_accs = re.findall(
                r"Top 1\s+\(.*?\)acc\s\(%\):\s+([\d.]+)", block
            )
            if top1_accs:
                # Convert accuracy values to float and determine the maximum
                top1_accs = [float(acc) for acc in top1_accs]
                max_acc = max(top1_accs)

                # Update the dictionary with the maximum Top 1 accuracy for the current SSI loop
                max_top1_acc[run_time][ssi_loop] = max_acc
                print(f"Max Top 1 accuracy: {max_acc}")
            else:
                print("No Top 1 accuracy found")
        else:
            print("No parameters found")

    subfolder_name = re.search(r"^(.*?)model", args.log_file).group(1)
    subfolder_path = os.path.join("eva_result", subfolder_name)

    # Create the subfolder if it doesn't exist
    os.makedirs(subfolder_path, exist_ok=True)

    # Define the CSV file path inside the subfolder
    def get_csv_file_name(log_file_name):
        parts = log_file_name.split('_')
        return f"{parts[6]}_{parts[2]}_{parts[3]}_{parts[4]}_{parts[-1].replace('.log', '.csv')}"

    # Define the CSV file path inside the subfolder
    csv_file_name = os.path.join(subfolder_path, get_csv_file_name(args.log_file))

    # Write the results to a CSV file
    with open(csv_file_name, "w", newline="") as csvfile:
        fieldnames = ["Run Time / SSI Loop"] + [str(i) for i in range(1, 11)]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for run_time in range(1, 11):
            row = {"Run Time / SSI Loop": run_time}
            for ssi_loop in range(1, 11):
                row[str(ssi_loop)] = max_top1_acc.get(run_time, {}).get(ssi_loop, "")
            writer.writerow(row)

    print(f"Results saved to {csv_file_name}")


if __name__ == "__main__":
    main()
