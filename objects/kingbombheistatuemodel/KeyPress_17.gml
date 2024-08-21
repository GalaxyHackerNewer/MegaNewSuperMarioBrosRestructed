/// @DnDAction : YoYo Games.Instances.Destroy_Instance
/// @DnDVersion : 1
/// @DnDHash : 234328F7
/// @DnDApplyTo : {KingBombheiStatueModel}
with(KingBombheiStatueModel) instance_destroy();

/// @DnDAction : YoYo Games.Audio.Play_Audio
/// @DnDVersion : 1.1
/// @DnDHash : 373EEBF2
/// @DnDApplyTo : {KingBombheiStatueModel}
/// @DnDArgument : "soundid" "KingBombheiStatueDestroy"
/// @DnDSaveInfo : "soundid" "KingBombheiStatueDestroy"
with(KingBombheiStatueModel) audio_play_sound(KingBombheiStatueDestroy, 0, 0, 1.0, undefined, 1.0);