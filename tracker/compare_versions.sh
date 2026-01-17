import json

with open("tracker/output/argocd_apps.json") as f:
    apps = json.load(f)

apps = data.get("items", [])

results = []
for app in apps:
    results.append({
        "name": app["metadata"]["name"],
        "current": app["status"]["sync"]["revision"],
        "approved": "TBD"
    })

with open("tracker/output/versions.json", "w") as f:
    json.dump(results, f, indent=2)

