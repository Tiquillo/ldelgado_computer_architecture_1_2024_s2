import sys

def mif_to_dat(mif_file, dat_file):
    with open(mif_file, 'r') as mif, open(dat_file, 'w') as dat:
        for line in mif:
            if line.strip() and not line.startswith('--'):
                if ':' in line:
                    address, value = line.split(':')
                    value = value.split(';')[0].strip()
                    dat.write(f"{value}\n")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python mif_to_dat.py <input.mif> <output.dat>")
    else:
        mif_to_dat(sys.argv[1], sys.argv[2])