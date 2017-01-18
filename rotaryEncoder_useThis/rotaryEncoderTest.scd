SerialPort.listDevices;
(
~rev = [0, 9, 0]!10; //min, max, currval
~ren = 0;
~proc = NetAddr("127.0.0.1", 12321);
~re1func = {|val|
	var min = ~rev[~ren][0];
	var max = ~rev[~ren][1];
	var cv = (~rev[~ren][2] + val).max(min).min(max);
	if(cv != ~rev[~ren][2], {
		~rev[~ren][2] = cv;
		//s.sendMsg(\c_set, ~ren, cv); //set control bus
		~proc.sendMsg("/dial",~ren, cv);
		cv.postln;
	});
};

~ino = ArduinoSMS("/dev/tty.wchusbserial1a130", 38400);
~ino.action = { |msg|

	var smsg = msg.split($:);
	var hd = smsg[0].asSymbol;
	var val = smsg[1].asInteger;
	switch(hd,
		\re0, {~re1func.value(val); val.postln}
	);
};
)