import os
import re
from assembler import Binary
from assembler import opcode_dict
from shutil import copyfile

class Compiler:
    labels = []
    instructions = []
    errors = []

    def __init__(self, in_file, out_file):
        self.i_file = self.get_path(in_file)
        self.o_file = self.get_path(out_file)
        self.compile()
  
  
    def get_path(self, relative_path):
        return os.path.join(os.getcwd() , relative_path)
    
    def __str__(self):
        return f"{self.i_file}({self.o_file})"

    def compile(self):
        self.read()
        self.run()
        self.write()

    def read(self):
        with open(self.i_file) as file:
            self.lines = file.readlines()
        
    def write(self):
        with open(self.o_file, "w") as file:
            for i in range(0, len(self.instructions)-1):
                file.write(self.instructions[i]+'\n')
            file.write(self.instructions[len(self.instructions)-1])
        
        file.close()
      
    def run(self):
        self.lines = self.remove(self.lines)
        # for i in self.lines:
        #   print(i)
        # print()
        Binary.Labels = self.labels
        self.instructions = list(map(self.parse, self.lines))
        
    def remove(self, arr):
        arr = list(map(lambda x: x.lower().replace(" ", "").replace("\n", "").replace("\t", ""), arr))
        tmp = []
        newlines_ctr = 0
        
        # Regular expression to verify labels
        start_with = '^[A-Za-z_][A-Za-z0-9_]*'
        end_with = ':$'
        for i in range(len(arr)):
            # Stripe out comments
            x = arr[i].split(';')[0]
        
            if (x.strip()==""): newlines_ctr+=1

            # analize if label
            if re.findall(end_with,x):
                if re.findall(start_with, x):
                    if x in self.labels:
                        self.error.append('Error en linea {}: etiqueta repetida.'.format(i+1))
                    self.labels.append((x.replace(":",""), (i+1)-len(self.labels)-newlines_ctr))
                    continue
                else:
                    self.error.append('Error en linea {}: formato de la etiqueta incorrecto.'.format(i+1))

            ## analize mnemonics
            for key in opcode_dict:
                if (key.lower() == x[0:5]) or (key.lower() == x[0:4]) or (key.lower() == x[0:3]) or (key.lower() == x[0:2]):
                    # remove garbage
                    x = [x[0:len(key)], x[len(key):], i+1]
                    tmp.append(x)
        return tmp
    
    def parse(self, x):
        # print('Entry:\t:', x[0],x[1], x[2])
        instr = Binary(Mnemonic=x[0], Rest=x[1], Line=x[2])
        print(instr)
        return instr.getHex()


in_ = "instrucciones.pedro"
out_ = "ROMdata.dat"
compiler = Compiler(in_, out_)

# copyfile("inst_mem_init.dat", out_)

print("Se ha compilado el programa correctamente")