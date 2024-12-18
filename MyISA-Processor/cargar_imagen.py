from PIL import Image
import numpy as np

MAX_SIZE = 2**16

## Genera el archivo .mif para cargar los datos de la imagen en la ROM
def generate_mif_file(grey_image_array):
    image_width = len(grey_image_array[0])
    image_depth = len(grey_image_array)

    print("Width: " + str(image_width))
    print("Depth: " + str(image_depth))

    string_datos = "-- Imagen Generada\n\n"
    string_datos += "WIDTH=" + str(32) + ";\n" + "DEPTH=" + str(MAX_SIZE) + ";\n\n"
    string_datos += "ADDRESS_RADIX=UNS;\nDATA_RADIX=HEX;\n\n"

    string_datos += "CONTENT BEGIN\n"

    #for i in range(image_depth/4):
    #    for j in range(image_width/4):
    #        string_datos += str(i*image_width/4 + j) + " : "
    #        #string_datos += format(int(grey_image_array[i][j]), '08x') + ";\n"
    #        string_datos += hex(grey_image_array[i][j])[2:] + hex(grey_image_array[i+1][j+1])[2:] + hex(grey_image_array[i+2][j+2])[2:] + hex(grey_image_array[i+3][j+3])[2:] + ";\n"
    i = 0
    j = 0
    for add in range(int(image_depth/4 * image_width/4)):
        temp_string = ""
        for k in range(4):
            temp_string += hex(int(grey_image_array[i][j]))[2:]
            j += 1
            if j == image_width:
                j = 0
                i += 1
        string_datos += str(add) + " : " + temp_string + ";\n"

    if (image_depth * image_width < MAX_SIZE):
        string_datos += "[" + str(image_depth * image_width) + ".." + str(MAX_SIZE - 1) + "] : 00 ; \n"

    string_datos += "END;\n"

    with open("./image_hex_data.mif", "w") as mif_file:
        mif_file.write(string_datos)


## Guarda la matriz en una imagen en escala de grises
def save_grey_image(grey_image_array, name):
    grey_image = Image.fromarray(grey_image_array)
    grey_image = grey_image.convert("L")
    grey_image.save(name + ".jpg")


## Convierte una imagen a una matriz de numpy en escala de grises, rango [0 (negro), 255 (blanco)]
def convert(file_name):
    image = Image.open(file_name)
    #new_image = image.resize((256, 256))
    image_array = np.array(image)
    grey_image_array = np.empty([len(image_array), len(image_array[0])])

    for i in range(len(image_array)):
        for j in range(len(image_array[i])):
            blue = image_array[i, j, 0]
            green = image_array[i, j, 1]
            red = image_array[i, j, 2]

            grey_scale_value = blue * 0.114 + green * 0.587 + red * 0.299
            grey_image_array[i, j] = grey_scale_value
    
    return grey_image_array
    


    
grey_image_array = convert('entrada.jpg')

save_grey_image(grey_image_array, "nombre")
generate_mif_file(grey_image_array)