SerialPort.listDevices;

(
s.options.numAudioBusChannels = 300;
s.waitForBoot{
	fork{
		~rev = [0, 9, 0]!10; //min, max, currval
		~ntr = 7;
		~tr = 0;
		~proc = NetAddr("127.0.0.1", 12321);
		////Groups
		s.sendMsg(\g_new, 300, 1, 1);
		5.do{|ix| s.sendMsg(\g_new, 301+ix, 3, 300+ix)};

		~ino = ArduinoSMS("/dev/tty.wchusbserial1a130", 38400);


		////Mechanism for Processing to grab control data
		OSCdef( \getkdata, {
			arg msg;
			var kbus = msg[1].asInteger;
			s.sendMsg(\c_get, kbus);
		}, "/getkdata");

		OSCdef( \kdat, {
			arg msg;
			var bnum=msg[1].asInteger;
			var val=msg[2].asFloat;
			~proc.sendMsg("/kdat", bnum, val);
		}, \c_set);


		//SYNTHDEFS///////////////////
		SynthDef(\phasorclock, {
			arg dur=10.0, start=0, end=1, abus=99, kbus, t_tr=0, pos=0;
			var index, indexnorm;
			index = Phasor.ar( t_tr, 1.0/(44100.0*dur), start, end, pos );
			Out.ar(abus, index);
			Out.kr(kbus, index);
		}).add;

		0.2.wait;

		//Synths
		s.sendMsg(\s_new, \phasorclock, 5000, 0, 300, \abus, 50, \kbus, 0, \dur, 16);
}})


~proc = NetAddr("127.0.0.1", 12321);
~proc.sendMsg("/mktg", 0, 10, 0.333, 1, 0, 15);
~proc.sendMsg("/mktg", 0, 33, 0.77, 1, 0, 4);