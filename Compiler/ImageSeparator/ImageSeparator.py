from PIL import Image
import os

# Abre la imagen original
img = Image.open("image.bmp")  # Cambia esta ruta por la de tu imagen

# Comprueba que la imagen tiene el tamaño correcto
if img.size != (392, 392):
    raise ValueError("La imagen debe ser de 392x392 píxeles.")

# Ruta relativa donde se guardarán las imágenes (subiendo un nivel para ir de ImageSeparator a Proyecto Arqui 1)
output_dir = "../AssemblyMIPS"

# Crea la carpeta si no existe
os.makedirs(output_dir, exist_ok=True)

# Divide la imagen en 16 partes iguales (4x4)
for i in range(4):
    for j in range(4):
        # Define las coordenadas de la parte
        left = j * 98
        upper = i * 98
        right = left + 98
        lower = upper + 98
        
        # Recorta la parte de la imagen
        part = img.crop((left, upper, right, lower))
        
        # Guarda la parte como una nueva imagen en la carpeta especificada
        part.save(os.path.join(output_dir, f"parte_{i*4 + j + 1}.bmp"))  # Nombra las imágenes como parte_1.bmp, parte_2.bmp, etc.

print("Las imágenes han sido divididas y guardadas correctamente en la ruta especificada.")
