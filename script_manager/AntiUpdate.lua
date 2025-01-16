local memory = require("memory")
memory.setint32(getModuleHandle("vorbisfile.dll") + 0xC65DE0, 0)
memory.setint32(getModuleHandle("vorbisfile.dll") + 0xC65DF1, 0)