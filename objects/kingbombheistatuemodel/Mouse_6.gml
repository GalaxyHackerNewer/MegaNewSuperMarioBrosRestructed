/// @DnDAction : YoYo Games.Instances.Destroy_Instance
/// @DnDVersion : 1
/// @DnDHash : 2CD66BFE
instance_destroy();

/// @DnDAction : YoYo Games.Audio.Play_Audio
/// @DnDVersion : 1.1
/// @DnDHash : 62A72F83
/// @DnDArgument : "soundid" "KingBombheiStatueDestroy"
/// @DnDArgument : "gain" "3.0"
/// @DnDSaveInfo : "soundid" "KingBombheiStatueDestroy"
audio_play_sound(KingBombheiStatueDestroy, 0, 0, 3.0, undefined, 1.0);

/// @DnDAction : YoYo Games.Audio.Stop_Audio
/// @DnDVersion : 1
/// @DnDHash : 04AC9E80
/// @DnDArgument : "soundid" "KingBombheiStatueDestroy"
/// @DnDSaveInfo : "soundid" "KingBombheiStatueDestroy"
audio_stop_sound(KingBombheiStatueDestroy);