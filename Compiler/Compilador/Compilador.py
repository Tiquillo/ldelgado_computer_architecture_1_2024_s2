import re

#Diccionario de registros: mapea los nombres de los registros a sus valores correspondientes en binario
#En mayúsculas R0-R23
#Los valores van de 0 a 23
REGISTERS = {
"R0": 0,
"R1": 1,
"R2": 2,
"R3": 3,
"R4": 4,
"R5": 5,
"R6": 6,
"R7": 7,
"R8": 8,
"R9": 9,
"R10": 10,
"R11": 11,
"R12": 12,
"R13": 13,
"R14": 14,
"R15": 15,
"R16": 16,
"R17": 17,
"R18": 18,
"R19": 19,
"R20": 20,
"R21": 21,
"R22": 22,
"R23": 23,
}


#Diccionario de instrucciones: Mapea los códigos de operación de las instrucciones y sus categorías
#En mayúsculas las linstrucciones
INSTRUCCIONES = {
    #Sistema
    "NOP":              {"OP": 0,         "category": "Sistema"},
    "LLAME":            {"OP": 1,         "category": "Sistema"},
    #Datos Registro-Registro
    "SUM":              {"OP": 2,         "category": "Datos_RR"},
    "SUMNOSIGN":        {"OP": 3,         "category": "Datos_RR"},
    "RES":              {"OP": 4,         "category": "Datos_RR"},
    "MULTNOSIGN":       {"OP": 5,         "category": "Datos_RR"},
    "DIV":              {"OP": 6,         "category": "Datos_RR"},
    "COPY":             {"OP": 7,         "category": "Datos_RR"},
    #Datos Registro-Inmediato
    "SUM_I":            {"OP": 8,         "category": "Datos_RI"},
    "SUMNOSIGN_I":      {"OP": 9,         "category": "Datos_RI"},
    "RES_I":            {"OP": 10,        "category": "Datos_RI"},
    "MULTNOSIGN_I":     {"OP": 11,        "category": "Datos_RI"},
    "DIV_I":            {"OP": 12,        "category": "Datos_RI"},
    "DSPLIZQ":          {"OP": 13,        "category": "Datos_RI"},
    "DSPLDER":          {"OP": 14,        "category": "Datos_RI"},
    #Memoria-Registro
    "LOADDIR":          {"OP": 15,        "category": "Memoria_R"},
    "STOREBYTE":        {"OP": 16,        "category": "Memoria_R"},
    "LOADBYTENOSIGN":   {"OP": 17,        "category": "Memoria_R"},
    #Memoria-Registro-Inmediato
    "LOADINM":          {"OP": 18,        "category": "Memoria_R_I"},
    "LOADWORDNOSIGN":   {"OP": 19,        "category": "Memoria_R_I"},
    "STOREWORDNOSIGN":  {"OP": 20,        "category": "Memoria_R_I"},
    "STOREBYTE_I":      {"OP": 21,        "category": "Memoria_R_I"},
    "LOADBYTENOSIGN_I": {"OP": 22,        "category": "Memoria_R_I"},
    #Control
    "SALMAYIG":         {"OP": 23,        "category": "Control"},
    "SALMEN":           {"OP": 24,        "category": "Control"},
    "SAL":              {"OP": 25,        "category": "Control"},
    #Control inmediato
    "SALMAYIG_I":       {"OP": 26,        "category": "Control_I"}
}


def cleanText(text):
    newText = []
    for l in text.split("\n"):
        line = l.split("#")[0]  # Elimina los comentarios, identificados por el carácter "#"
        line = line.replace("\t", " ")  # Reemplaza las tabulaciones por espacios en blanco
        line = line.strip()  # Elimina los espacios en blanco al inicio y final de la línea
        if line == "":
            continue  # Si la línea está vacía, pasa a la siguiente iteración del ciclo
        newText += [re.sub(" +", " ", line)]  # Reemplaza múltiples espacios consecutivos por un solo espacio

    return newText

