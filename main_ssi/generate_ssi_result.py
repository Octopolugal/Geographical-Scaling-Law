import re
import csv
import os


log_file_name = "sphere2vec_sphereC+model_nabirds_ebird_meta_0.1_Sphere2Vec-sphereC+_inception_v3_0.0005_64_0.0010000_1_512_leakyrelu_none_ratio0.100-random-fix.log"


max_top1_acc = {}
with open(log_file_name, 'r') as file:
    log_content = file.read()

ssi_blocks = re.findall(r'############## SSI Parameters #################(.*?)###############################################', log_content, re.DOTALL)

# Parse each block to extract Train Sample Ratio, Run Time, and SSI Loop, along with Top 1 accuracies
for block in ssi_blocks:
    # Extract the Train Sample Ratio, Run Time, and SSI Loop
    params = re.search(r'Train Sample Ratio: (.*?)\nRun Time: (.*?)\nSSI Loop: (.*?)\n', block)
    if params:
        train_sample_ratio = float(params.group(1))
        run_time = int(params.group(2))
        ssi_loop = int(params.group(3))
        
        # Initialize the dictionary for the run if not already present
        if run_time not in max_top1_acc:
            max_top1_acc[run_time] = {}
        
        # Find all Top 1 accuracy values within this block
        top1_accs = re.findall(r'Top 1\s+\(Epoch \d+\)acc \(%\):\s+([\d.]+)', block)
        if top1_accs:
            # Convert accuracy values to float and determine the maximum
            top1_accs = [float(acc) for acc in top1_accs]
            max_acc = max(top1_accs)
            
            # Update the dictionary with the maximum Top 1 accuracy for the current SSI loop
            max_top1_acc[run_time][ssi_loop] = max_acc

csv_file_name = os.path.splitext(log_file_name)[0] + ".csv"

# Write the results to a CSV file
with open(csv_file_name, 'w', newline='') as csvfile:
    fieldnames = ['Run Time / SSI Loop'] + [str(i) for i in range(1, 11)]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for run_time in range(1, 11):
        row = {'Run Time / SSI Loop': run_time}
        for ssi_loop in range(1, 11):
            row[str(ssi_loop)] = max_top1_acc.get(run_time, {}).get(ssi_loop, "")
        writer.writerow(row)

print(f"Results saved to {csv_file_name}")
