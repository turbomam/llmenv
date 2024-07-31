import pprint

import requests
import xmltodict


def fetch_biosample_xml(accessions):
    url = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi"
    params = {
        'db': 'biosample',
        'id': ','.join(accessions),
        'rettype': 'xml',  # 'api_key': 'YOUR_API_KEY'  # Optional: Replace 'YOUR_API_KEY' with your actual NCBI API key

    }
    response = requests.get(url, params=params)
    if response.status_code == 200:
        return response.text
    else:
        return None


def convert_xml_to_dict(xml_data):
    try:
        data_dict = xmltodict.parse(xml_data)
        return data_dict
    except Exception as e:
        print(f"Error parsing XML: {e}")
        return None


# Example usage
accession_list = [
    'SAMN37862744',
    'SAMN37862743',
    'SAMN37862742',
    'SAMN37862741',
    'SAMN37862740',
    'SAMN37862739',
    'SAMN37862738',
    'SAMN37862737',
    'SAMN37862736',
    'SAMN37862735',
    'SAMN37862734',
    'SAMN37862733',
    'SAMN37862732',
    'SAMN37862731',
    'SAMN37862730',
    'SAMN37862729',
    'SAMN37862728',
    'SAMN37862727',
    'SAMN37862726',
    'SAMN37862725',
    'SAMN37862724',
    'SAMN37862723',
    'SAMN37862722',
    'SAMN37862721',
    'SAMN37862720',
    'SAMN37862719',
    'SAMN37862718',
    'SAMN37862717',
    'SAMN37862716',
    'SAMN37862715',
    'SAMN37862714',
    'SAMN37862713',
    'SAMN37862712',
    'SAMN37862711',
    'SAMN37862710',
    'SAMN37862709',
    'SAMN37862708'
]

xml_data = fetch_biosample_xml(accession_list)
if xml_data:
    biosample_dict = convert_xml_to_dict(xml_data)
    pprint.pprint(biosample_dict)
else:
    print("Failed to fetch data")
