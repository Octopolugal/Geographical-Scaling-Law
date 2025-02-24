import os
import argparse
import re
import csv

def main():
    parser = argparse.ArgumentParser(description="Generate SSI result.")
    parser.add_argument(
        "--log_folder",
        type=str,
        help="The path to the folder containing the log files.",
        default="../models/ssi/inat17/C",
    )
    args = parser.parse_args()

    log_folder = args.log_folder

    log_files = [f for f in os.listdir(log_folder) if f.endswith(".log") and os.path.isfile(os.path.join(log_folder, f))]

    for log_file_name in log_files:
        log_file_path = os.path.join(log_folder, log_file_name)
        print(f"Processing log file: {log_file_path}")

        max_top1_acc = {}

        with open(log_file_path, "r") as file:
            log_content = file.read()

        # the SSI parameter blocks
        ssi_blocks = re.findall(
            r"############## SSI Parameters #################\n(.*?)Top 10\tLocEnc acc \(\%\)",
            log_content,
            re.DOTALL,
        )

        # Sample Ratio, Run Time, and SSI Loop, along with Top 1 accuracies
        for block in ssi_blocks:
            params = re.search(
                r"Train Sample Ratio: (.*?)\nRun Time: (.*?)\nSSI Loop: (.*?)\n", block
            )

            if params:
                run_time = int(params.group(2))
                ssi_loop = int(params.group(3))

                if run_time not in max_top1_acc:
                    max_top1_acc[run_time] = {}

                top1_accs = re.findall(
                    r"Top 1\s+\(.*?\)acc\s\(%\):\s+([\d.]+)", block
                )
                if top1_accs:
                    # the maximum
                    top1_accs = [float(acc) for acc in top1_accs]
                    #max_acc = max(top1_accs)
                    max_acc = float(top1_accs[-1])

                    max_top1_acc[run_time][ssi_loop] = max_acc
            else:
                print("No parameters found")

        #subfolder_name = re.search(r"^(.*?)model", log_file_name).group(1)
        subfolder_name = 'sphere2vec_sphereC'
        
        subfolder_path = os.path.join("eva_result", subfolder_name)

        # add the subfolder if it doesn't exist
        os.makedirs(subfolder_path, exist_ok=True)
        
        def get_csv_file_name(log_file_name):
            dataset = re.search(r"model_(.*?)_", log_file_name).group(1)
            if dataset == "inat":
                dataset = re.search(r"model_([^_]+_[^_]+)_", log_file_name).group(1).replace('_', '-')
            parts = log_file_name.split('_')
            print(parts[-1])
            if len(parts[-1]) <18:
                return f"{subfolder_name}_{dataset}_ratio1.000-random-fix.csv"
            else:
                return f"{subfolder_name}_{dataset}_{parts[-1].replace('.log', '.csv')}"
        csv_file_name = os.path.join(subfolder_path, get_csv_file_name(log_file_name))

        with open(csv_file_name, "w", newline="") as csvfile:
            fieldnames = ["Run Time / SSI Loop"] + [str(i) for i in range(1, 11)]
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

            writer.writeheader()
            for run_time in range(1, 11):
                row = {"Run Time / SSI Loop": run_time}
                #for ssi_loop in range(1,11):
                ssi_loop = 1
                row[str(ssi_loop)] = max_top1_acc.get(run_time, {}).get(ssi_loop, "")
                writer.writerow(row)

        print(f"Results saved to {csv_file_name}")

if __name__ == "__main__":
    main()
