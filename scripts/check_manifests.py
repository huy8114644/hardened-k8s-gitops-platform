"""Offline structure checks; semantic behavior is tested by Kyverno CLI."""
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[1]


def main():
    documents = []
    for directory in ("kyverno/policies", "network-policies", "falco/rules"):
        for path in sorted((ROOT / directory).glob("*.yaml")):
            values = list(yaml.safe_load_all(path.read_text()))
            if not values or any(value is None for value in values):
                raise ValueError(f"Empty YAML document: {path}")
            documents.extend((path, value) for value in values)
    names = set()
    for path, value in documents:
        if path.parent.name == "rules":
            assert isinstance(value, list) and all("rule" in rule for rule in value), path
            continue
        identity = (value["kind"], value["metadata"]["name"])
        assert identity not in names, f"Duplicate manifest: {identity}"
        names.add(identity)
        if value["kind"] == "NetworkPolicy":
            assert value["metadata"]["namespace"] == "production", path
    baseline = yaml.safe_load((ROOT / "network-policies/default-deny-all.yaml").read_text())
    assert baseline["spec"]["podSelector"] == {}
    assert set(baseline["spec"]["policyTypes"]) == {"Ingress", "Egress"}
    assert not baseline["spec"].get("ingress") and not baseline["spec"].get("egress")
    print(f"Parsed {len(documents)} configuration files; baseline structure checks passed")


if __name__ == "__main__":
    main()
