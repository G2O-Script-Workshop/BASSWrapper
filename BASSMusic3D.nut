class BASSMusic3D {
	file = "";
	playingTime = 0.0;
	volume = 0.0;
	looping = false;

	radius = 0.0;
	coneAngle = 0.0;
	reverbLevel = 0.0;

	vobTarget = null;
	playerTarget = null;

	handle = null;

	constructor(fileName){
		if(!BASS_Init(-1, 44100, 0)) {
			throw "Can't initialize BASS with 3D support";
		}

		this.handle = BASS_StreamCreateFile(fileName, 0);
		this.file = fileName;
	}


	function play(){
		if(this.handle == 0){
			throw "Can't load file: " + BASS_ErrorGetCode();
		}

		if(this.looping){
			BASS_ChannelFlags(this.handle, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
		}

		this.apply3DAttributes();
		BASS_ChannelPlay(this.handle, true);
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

	function apply3DAttributes() {
        if (this.handle != null) {
            BASS_ChannelSet3DAttributes(
                this.handle,
                -1,
                this.radius > 0 ? 0 : this.radius,
                this.radius,
                this.coneAngle,
                -1,
                this.reverbLevel
            );
        }
    }

	function setVobTarget(vob){
		this.vobTarget = vob;
		setTargetVob(vob);
	}

	function setPlayerTarget(playerId){
		this.playerTarget = playerId;
		setTargetPlayer(playerId);
	}

	function release() {
		if(this.handle != null) {
			BASS_StreamFree(this.handle);
			this.handle = null;
		}
		BASS_Free();
	}
}