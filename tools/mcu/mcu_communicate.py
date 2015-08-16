#!/usr/bin/python

from __future__ import print_function

import sys
import serial
import argparse
import fcntl
import time

def warning(*objs):
    print(*objs, file = sys.stderr)

START_BYTE      = "\xfa"
STOP_BYTE       = "\xfb"
ACK             = "\xfa\x30\x00\x00\x00\x00\xfb"

def check_ack(retval):
    if not retval[-7:] == ACK:
        raise Exception('MCU did not respond with ACK')
    else:
        return retval[:-7]

THERMAL_TABLE   = (
    116, 115, 114, 113, 112, 111, 110, 109,
    108, 107, 106, 105, 104, 103, 102, 101,
    100,  99,  98,  97,  96,  95,  94,  93,
     92,  91,  90,  89,  88,  87,  86,  85,
     84,  83,  82,  81,  80,  79,  78,  77, 
     76,  75,  74,  73,  72,  71,  70,  69,
     68,  67,  66,  65,  65,  64,  63,  62,
     62,  61,  61,  60,  59,  58,  58,  57, 
     56,  56,  55,  54,  54,  53,  52,  52,
     51,  51,  50,  49,  49,  48,  48,  47,
     47,  46,  46,  45,  44,  44,  43,  43,
     42,  42,  41,  41,  40,  40,  39,  39,
     39,  38,  38,  37,  37,  36,  36,  35,
     35,  34,  34,  33,  33,  33,  32,  32,
     31,  31,  30,  30,  30,  29,  29,  28,
     28,  27,  27,  27,  27,  26,  25,  25,
     25,  24,  24,  23,  23,  37,  27,  27,
     25,  25,  25,  24,  24,  23,  23,  22,
     22,  22,  21,  21,  20,  20,  20,  19,
     19,  18,  18,  18,  17,  17,  16,  16,
     16,  15,  15,  14,  14,  14,  13,  13,
     12,  12,  12,  11,  11,  10,  10,   9, 
      9,   9,   8,   8,   7,   7,   7,   6,
      6,   5,   5,   4,   4,   4,   3,   3,
      2,   2,   1,   1,   0,   0,   0,   0,
      0,   0,   0,   0
)

def calculate_cpu_temp(retval):
    retval = check_ack(retval)

    if not retval[0]  == START_BYTE \
    or not retval[1]  == '\x03' \
    or not retval[2]  == '\x08' \
    or not retval[-1] == STOP_BYTE:
        raise Exception('Malformed answer')
    else:
        return THERMAL_TABLE[ ord(retval[5]) ]

COMMANDS = {
    'DEVICE_READY'    : ("\xfa\x03\x01\x00\x00\x00\xfb", check_ack),
    'DEVICE_POWEROFF' : ("\xfa\x03\x03\x01\x01\x14\xfb", check_ack),
    'THERMAL_STATUS'  : ("\xfa\x03\x08\x00\x00\x00\xfb", calculate_cpu_temp),
    'FAN_STOP'        : ("\xfa\x02\x00\x00\x00\x00\xfb", check_ack),
    'FAN_HALF'        : ("\xfa\x02\x00\x01\x00\x00\xfb", check_ack),
    'FAN_FULL'        : ("\xfa\x02\x00\x02\x00\x00\xfb", check_ack),
    'POWER_LED_ON'    : ("\xfa\x03\x06\x01\x00\x01\xfb", check_ack),
    'POWER_LED_OFF'   : ("\xfa\x03\x06\x00\x00\x01\xfb", check_ack),
    'POWER_LED_FLASH' : ("\xfa\x03\x06\x02\x00\x01\xfb", check_ack)
}

UART = '/dev/ttyS1'

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('command', choices = COMMANDS.keys())
    args = parser.parse_args(sys.argv[1:])

    with serial.Serial(UART, 115200, 8, "N", 1, 1) as serial_port:
        while True:
            try:
                fcntl.flock(serial_port.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            except IOError:
                warning('Serial port is busy, waiting 1 second')
                time.sleep(1)
            else:
                break

        cmd_bytes, cmd_func = COMMANDS[args.command]
        serial_port.write( cmd_bytes )
        serial_port.flush()

        retval = ''
        while True:
            buf  = serial_port.read(7)
            if len(buf) == 0:
                break

            retval += buf

        try:
            print(cmd_func(retval))
            sys.exit(0)
        except Exception as e:
            warning(e)
            sys.exit(1)


