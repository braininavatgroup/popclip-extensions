# PopClip extensions

Five PopClip extensions, each a `.popclipext` folder that installs by double-click: Seq Clip, Instagram Search, SoundCloud Search, ElevenLabs TTS and ElevenLabs TTS → iCloud. The repo is public, and the README is written for strangers installing them.

The check is `tools/test.sh`: shell syntax for every script and a parse of every config.

PopClip runs a script with a bare PATH and passes the selection and options as `POPCLIP_TEXT` and `POPCLIP_OPTION_*`, so each script sets its own PATH; the TTS scripts already add the Apple silicon and Intel Homebrew paths.

API keys come only from each extension's PopClip option fields, or from `~/.config/tts` when that off-by-default option is on; never bundle, commit or default a key.
