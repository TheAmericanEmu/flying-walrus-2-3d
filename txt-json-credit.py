import json
import re

def parse_credits(text: str) -> dict:
    lines = [line.rstrip() for line in text.splitlines() if line.strip()]
    
    result = {
        "The Crew": {
            "Programmers": [],
            "Supporters": [],
            "Play Testers": []
        },
        "assets": {
            "meshes": [],
            "ui": [],
            "sounds": [],
            "fonts": []
        }
    }

    current_section = None
    current_subsection = None

    for line in lines:
        # Detect main sections
        if line.startswith("Crew:"):
            current_section = "crew"
        elif line.startswith("Game Assets:"):
            current_section = "assets"
        elif line.startswith("Meshes:"):
            current_subsection = "meshes"
        elif line.startswith("UI:"):
            current_subsection = "ui"
        elif line.startswith("Sound:"):
            current_subsection = "sounds"
        elif line.startswith("Fonts:"):
            current_subsection = "fonts"
        elif current_section == "crew":
            if "Progamers:" in line or "Programmers:" in line:
                current_subsection = "Programmers"
            elif "Supporters:" in line:
                current_subsection = "Supporters"
            elif "Play Tester" in line:
                current_subsection = "Play Testers"
            else:
                result["The Crew"][current_subsection].append(line.strip())
        elif current_section == "assets":
            if current_subsection == "meshes":
                match = re.match(r'\s*(.+?) by (.+?) \[([^\]]+)\].*?\((https://poly\.pizza/[^\)]+)\)', line)
                if match:
                    name, author, license_, url = match.groups()
                    result["assets"]["meshes"].append({
                        "name": name.strip(),
                        "author": author.strip(),
                        "license": license_.strip(),
                        "url": url.strip()
                    })
            elif current_subsection == "ui":
                if ":" in line:
                    name, author = map(str.strip, line.split(":"))
                    result["assets"]["ui"].append({
                        "name": name,
                        "author": author,
                        "license": "CC BY 4.0",
                        "url": ""
                    })
                elif "PS4 Buttons" in line:
                    result["assets"]["ui"].append({
                        "name": "PS4 Buttons",
                        "author": "ArksDigital",
                        "license": "CC BY 4.0",
                        "url": ""
                    })
            elif current_subsection == "sounds":
                match = re.match(r'\s*(.+?) by (.+?) -- (https://freesound\.org/s/\d+/) -- License: Creative Commons (0|Attribution 4\.0)', line, re.IGNORECASE)
                if match:
                    name, author, url, license_ = match.groups()
                    license_text = "CC0" if license_ == "0" else "CC BY 4.0"
                    result["assets"]["sounds"].append({
                        "name": name.strip(),
                        "author": author.strip(),
                        "license": license_text,
                        "url": url.strip()
                    })
            elif current_subsection == "fonts":
                match = re.match(r'(.+?) by (.+?): (https?://[^\s]+) -- License: (.+)', line)
                if match:
                    name, author, url, license_ = match.groups()
                    result["assets"]["fonts"].append({
                        "name": name.strip(),
                        "author": author.strip(),
                        "license": license_.strip(),
                        "url": url.strip()
                    })
    
    return result


# Usage:
if __name__ == "__main__":
    with open("credits.txt", "r", encoding="utf-8") as f:
        raw_text = f.read()
    
    parsed_data = parse_credits(raw_text)

    with open("credits.json", "w", encoding="utf-8") as out:
        json.dump(parsed_data, out, indent=2)

    print("Parsed JSON written to credits_parsed.json")