# Esta función busca las etiquetas en la sección .text y crea un diccionario con las etiquetas y sus índices de línea correspondientes.
# Recibe como parámetro una lista de líneas de texto.
def findBranches(text):
    branches = {}
    i = 0
    in_text_section = False  # Bandera para indicar si estamos en la sección .text

    # Iterar por cada línea del texto
    while i < len(text):
        # Verifica si es el inicio de la sección .text
        if ".text" in text[i]:
            in_text_section = True
            i += 1  # Pasar a la siguiente línea
            continue

        # Si estamos dentro de la sección .text, buscar etiquetas
        if in_text_section:
            # Verifica si la línea contiene una etiqueta (identificada por el carácter ":" al final)
            if ":" in text[i]:
                # Agrega la etiqueta al diccionario branches como una clave y el índice de línea como el valor asociado
                branches[text[i][:-1].strip()] = i
                # Elimina la línea del texto utilizando el método pop()
                text.pop(i)
            else:
                i += 1  # Solo avanzar si no eliminamos una línea

        else:
            # Avanzar el índice si aún no estamos en la sección .text
            i += 1

    # Retorna el diccionario branches que contiene las etiquetas y sus respectivos índices de línea
    #print(branches)
    return branches


# Esta función busca las etiquetas en la sección .data y asigna direcciones base a cada una.
# Recibe como parámetro una lista de líneas de texto.
def findDataLabels(text):
    data_labels = {}
    current_address = 0  # Inicia en 0 o la dirección base que desees para la sección .data
    in_data_section = False  # Bandera para saber si estamos dentro de la sección .data
    i = 0  # Contador para recorrer las líneas

    # Iterar por cada línea del código
    while i < len(text):
        line = text[i]  # Obtener la línea actual

        # Verifica si es el inicio de la sección .data
        if ".data" in line:
            in_data_section = True
            i += 1  # Pasar a la siguiente línea
            continue

        # Si estamos dentro de la sección .data, procesar las etiquetas
        if in_data_section:
            # Verifica si la línea está vacía o es el inicio de otra sección (por ejemplo, .text)
            if line.strip() == "" or line.strip().startswith(".text"):
                break  # Salir del bucle cuando termine la sección .data

            # Verifica si la línea contiene una etiqueta (identificada por el carácter ":" al final)
            if ":" in line:
                # Extrae el nombre de la etiqueta (sin los dos puntos)
                label = line.split(":")[0].strip()
                
                # Agrega la etiqueta al diccionario con la dirección actual
                data_labels[label] = current_address
                
                # Analiza el tipo de datos y ajusta la dirección según el espacio requerido.
                if ".space" in line:
                    # Extrae la cantidad de espacio (en bytes)
                    space_value = int(line.split(".space")[1].strip())
                    current_address += space_value
                elif ".asciiz" in line:
                    # Extrae la cadena de texto y calcula el espacio necesario (incluye el byte nulo '\0')
                    string_value = line.split(".asciiz")[1].strip().strip('"')
                    current_address += len(string_value) + 1  # +1 para el carácter nulo

                # Elimina la línea procesada del texto utilizando pop()
                text.pop(i)  # Eliminar la línea actual procesada
            else:
                i += 1  # Solo avanzar si no eliminamos una línea
        else:
            i += 1  # Avanzar el índice si aún no estamos en la sección .data

    # Retorna el diccionario con las etiquetas y sus direcciones
    return data_labels






