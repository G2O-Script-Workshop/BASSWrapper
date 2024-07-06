class BASSMusic {
	file = "";
	playingTime = 0.0;
	volume = 0.0;
	looping = false;
	balance = 0.0;

	handle = null;

	constructor(fileName){
		if(!BASS_Init(-1, 44100, BASS_DEVICE_DEFAULT)) {
			throw "Can't initialize BASS";
		}

		this.handle = BASS_StreamCreateFile(false, file, 0, 0, 0);
	}


	function play(){
		if(this.handle != null){
			BASS_StreamFree(this.handle);
		}

		if(this.handle == 0){
			throw "Can't load file: " + BASS_ErrorGetCode();
		}

		if(this.looping){
			BASS_ChannelFlags(this.handle, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
		}

		BASS_ChannelPlay(this.handle, false);
	}

	function stop() {
		if(this.handle != null) {
			BASS_ChannelStop(this.handle);
		}
	}

	function setVolume(volume) {
		if(this.handle != null) {
			BASS_ChannelSetAttribute(this.handle, BASS_ATTRIB_VOL, volume / 100.0);
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
