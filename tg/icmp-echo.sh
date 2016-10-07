SRCIP="X"
DSTIP="147.228.52.16"
DATALEN="6"
#default 6
#DATALEN="6"

TYPE=icmp-echo
. ./lib.sh

if [ "$DATALEN" = "P" ]; then
	#tuto simuluje data z prikazu ping
	#timestamp round trip time
	TSRTT=8
	DATALEN=$(($TSRTT+48))
	DATA="0x51,0xcd,drnd(2),drnd(2),drnd(2),0x61,0xa3,0x0b,0x00,0x00,0x00,0x00,0x00,0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1a,0x1b,0x1c,0x1d,0x1e,0x1f,0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2a,0x2b,0x2c,0x2d,0x2e,0x2f,0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,"
else 
	#tuto nahodi do paketu pouze "nejaka data"
	DATA="fill(0x58, $DATALEN),"
fi
CSUMEND=$((42+$DATALEN))


rm -f ${TYPE}.o
cpp \
	-DDSTMAC="$RMAC" \
	-DSRCMAC="$MYMAC" \
	-DSRCIP="$SRCIP" \
	-DDSTIP="$DSTIP" \
	-DDATALEN="$DATALEN" \
	-DDATA="$DATA" \
	-DCSUMEND="$CSUMEND" \
	-DTTL="$TTL" \
${TYPE}.cfg -o - >> ${TYPE}.o
if [ $? != 0 ]; then
	echo "ERROR: cpp failed"
	exit 1
fi

. ./run.sh