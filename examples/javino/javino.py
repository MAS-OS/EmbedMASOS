import sys
import serial
OP=sys.argv[1]
PORT=sys.argv[2]
try:
    MSG=sys.argv[3]
except:
    MSG=1
try:
    if(OP=='command' or OP=='send'):
        comm = serial.Serial(PORT, '9600', timeout=.1)
        comm.open
        comm.isOpen
        comm.write(bytes(MSG, 'utf-8'))
        comm.close
    elif (OP=='request'):
        comm = serial.Serial(PORT, '9600', timeout=3)
        comm.open
        comm.isOpen
        comm.write(bytes(MSG, 'utf-8'))
        print (comm.readline().decode())
        comm.close
    elif (OP=='listen'):
        comm = serial.Serial(PORT, '9600', timeout=float(MSG))
        comm.open
        comm.isOpen
        print (comm.readline().decode())
        comm.close
    else:
        print("commnad not found!")
except:
	print ("Error connecting on "+PORT)
	sys.exit(1)