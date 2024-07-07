class BASSMusic {
	file = "";
	playingTime = 0.0;
	volume = 0.0;
	looping = false;
	balance = 0.0;

	handle = null;

	constructor(fileName){
		if(!BASS_Init(-1, 44000, 0)) {
			throw "Can't initialize BASS";
		}

		this.handle = BASS_StreamCreateFile(fileName, 0);
		this.file = fileName;
	}


	function play(){
		if(this.handle == 0){
			throw "Can't load file: " + BASS_ErrorGetCode();
		}

		if(this.looping){
			BASS_ChannelFlags(this.handle, BASS_SAMPLE_LOOP, 0);
		}

		BASS_ChannelPlay(this.handle, true);
	}

	function stop() {
		if(this.handle != null) {
			BASS_ChannelStop(this.handle);
		}
	}

	function setVolume(volume) {
		if(volume > 100) volume = 100;

		if(this.handle != null) {
			BASS_ChannelSetAttribute(this.handle, BASS_ATTRIB_VOL, volume * 1.0);
		}
	}

	function isPlaying() {
		if(this.handle != null) {
			local status = BASS_ChannelIsActive(this.handle);
			return status == BASS_ACTIVE_PLAYING;
		}
		return false;
	}

	function release() {
		if(this.handle != null) {
			BASS_StreamFree(this.handle);
			this.handle = null;
		}
		BASS_Free();
	}
}
