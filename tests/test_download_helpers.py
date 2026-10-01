from scripts.download_cms_data import DATASETS, select_csv_distribution


def test_expected_public_datasets_are_configured():
    assert DATASETS["hospital_general_information"]["dataset_id"] == "xubh-q36u"
    assert DATASETS["hospital_readmissions_reduction_program"]["dataset_id"] == "9n3s-kdb3"
    assert DATASETS["timely_effective_care_hospital"]["dataset_id"] == "yv7e-xc69"


def test_select_csv_distribution_prefers_csv_resource():
    metadata = {
        "distribution": [
            {"mediaType": "application/json", "downloadURL": "https://example.test/a.json"},
            {"mediaType": "text/csv", "downloadURL": "https://example.test/a.csv"},
        ]
    }
    selected = select_csv_distribution(metadata)
    assert selected["downloadURL"].endswith("a.csv")


def test_select_csv_distribution_accepts_single_distribution_object():
    selected = select_csv_distribution(
        {"distribution": {"format": "CSV", "downloadURL": "https://example.test/data"}}
    )
    assert selected["downloadURL"] == "https://example.test/data"
