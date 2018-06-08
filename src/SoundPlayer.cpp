#include "SoundPlayer.h"

#include "ErrorHandler.h"

SoundPlayer::SoundPlayer() {}
SoundPlayer::~SoundPlayer() {}

bool SoundPlayer::Init() {
	if (!SDL_WasInit(SDL_INIT_AUDIO)) {
		if (SDL_InitSubSystem(SDL_INIT_AUDIO)) { 
			LOG_ERROR("Unable to initialize the Sound subsystem: " + std::string(SDL_GetError()));
			return false;
		}
	}
	int mixerflags = MIX_INIT_OGG | MIX_INIT_MP3; 
	int initted = Mix_Init(mixerflags);
	if (mixerflags & initted != mixerflags) {
		LOG_ERROR("Unable to initialize the SDL Mixer: " + std::string(Mix_GetError()));
		return false;
	}

	if (Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048)==-1) {
		LOG_ERROR("Unable to open the Sound Mixer: " + std::string(Mix_GetError()));
		return false;
	}

	return true;
}

bool SoundPlayer::PlaySFX(Sound* soundfx, bool loop = false) {
	if ((Mix_PlayChannel(-1, soundfx, loop ? -1 : 0)) < 0) {
		LOG_ERROR("Unable to play sound effect: " + std::string(Mix_GetError()));
		return false;
	}
	return true;
}

void SoundPlayer::PlayBGM(Music* music, bool loop) {
	if (Mix_PlayMusic(music, loop ? -1 : 0) < 0) {
		LOG_ERROR("Unable to play song: " + std::string(Mix_GetError()));

	} 
}

void SoundPlayer::Clean() {
	Mix_CloseAudio();
	SDL_QuitSubSystem(SDL_INIT_AUDIO);
	Mix_Quit();
}