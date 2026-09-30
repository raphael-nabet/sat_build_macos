import math
import sys
import os

def count_duplicate_folders(folder_path1, folder_path2):
    """
    Counts the number of folders that share the exact same name
    at the top level of two different directories.
    """
    if not os.path.isdir(folder_path1) or not os.path.isdir(folder_path2):
        print("Error: One or both paths are not valid directories.")
        return -1

    folders1 = {name for name in os.listdir(folder_path1) if os.path.isdir(os.path.join(folder_path1, name))}
    folders2 = {name for name in os.listdir(folder_path2) if os.path.isdir(os.path.join(folder_path2, name))}

    duplicates = folders1.intersection(folders2)
    return len(duplicates)


def print_graph(success, failed, count_pip, total):
    if total == 0:
        print("Error: The total cannot equal 0.")
        return
    pct_success = success / total
    pct_pip = count_pip / total

    angle_limite_success = pct_success * 2 * math.pi
    angle_limite_pip = (pct_success + pct_pip) * 2 * math.pi

    char_success = "█"
    char_pip = "▒"
    char_failed = "."
    rayon_x = 14
    rayon_y = 7

    print(f"\n======================== RESULTS ({total} packages) =========================")

    for y in range(-rayon_y, rayon_y + 1):
        ligne = ""
        for x in range(-rayon_x, rayon_x + 1):
            if (x / rayon_x)**2 + (y / rayon_y)**2 <= 1.0:
                angle = math.atan2(-y, x)
                if angle < 0:
                    angle += 2 * math.pi

                if angle <= angle_limite_success:
                    ligne += char_success
                elif angle <= angle_limite_pip:
                    ligne += char_pip
                else:
                    ligne += char_failed 
            else:
                ligne += " "

        if y == -2:
            ligne += f"   [{char_success}] Successful Installation : {success} ({pct_success*100:.1f}%)"
        elif y == 0:
            ligne += f"   [{char_pip}] Pip Installation        : {count_pip} ({pct_pip*100:.1f}%)"
        elif y == 2:
            ligne += f"   [{char_failed}] Failed Installation     : {failed} ({(failed/total)*100:.1f}%)"

        print(ligne)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python chart.py <success_int> <failed_int>")
        sys.exit(1)

    if len(sys.argv) == 3:
        try:
            val_success = int(sys.argv[1])
            total = int(sys.argv[2])
        except ValueError:
            sys.exit(1)

        path_install = str(os.environ.get("INSTALLATION_FOLDER")) + "/INSTALL"
        path_sources = str(os.environ.get("INSTALLATION_FOLDER")) + "/SOURCES"
        val_failed = total - val_success
        success = count_duplicate_folders(path_install, path_sources)
        count_pip = val_success - success
        print_graph(success, val_failed, count_pip, total)
