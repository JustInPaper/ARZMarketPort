local memory = require("memory")
memory.setint32(getModuleHandle("vorbisfile.dll") + 0x9A71E8, 0)
memory.setint32(getModuleHandle("vorbisfile.dll") + 0x9A71F9, 0)