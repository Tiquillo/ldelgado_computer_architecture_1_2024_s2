# Diccionario de instrucciones y sus opcodes
INSTRUCTION_SET = {
    # Tipo Sistema (00)
    "NOP": "00000000000000000000000000000000",
    "END": "00000000000000000000000000000001",
    
    # Tipo Datos (01)
    "SUM": "010001",  # Instrucción SUM
    "RES": "010010",  # Instrucción RESTA
    "CR":  "010011",  # Instrucción AND
    "MUL": "010100",  # Instrucción MULTIPLICACIÓN
    "CE":  "010101",  # Instrucción COMPARACIÓN

    # Tipo Memoria (10)
    "DEME": "100001",  # Leer de memoria
    "TOME": "100010",  # Escribir en memoria

    # Tipo Control (11)
    "BRIN": "110001",  # Salto incondicional
    "BETO": "110010",  # Salto condicional
    "BMNQ": "110011",  # Salto negativo
    "BMQ":  "110100"   # Salto positivo
}

# Diccionario de registros
REGISTERS = {
    "R0": "0000",
    "R1": "0001",
    "R2": "0010",
    "R3": "0011",
    "R4": "0100",
    "R5": "0101",
    "R6": "0110",
    "R7": "0111",
    "R8": "1000",
    "R9": "1001",
    "R10": "1010",
    "R11": "1011",
    "R12": "1100",
    "R13": "1101",
    "R14": "1110",
    "R15": "1111"
}

def compile_instruction(instruction):
    parts = instruction.split()
    opcode = parts[0]
    
    if opcode == "NOP" or opcode == "END":
        return INSTRUCTION_SET[opcode]  # Estas instrucciones son directas

    elif opcode in ["SUM", "RES", "CR", "MUL", "CE"]:  # Tipo registro-inmediato
        rd = REGISTERS[parts[1]]  # Registro destino
        rs1 = REGISTERS[parts[2]]  # Primer registro
        imm = format(int(parts[3]), '016b')  # Inmediato en binario de 16 bits
        
        binary_instr = INSTRUCTION_SET[opcode] + rd + rs1 + imm
        return binary_instr

    elif opcode in ["DEME", "TOME"]:  # Instrucciones de memoria
        rd = REGISTERS[parts[1]]  # Registro destino
        rs1 = REGISTERS[parts[2]]  # Registro fuente
        imm = format(int(parts[3]), '016b')  # Inmediato (dirección)
        
        binary_instr = INSTRUCTION_SET[opcode] + rd + rs1 + imm
        return binary_instr

    elif opcode in ["BRIN", "BETO", "BMNQ", "BMQ"]:  # Instrucciones de control
        rs1 = REGISTERS[parts[1]]  # Registro base
        imm = format(int(parts[2]), '016b')  # Dirección de salto en binario
        
        binary_instr = INSTRUCTION_SET[opcode] + rs1 + imm
        return binary_instr

    else:
        raise ValueError(f"Instrucción no soportada: {opcode}")

def write_to_file(binary_instr):
    hex_instr = hex(int(binary_instr, 2))[2:].zfill(8).upper()  # Convertir a hexadecimal
    with open("ROMdata.dat", "a") as file:
        file.write(hex_instr + "\n")

def main():
    # Aquí puedes agregar las instrucciones que quieras compilar
    #leer archivo de texto llamado instrucciones.txt
    instrucciones = []
    with open("instrucciones.txt", "r") as file:
        instrucciones = file.readlines()
    
    for instr in instrucciones:
        binary_instr = compile_instruction(instr)
        write_to_file(binary_instr)
        print(f"Instrucción: {instr} -> {binary_instr}")

if __name__ == "__main__":
    main()
