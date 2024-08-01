import click
import os
import yaml

# Load the YAML specification
def load_specification(file_path):
    with open(file_path, 'r') as file:
        return yaml.safe_load(file)

# Load file content as plain text
def load_file_content(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        return file.read()

@click.command()
@click.option('--spec_file_path', required=True, help='Path to the YAML specification file.')
@click.option('--base_json_path', default='./', help='Base path where files are stored. Defaults to current directory.')
@click.option('--output_file_path', required=True, help='Path for the output text file.')
def process_files(spec_file_path, base_json_path, output_file_path):
    spec_content = load_specification(spec_file_path)
    filename_to_prompt = {component['file']: component['prompt'] for component in spec_content['components']}
    output_lines = []

    for filename in spec_content['sequence']:
        file_full_path = os.path.join(base_json_path, filename)
        file_content = load_file_content(file_full_path)
        output_lines.append(filename_to_prompt[filename])
        output_lines.append(filename)
        output_lines.append(file_content)
        output_lines.append('')  # Adding a line feed

    # Adding the question to the end of the output
    output_lines.append(spec_content['question'])

    # Saving the result to a text file
    with open(output_file_path, 'w') as output_file:
        output_file.write('\n'.join(output_lines))

    click.echo(f"Text file has been created successfully at {output_file_path}")

if __name__ == '__main__':
    process_files()
