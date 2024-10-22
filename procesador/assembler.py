from enum import Enum

class Type(Enum):
    Sistema = '00'
    Datos    = '01'
    Memoria  = '10'
    Control = '11'

types_dict =	{
    Type.Sistema : ['nop', 'com', 'end'],
    Type.Datos : ['sum','res','mul','ce','cr'],
    Type.Memoria : ['tome','deme'],
    Type.Control : ['beto','brin','bmnq','bmq'] 
}


opcode_dict =	{
    "nop" : '00',
    "com" : '01',
    "end" : '10',
    
    "sum" : '000',
    "res" : '001',
    "cr" : '010',
    "mul" : '011',
    "ce" : '100',
    
    "deme" : '0',
    "tome" : '1',
    
    "brin" : '00',
    "beto" : '01',
    "bmnq" : '10',
    "bmq" : '11'
}

getbinary = lambda x, n: format(x, 'b').zfill(n)

regs_dict =	{
    "r0"  : '0000',
    "r1"  : '0001',
    "r2"  : '0010',
    "r3"  : '0011',
    "r4"  : '0100', 
    "r5"  : '0101',
    "r6"  : '0110', 
    "r7"  : '0111',
    "r8"  : '1000'
}

class Binary:
    imm_size = 18
    reg_size = 4
    Labels = []

    def __init__(self, Mnemonic, Rest, Line):
        self.Line = Line
        self.Mnemonic = Mnemonic
        self.Rest = Rest
        self.Bin = '0'*32

        self.analize()
    
    def __str__(self):
        self.__repr__()
        return "" 

    def __repr__(self):
        print('\n➤ line :',self.Line,'\t',self.Mnemonic.upper(),self.Rest)
        
        try:
        
            match self.Type:
                case Type.Sistema:
                    print('  size :', len(self.Bin),'\t',self.Bin[0:2],self.Bin[2],self.Bin[3:])

                case Type.Datos:
                    if (self.I == '1'):
                        print('  size :', len(self.Bin),'\t',self.Bin[0:2],self.Bin[2:5],self.Bin[5:6],self.Bin[6:10], self.Bin[10:14], self.Bin[14:])
                    else:
                        print('  size :', len(self.Bin),'\t',self.Bin[0:2],self.Bin[2:5],self.Bin[5:6],self.Bin[6:10], self.Bin[10:14], self.Bin[14:18], self.Bin[18:])
                    
                case Type.Memoria:
                    print('  size :', len(self.Bin),'\t',self.Bin[0:2],self.Bin[2:3],self.Bin[3:6],self.Bin[6:10], self.Bin[10:14], self.Bin[14:]) 
                        
                case Type.Control:
                    print('  size :', len(self.Bin),'\t',self.Bin[0:2],self.Bin[2:4],self.Bin[4:6],self.Bin[6:14], self.Bin[14:])
                
            print('\t\t',self.getHex())
            return ""
        except:
            print('\t\tERROR')
            return ""
    def getHex(self):
        hstr = '%0*X' % ((len(self.Bin) + 3) // 4, int(self.Bin, 2))
        return hstr
    def analize(self):
        # Get Type
        for key in types_dict: # analizar en cada uno de los tipos.
            if self.Mnemonic in types_dict[key]: # si se encuentra dentro del array.
                self.Type = key
                break
        # Get Mnemonic
        self.Opcode = opcode_dict[self.Mnemonic]
        # Actuar de acuerdo con el tipo.
        try :
            match self.Type:
                case Type.Sistema:
                    self.sistema()
                case Type.Datos:
                    self.data()
                case Type.Memoria:
                    self.memory()
                case Type.Control:
                    self.control()
            return
        except:
            print('Error en linea {}: No se ha encontrado mnemonico \'{}\'.'.format(self.Line, self.Mnemonic.upper()))
            return    
    def sistema(self):
        self.Bin = self.Type.value + self.Opcode + '00' + ('0' * (25-0+1))

    def data(self):
        regs = self.Rest.split(',')

        if (len(regs) == 2):
            return self.data_special_case_2reg(regs)
        
        self.Rd = regs_dict[regs[0]]
        self.Rs1 = regs_dict[regs[1]]
        if ('#' in regs[2]):
            self.I = '1'
            self.Imm = getbinary(int(regs[2][1:]), self.imm_size)
            print(self.Imm)
        else:
            self.I = '0'
            self.Rs2 = regs_dict[regs[2]]
        
        if (self.I == '1'):
            self.Bin = self.Type.value + self.Opcode + self.I + self.Rd + self.Rs1 + self.Imm
        else:
            self.Bin = self.Type.value + self.Opcode + self.I + self.Rd + self.Rs1 + self.Rs2 + ('0' * (13-0+1)) 
    
    def data_special_case_2reg(self, regs):
        self.Rs1  = '0'*(self.reg_size)
        self.Rd  = '0'*(self.reg_size) 
        
        # Si el operando 2 es un inmediato, es decir CR con imm y CE con imm.
        if ('#' in regs[1]): 
            self.I = '1'
            self.Imm = getbinary(int(regs[1][1:]), self.imm_size)

            if (self.Mnemonic == 'cr'):
                self.Rd = regs_dict[regs[0]]
            elif (self.Mnemonic == 'ce'):
                self.Rs1 = regs_dict[regs[0]]
            self.Bin = self.Type.value + self.Opcode + self.I + self.Rd + self.Rs1 + self.Imm

        else:
            self.I = '0'
            self.Rs2  = regs_dict[regs[1]]

            if (self.Mnemonic == 'cr'):
                print('Es cr')
                self.Rd = regs_dict[regs[0]]
            elif (self.Mnemonic == 'ce'):
                self.Rs1 = regs_dict[regs[0]]
            elif (self.Mnemonic == 'pinto'):
                self.Rs1 = regs_dict[regs[0]]
            self.Bin = self.Type.value + self.Opcode + self.I + self.Rd + self.Rs1 + self.Rs2 + ('0' * (13-0+1))
    def memory(self):
        regs = self.Rest.replace("[","").replace("]","").split(',')

        # (tres registros)
        self.Imm = getbinary(0, self.imm_size) if (len(regs) == 2) else getbinary(int(regs[2][1:]), self.imm_size)
        self.Rs1  = regs_dict[regs[1]]
        self.Rd  = regs_dict[regs[0]]
        self.Bin = self.Type.value + self.Opcode + '000' + self.Rd + self.Rs1 + self.Imm 
    
    def control(self):
        result = [tup for tup in self.Labels if tup[0] == self.Rest]
        if (result == []):
            print('Error en linea {}: No se ha encontrado la etiqueta \'{}\'.'.format(self.Line, self.Rest))
        position = (result[0][1]*4) - 4
        self.Imm = getbinary(int(position), self.imm_size)
        self.Bin = self.Type.value + self.Opcode + '00' + ("0" * (25-18+1)) + self.Imm
    
    def printing(self):
        print(self.Opcode)
        print(self.Imm)
        print(self.Rd)
        print(self.Ra)
