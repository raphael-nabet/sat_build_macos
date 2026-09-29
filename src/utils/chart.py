import math
import sys

def print_graph(success, failed, total):
    if total == 0:
        print("Error: The total cannot equal 0.")
        return

    pct_success = success / total
    angle_limite = pct_success * 2 * math.pi

    char_success = "█"
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
                
                ligne += char_success if angle <= angle_limite else char_failed
            else:
                ligne += " "
        
        if y == -1:
            ligne += f"   [{char_success}] Successful Installation : {success} ({pct_success*100:.1f}%)"
        elif y == 1:
            ligne += f"   [{char_failed}] Failed Installation : {failed} ({(failed/total)*100:.1f}%)"
            
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

        val_failed = total - val_success
        print_graph(val_success, val_failed, total)
