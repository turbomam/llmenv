import json
import os
import yaml


# Load the YAML specification
def load_specification(file_path):
    with open(file_path, 'r') as file:
        return yaml.safe_load(file)


# Load JSON file content
def load_json_content(file_path):
    with open(file_path, 'r') as file:
        return json.load(file)


# Main function to process the files
def process_files(spec_file_path, base_json_path):
    spec_content = load_specification(spec_file_path)
    filename_to_prompt = {component['file']: component['prompt'] for component in spec_content['components']}
    prompt_content_list = []

    for filename in spec_content['sequence']:
        file_full_path = os.path.join(base_json_path, filename)
        file_content = load_json_content(file_full_path)
        prompt_content_pair = {
            'prompt': filename_to_prompt[filename],
            'content': file_content
        }
        prompt_content_list.append(prompt_content_pair)

    # Adding the question to the final output
    final_output = {
        'prompts': prompt_content_list,
        'question': spec_content['question']
    }

    return final_output


# Example usage
spec_file_path = 'filename-to-content-prompt-specification.yaml'
base_json_path = './'  # Current directory
result = process_files(spec_file_path, base_json_path)

# Saving the result to a JSON file
output_file_path = 'filename-to-content-prompt.json'
with open(output_file_path, 'w') as output_file:
    json.dump(result, output_file, indent=4)

print("JSON file has been created successfully.")
