SerialPort.devices;

(
s.options.numAudioBusChannels = 300;
s.waitForBoot{
	fork{
		~ntr = 7;
		~blen = Array.newClear(~ntr);
		~bts = Array.newClear(~ntr);
		~tr = 0;
		~trn = -1;
		~csrn = 2;
		~proc = NetAddr("127.0.0.1", 12321);
		~sdev = "/dev/tty.wchusbserial1a130";
		SerialPort.devices.do{|it| if(it==~sdev, {
			~ino = ArduinoSMS(~sdev, 38400);
			~ino.action = {|msg|
				var smsg = msg.split($:);
				var hdr = smsg[0].asSymbol;
				var val = smsg[1].asInteger;
				switch( hdr,
					//Rotary Encoder 0
					\re0,{

						switch(~csrn,

							0,{
								if (~trn > -1, {~proc.sendMsg("/bhl", ~trn, val)});
							},

							1, {

							}

						);
					},
					//Button 0
					\b0, {
						if(val==1,{

							switch(~csrn,

								0,{
									~tr = ((~tr + val)%(~ntr +1));
									~trn = ~tr - 1;
									~proc.sendMsg("/chtr", ~trn);
								},

								1, {}

							);


						});
					},
					//Button 1
					\b1, {
						//make targets trnum, pos, clr, shp, sz
						if (~trn > -1, {
							if(val==1,{
								~proc.sendMsg("/mktg", ~trn, 0.333, 1, 0, 5);
							});
						});
					},
					//Button 2
					\b2, {
						//change function/highlight
						if (~trn > -1, {
							if(val==1,{
								~csrn = (~csrn + 1)%3;
								~proc.sendMsg("/chgcsr", ~csrn);
							});
						});
					}
				);

			};

		})};
		////Groups
		s.sendMsg(\g_new, 300, 1, 1);
		25.do{|ix| s.sendMsg(\g_new, 301+ix, 3, 300+ix)};

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

		OSCdef( \btgr, {
			arg msg;
			var trnum = msg[1].asInteger;
			var blen = msg[2].asFloat;
			var nbts = msg[3].asInteger;
			~blen[trnum] = blen;
			~bts[trnum] = 0!nbts;
		}, "/btgr");

		OSCdef( \sbtgr, {
			~proc.sendMsg("/gtbtgr");
		}, "/sbtgr");

		OSCdef( \mkbt, {|msg|
			var tr = msg[1].asInteger;
			var btn = msg[2].asInteger;
			(~blen[tr]*btn).postln;
			msg.postln;
			s.sendMsg(\s_new, \timedtrig, 10000+(tr*1000)+btn, 0, 303, \ibs, 50, \obs, 100, \tinorm, ~blen[tr]*btn);
		}, "/mkbt");

		OSCdef( \rmvbt, {|msg|
			var tr = msg[1].asInteger;
			var btn = msg[2].asInteger;
			s.sendMsg(\n_free, 10000+tr);
		}, "/rmvbt");


		//SYNTHDEFS///////////////////
		SynthDef(\phasorclock, {
			arg dur=10.0, start=0, end=1, abus=99, kbus, t_tr=0, pos=0;
			var index, indexnorm;
			index = Phasor.ar( t_tr, 1.0/(44100.0*dur), start, end, pos );
			Out.ar(abus, index);
			Out.kr(kbus, index);
		}).add;

		SynthDef(\timedtrig, {
			arg ibs, obs, tinorm=0.5;
			var ph = In.ar(ibs);
			var tr = (ph>tinorm) * (ph<(tinorm+0.0001));
			Out.ar(obs, tr);
		}).add;

		SynthDef(\tsn, {
			arg ibs, freq=600;
			var tr = In.ar(ibs);
			var env = EnvGen.ar(Env.perc(0.01, 0.01, curve:0), tr);
			Out.ar(0, SinOsc.ar(freq)*env);
		}).add;

		0.2.wait;

		//Synths
		s.sendMsg(\s_new, \phasorclock, 5000, 0, 300, \abus, 50, \kbus, 0, \dur, 16);
		s.sendMsg(\s_new, \tsn, 5100, 0, 305, \ibs, 100);
		//Get Beat Grid from Processing
		~proc.sendMsg("/gtbtgr");
}})


~proc = NetAddr("127.0.0.1", 12321);
~proc.sendMsg("/mktg", 0, 10, 0.333, 1, 0, 15);
~proc.sendMsg("/mktg", 0, 33, 0.77, 1, 0, 4);
~proc.sendMsg("/bhl", 0, 1);
~proc.sendMsg("/gtbtgr");

~p5 = ( 1.0 / (~btgr[0][0]*~btgr[0][1]*~btgr[0][2]) ) * 5;

s.sendMsg(\s_new, \timedtrig, 6000, 0, 302, \ibs, 50, \obs, 100, \tinorm, ~p5);

s.sendMsg(\s_new, \tsn, 6010, 0, 303, \ibs, 100);

s.sendMsg(\n_free, 5100);
s.sendMsg(\n_free, 6010);
s.queryAllNodes