def compilador(Codigo):
    
    file = open(Codigo)
    texto = file.read()

    #Limpiar texto de entrada y separarlo en líneas
    texto = cleanText(texto)
    
    
    BRANCHES = findBranches(texto)
    DATALABELS = findDataLabels(texto)
    
    print("\n\nCode Normalized:")
    print(texto)

    print("\n\nData Branches")
    print(BRANCHES)

    print("\n\nData Labels")
    print(DATALABELS)

    print("\n\nEl contenido del texto es:")
    print(texto)

    texto = texto[2:] #Se quitan las etiquetas .data y .text
    
    print("\n\nEl contenido del texto modificado es:")
    print(texto)

    binResult = ""
    output = ""
    for(i, l) in enumerate(texto):
        instruccion = l.split(" ")[0]
        params = "".join(l.split(" ")[1:]).split(",")
        if(not INSTRUCCIONES.get(instruccion)):
            raise Exception("OP NOT RECOGNIZED LINE ({}) '{}'".format(i, l))
        print("\n \n")
        #print(instruccion)
        #print(params)

        result = "Instrucción actual: {1}OP{0}({0:04b})".format(INSTRUCCIONES[instruccion]["OP"], l.ljust(28,"."))

        
        category = INSTRUCCIONES[instruccion]["category"]
        ID = ""
        Rd = ""
        Rs = ""
        Rt = ""
        Inmediato = ""
        Inmediato_1 = ""
        Inmediato_2 = ""

        print("Categoría: ", category ,"   Instrucción: ", instruccion, "   Parámetros: ", params)
        match category:
            case "Sistema":

                if(instruccion == "NOP"):
                    ID = "000000"
                else:
                    ID = "000100"
                
                Inmediato = '0'*26

            case "Datos_RR":
                #print("Datos_RR") 
                if   (instruccion=="SUM"):
                    ID = "010000"
                    Rt = "{0:05b}".format(REGISTERS[params[2]])

                elif (instruccion=="SUMNOSIGN"):
                    ID = "010010"
                    Rt = "{0:05b}".format(REGISTERS[params[2]])

                elif (instruccion=="RES"):
                    ID = "010100"
                    Rt = "{0:05b}".format(REGISTERS[params[2]])

                elif (instruccion=="MULTNOSIGN"):
                    ID = "010110"
                    Rt = "{0:05b}".format(REGISTERS[params[2]])

                elif (instruccion=="DIV"):
                    ID = "011000"
                    Rt = "{0:05b}".format(REGISTERS[params[2]])

                elif (instruccion=="COPY"):
                    ID = "011010"
                    Rt = '0'*5


                Rd = "{0:05b}".format(REGISTERS[params[0]])
                Rs = "{0:05b}".format(REGISTERS[params[1]])
                Inmediato = '0'*11

            case "Datos_RI":
                if   (instruccion=="SUM_I"):
                    ID = "010001"
                    Rs = "{0:05b}".format(REGISTERS[params[1]])
                    Inmediato = "{0:016b}".format(int(params[2]))

                elif (instruccion=="SUMNOSIGN_I"):
                    ID = "010011"
                    Rs = "{0:05b}".format(REGISTERS[params[1]])
                    Inmediato = "{0:016b}".format(int(params[2]))

                elif (instruccion=="RES_I"):
                    ID = "010101"
                    Rs = "{0:05b}".format(REGISTERS[params[1]])
                    Inmediato = "{0:016b}".format(int(params[2]))

                elif (instruccion=="MULTNOSIGN_I"):
                    ID = "010111"
                    Rs = "{0:05b}".format(REGISTERS[params[1]])
                    Inmediato = "{0:016b}".format(int(params[2]))

                elif (instruccion=="DIV_I"):
                    ID = "011001"
                    Rs = "{0:05b}".format(REGISTERS[params[1]])
                    Inmediato = "{0:016b}".format(int(params[2]))
                    
                elif (instruccion=="DSPLIZQ"):
                    ID = "011011"
                    Rs = "{0:05b}".format(REGISTERS[params[1]])
                    Inmediato = "{0:016b}".format(int(params[2]))

                elif (instruccion=="DSPLDER"):
                    ID = "011101"
                    Rs = "{0:05b}".format(REGISTERS[params[1]])
                    Inmediato = "{0:016b}".format(int(params[2]))

                Rd = "{0:05b}".format(REGISTERS[params[0]])
                
            case "Memoria_R":
                if   (instruccion == "LOADDIR"):
                    ID = "100000"
                    Rs = '0'*5
                    Inmediato = "{0:016b}".format(int(DATALABELS[params[1]]))
                    
                elif (instruccion == "STOREBYTE"):
                    ID = "100010"
                    Rs = "{0:05b}".format(REGISTERS[params[1]])
                    Inmediato = '0'*16

                elif (instruccion == "LOADBYTENOSIGN"):
                    ID = "100100"
                    Rs = "{0:05b}".format(REGISTERS[params[1]])
                    Inmediato = '0'*16

                Rd = "{0:05b}".format(REGISTERS[params[0]])

            case "Memoria_R_I":
                if   (instruccion == "LOADINM"):
                    ID = "100001"
                    Inmediato_1 = "{0:014b}".format(int(params[1]))
                    Inmediato_2 = '0'*7

                elif (instruccion == "LOADWORDNOSIGN"):
                    ID = "100011"
                    Inmediato_1 = "{0:014b}".format(int(DATALABELS[params[1]]))
                    Inmediato_2 = "{0:07b}".format(int(params[2]))

                elif (instruccion == "STOREWORDNOSIGN"):
                    ID = "100101"
                    Inmediato_1 = "{0:014b}".format(int(DATALABELS[params[1]]))
                    Inmediato_2 = "{0:07b}".format(int(params[2]))

                elif (instruccion == "STOREBYTE_I"):
                    ID = "100111"
                    Inmediato_1 = "{0:014b}".format(int(DATALABELS[params[1]]))
                    Inmediato_2 = "{0:07b}".format(REGISTERS[params[2]])

                elif (instruccion == "LOADBYTENOSIGN_I"):
                    ID = "101001"
                    Inmediato_1 = "{0:014b}".format(int(DATALABELS[params[1]]))
                    Inmediato_2 = "{0:07b}".format(REGISTERS[params[2]])

                Rd = "{0:05b}".format(REGISTERS[params[0]])

            case "Control":
                if   (instruccion=="SALMAYIG"):
                    ID = "110000"
                    Rd = "{0:05b}".format(REGISTERS[params[0]])
                    Rs = "{0:05b}".format(REGISTERS[params[1]])
                    Inmediato = "{0:016b}".format(BRANCHES[params[2]])


                elif (instruccion=="SALMEN"):
                    ID = "110010"
                    Rd = "{0:05b}".format(REGISTERS[params[0]])
                    Rs = "{0:05b}".format(REGISTERS[params[1]])
                    Inmediato = "{0:016b}".format(BRANCHES[params[2]])

                elif (instruccion=="SAL"):
                    ID = "110100"
                    Rd = '0'*5
                    Rs = '0'*5
                    Inmediato = "{0:016b}".format(BRANCHES[params[0]])

            case "Control_I":
                if   (instruccion == "SALMAYIG_I"):
                    ID = "110001"
                    Rd = "{0:05b}".format(REGISTERS[params[0]])
                    Inmediato_1 = "{0:013b}".format(int(params[1]))
                    Inmediato_2 = "{0:08b}".format(BRANCHES[params[2]])

        output += ID+Rd+Rs+Rt+Inmediato_1+Inmediato_2+Inmediato+"\n"
        print("Equivalente\n" + ID + " " + Rd + " " + Rs + " " + Rt + " " + Inmediato_1 + " " + Inmediato_2 + " " + Inmediato)

    print("La salida completa es:\n" + output)
    # Nombre del archivo .txt
    filename = "outputRAM.txt"
    filename2 = "outputROM.txt"

    # Escribir el contenido de la variable 'output' en el archivo
    with open(filename, 'w') as file:
        file.write(output)

    output = ""
    for item in DATALABELS:
        # Formato binario de 8 bits para cada valor
        binary_value = "{0:014b}".format(DATALABELS[item])
        output += binary_value + "\n"
        #print(f"{item} {DATALABELS[item]} {binary_value}")

    # Muestra el resultado final con los valores separados por un espacio
    print(f"Output completo: {output}")
    with open(filename2, 'w') as file:
        file.write(output) 

    return 0




compilador("algorithm.txt")

