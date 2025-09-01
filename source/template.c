/****************************************************************************
 * OGG Playback example
 * Tantric 2009
 ***************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <gccore.h>
#include <wiiuse/wpad.h>
#include <asndlib.h>

#include "oggplayer.h"

// include generated header
#include "sample_ogg.h"
#include "BloodIntro_ogg.h"
#include "BootIntro_ogg.h"
#include "FnafMusicBox_ogg.h"
#include "MLFTJetTurtle_ogg.h"
#include "MLFTPeachCastle_ogg.h"
#include "NNFBFSS_ogg.h"
#include "SM64HACKSM64LADFILESELECTBYKAZEEMANUAR_ogg.h"
#include "SMOMainTheme_ogg.h"
#include "SMOSteamGardens_ogg.h"
#include "SpaghettiKingdom_ogg.h"

static void *xfb = NULL;
static GXRModeObj *rmode = NULL;

//---------------------------------------------------------------------------------
int main(int argc, char **argv) {
//---------------------------------------------------------------------------------

	// Initialise the video system
	VIDEO_Init();

	// Initialise the attached controllers
	WPAD_Init();

	// Initialise the audio subsystem
	ASND_Init();

	// Obtain the preferred video mode from the system
	// This will correspond to the settings in the Wii menu
	rmode = VIDEO_GetPreferredMode(NULL);

	// Allocate memory for the display in the uncached region
	xfb = MEM_K0_TO_K1(SYS_AllocateFramebuffer(rmode));

	// Initialise the console, required for printf
	console_init(xfb,20,20,rmode->fbWidth,rmode->xfbHeight,rmode->fbWidth*VI_DISPLAY_PIX_SZ);

	// Set up the video registers with the chosen mode
	VIDEO_Configure(rmode);

	// Tell the video hardware where our display memory is
	VIDEO_SetNextFramebuffer(xfb);

	// Make the display visible
	VIDEO_SetBlack(false);

	// Flush the video register changes to the hardware
	VIDEO_Flush();

	// Wait for Video setup to complete
	VIDEO_WaitVSync();
	if(rmode->viTVMode&VI_NON_INTERLACE) VIDEO_WaitVSync();


	// The console understands VT terminal escape codes
	// This positions the cursor on row 2, column 0
	// we can use variables for this with format codes too
	// e.g. printf ("\x1b[%d;%dH", row, column );
	printf("\x1b[2;0H");

	printf("Playing samples OGG file...Press HOME to exit.\n");

	// An array of song data to make it easier to cycle through them
	typedef struct {
		const void *data;
		s32 size;
		const char *name;
	} Song;

	Song songs[] = {
		{sample_ogg, sample_ogg_size, "sample_ogg"},
		{BloodIntro_ogg, BloodIntro_ogg_size, "BloodIntro_ogg"},
		{BootIntro_ogg, BootIntro_ogg_size, "BootIntro_ogg"},
		{FnafMusicBox_ogg, FnafMusicBox_ogg_size, "FnafMusicBox_ogg"},
		{MLFTJetTurtle_ogg, MLFTJetTurtle_ogg_size, "MLFTJetTurtle_ogg"},
		{MLFTPeachCastle_ogg, MLFTPeachCastle_ogg_size, "MLFTPeachCastle_ogg"},
		{NNFBFSS_ogg, NNFBFSS_ogg_size, "NNFBFSS_ogg"},
		{SM64HACKSM64LADFILESELECTBYKAZEEMANUAR_ogg, SM64HACKSM64LADFILESELECTBYKAZEEMANUAR_ogg_size, "SM64HACKSM64LADFILESELECTBYKAZEEMANUAR_ogg"},
		{SMOMainTheme_ogg, SMOMainTheme_ogg_size, "SMOMainTheme_ogg"},
		{SMOSteamGardens_ogg, SMOSteamGardens_ogg_size, "SMOSteamGardens_ogg"},
		{SpaghettiKingdom_ogg, SpaghettiKingdom_ogg_size, "SpaghettiKingdom_ogg"}
	};

	int num_songs = sizeof(songs) / sizeof(songs[0]);
	int current_song_index = 0;

	printf("Now playing: %s\n", songs[current_song_index].name);
	PlayOgg(songs[current_song_index].data, songs[current_song_index].size, 10, OGG_ONE_TIME);

	while(1) {
		// Call WPAD_ScanPads each loop, this reads the latest controller states
		WPAD_ScanPads();

		// Check the status of the current song
		if (StatusOgg() == OGG_STATUS_EOF) {
			// The current song has finished, move to the next one
			current_song_index++;
			if (current_song_index >= num_songs) {
				current_song_index = 0; // Loop back to the first song
			}

			// Play the next song
			printf("Now playing: %s\n", songs[current_song_index].name);
			PlayOgg(songs[current_song_index].data, songs[current_song_index].size, 10, OGG_ONE_TIME);
		}

		// WPAD_ButtonsDown tells us which buttons were pressed in this loop
		// this is a "one shot" state which will not fire again until the button has been released
		u32 pressed = WPAD_ButtonsDown(0);

		// We return to the launcher application via exit
		if ( pressed & WPAD_BUTTON_HOME ) {
			break;
		}

		// Wait for the next frame
		VIDEO_WaitVSync();
	}

	StopOgg();
	return 0;
}