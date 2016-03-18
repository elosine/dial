/*
START ROUTINE
LOOPING SAMPLE PLAYBACK WITH AMPLITUDE TRACKING


*/


(
s.options.numAudioBusChannels = 300;
s.waitForBoot{
	fork{
		var abus = {Bus.audio(s)}!30;
		var kbus = {Bus.control(s)}!30;
		var proc = NetAddr("127.0.0.1", 12321);
		////Groups
		s.sendMsg(\g_new, 300, 1, 1);
		5.do{|ix| s.sendMsg(\g_new, 301+ix, 3, 300+ix)};
		//SYNTHDEFS///////////////////
		SynthDef(\phasorclock, {
			arg dur=10.0, start=0, end=1, abus=99, kbus, t_tr=0, pos=0;
			var index, indexnorm;
			index = Phasor.ar( t_tr, 1.0/(44100.0*dur), start, end, pos );
			Out.ar(abus, index);
			Out.kr(kbus, index);
		}).add;
		SynthDef(\timerobj, {
			arg ibs, st, end, aobs, kobs;
			var in,env,tr;
			in = In.ar(ibs);
			tr = (in>st)*(in<end);
			env = EnvGen.ar(Env.asr(0.0, 1, 0.0, 0),tr);
			Out.ar(aobs, (in*env).poll);
			Out.kr(kobs, in*env);
		}).add;
		SynthDef(\timetest, {
			arg tribs;
			var tr, sig, env;
			tr = In.ar(tribs);
			sig = SinOsc.ar();
			env = EnvGen.ar(Env.asr(0.02, 1, 0.1, 0),tr);
			Out.ar(0, sig*env);
		}).add;
		0.1.wait;
		//OSC DEFS

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
			proc.sendMsg("/kdat", bnum, val);
		}, \c_set);

		OSCdef( \timer, {
			arg msg;
			var ix = msg[1].asInteger;
			var st=msg[2].asFloat;
			var end=msg[3].asFloat;
			s.sendMsg(\s_new, \timerobj, 6000+ix, 0, 301, \ibs, 50, \aobs, 100+ix, \kobs, 100+ix, \st, st, \end, end);
		}, "/timer");

		//Synths
		s.sendMsg(\s_new, \phasorclock, 5000, 0, 300, \abus, 50, \kbus, 0);
	}//end fork
}//end s.waitForBoot

)
s.sendMsg(\s_new, \timerobj, 6000, 0, 301, \ibs, 50, \aobs, 100, \kobs, 100, \st, 0.33, \end, 0.5);

s.sendMsg(\s_new, \timetest, 7001, 0, 302, \tribs, 100);
n = NetAddr("127.0.0.1", 12321);
n.sendMsg("/mktimer",0);

//Audio Busses - 50...
//Control Busses - 0...