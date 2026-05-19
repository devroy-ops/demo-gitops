import sys

def analyze_logs(file_path):
    error_keywords = ["error", "fail", "exception", "panic"]

    with open(file_path, "r") as f:
        logs = f.read().lower()

    issues = []

    for keyword in error_keywords:
        if keyword in logs:
            issues.append(keyword)

    if issues:
        print("❌ Issues detected in logs:")
        for issue in issues:
            count = logs.count(issue)
            print(f"- {issue} (found {count} times)")
        return False
    else:
        print("✅ Logs are clean")
        return True


if __name__ == "__main__":
    result = analyze_logs("logs.txt")

    if not result:
        print("🚨 STOP DEPLOYMENT")
        sys.exit(1)
    else:
        print("✅ SAFE")
        sys.exit(0)

