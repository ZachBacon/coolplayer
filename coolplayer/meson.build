project('coolplayer', 'c',
    version : '2.20.0',
    license : 'GPL-2.0-or-later',
    default_options : ['warning_level=3', 'c_std=c11'])

cc = meson.get_compiler('c')

vorbisdep = dependency('vorbis', static : true)
vorbisfiledep = dependency('vorbisfile', static : true)
oggdep = dependency('ogg', static : true)
maddep = dependency('mad', static : true)
zlibdep = dependency('zlib', static : true)
winmm = cc.find_library('winmm')
comctl32 = cc.find_library('comctl32')
wininet = cc.find_library('wininet')
dsound = cc.find_library('dsound')

wrc = find_program('windres')
res_ext = '.o'
wrc_generator = generator(wrc,
output    : [ '@BASENAME@' + res_ext ],
arguments : [ '-i', '@INPUT@', '-o', '@OUTPUT@' ])

coolres = wrc_generator.process('coolplayer.rc')

coolsrc = files([
    'about.c',
    'bitmap2region.c',
    'CLV_ListView.c',
    'CompositeFile.c',
    'CPI_CircleBuffer.c',
    'CPI_Equaliser_Basic.c',
    'CPI_ID3_Genres.c',
    'CPI_Image.c',
    'CPI_Indicators.c',
    'CPI_Interface.c',
    'CPI_InterfacePart.c',
    'CPI_InterfacePart_CommandButton.c',
    'CPI_InterfacePart_Indicator.c',
    'CPI_Keyboard.c',
    'CPI_Player.c',
    'CPI_Player_Callbacks.c',
    'CPI_Player_CoDec_MPEG.c',
    'CPI_Player_CoDec_OGG.c',
    'CPI_Player_CoDec_WAV.c',
    'CPI_Player_CoDec_WinAmpPlugin.c',
    'CPI_Player_Engine.c',
    'CPI_Player_FileAssoc.c',
    'CPI_Player_Output_DirectSound.c',
    'CPI_Player_Output_File.c',
    'CPI_Player_Output_Wave.c',
    'CPI_Playlist.c',
    'CPI_Playlist_Callbacks.c',
    'CPI_PlaylistItem.c',
    'CPI_PlaylistWindow.c',
    'CPI_Stream.c',
    'CPI_Stream_Internet.c',
    'CPI_Stream_LocalFile.c',
    'CPI_Verbs.c',
    'CPSK_Skin.c',
    'DLG_Find.c',
    'main.c',
    'options.c',
    'profile.c',
    'RotatingIcon.c',
    'shwapi.c',
    'skin.c',
    'stdafx.c',
    'String.c',
    'WindowsOS.c'
])

coolplayer_exe = executable('coolplayer', coolsrc, coolres, dependencies : [zlibdep, oggdep, vorbisdep, vorbisfiledep, maddep, winmm, comctl32, wininet, dsound])