

local ffi = require("ffi")

ffi.cdef[[
    typedef void* HANDLE;
    typedef uint32_t DWORD;
    typedef int BOOL;
    HANDLE OpenProcess(DWORD dwDesiredAccess, BOOL bInheritHandle, DWORD dwProcessId);
    int CloseHandle(HANDLE hObject);
    HANDLE GetModuleHandleA(const char* lpModuleName);
    int VirtualQueryEx(HANDLE hProcess, const void* lpAddress, void* lpBuffer, size_t dwLength);
    int ReadProcessMemory(HANDLE hProcess, const void* lpBaseAddress, void* lpBuffer, size_t nSize, size_t* lpNumberOfBytesRead);
    DWORD GetCurrentProcessId(void);

    typedef struct {
        void* BaseAddress;
        void* AllocationBase;
        DWORD AllocationProtect;
        size_t RegionSize;
        DWORD State;
        DWORD Protect;
        DWORD Type;
    } MEMORY_BASIC_INFORMATION;
]]

function findSignaturesInModule(signatures, moduleName)
    local moduleAddress = ffi.C.GetModuleHandleA(moduleName)
    if moduleAddress == nil then
        return nil, "Module not found"
    end

    local processId = ffi.C.GetCurrentProcessId()
    local hProcess = ffi.C.OpenProcess(0x1F0FFF, 0, processId)
    if hProcess == nil then
        return nil, "Failed to open process"
    end

    local moduleInfo = ffi.new("MEMORY_BASIC_INFORMATION")
    local address = moduleAddress

    local results = {}
    local signatureBytesList = {}

    for _, signature in ipairs(signatures) do
        local signatureBytes = {}
        for byte in signature:gmatch("%S+") do
            if byte == "??" then
                table.insert(signatureBytes, false)
            else
                table.insert(signatureBytes, tonumber(byte, 16))
            end
        end
        table.insert(signatureBytesList, signatureBytes)
    end

    -- print("Searching for signatures:", table.concat(signatures, ", "))
    -- print("Module address:", string.format("%X", tonumber(ffi.cast("intptr_t", moduleAddress))))

    while ffi.C.VirtualQueryEx(hProcess, address, moduleInfo, ffi.sizeof(moduleInfo)) ~= 0 do
        if moduleInfo.State == 0x1000 and (moduleInfo.Protect == 0x20 or moduleInfo.Protect == 0x40) then
            local size = tonumber(moduleInfo.RegionSize)
            local buffer = ffi.new("uint8_t[?]", size)
            local bytesRead = ffi.new("size_t[1]")

            if ffi.C.ReadProcessMemory(hProcess, address, buffer, size, bytesRead) == 0 then
                ffi.C.CloseHandle(hProcess)
                return nil, "Failed to read process memory"
            end

            -- print("Reading memory region:", string.format("%X", tonumber(ffi.cast("intptr_t", address))), "Size:", size)

            for i = 0, size - #signatureBytesList[1] do
                for sigIndex, signatureBytes in ipairs(signatureBytesList) do
                    local found = true
                    for j = 1, #signatureBytes do
                        local byte = buffer[i + j - 1]
                        if signatureBytes[j] ~= false and byte ~= signatureBytes[j] then
                            found = false
                            break
                        end
                    end

                    if found then
                        local offset = tonumber(ffi.cast("intptr_t", address)) - tonumber(ffi.cast("intptr_t", moduleAddress)) + i
                        table.insert(results, {signature = signatures[sigIndex], address = string.format("%s+%X", moduleName, offset), offset = offset})
                    end
                end
            end
        end

        address = ffi.cast("void*", ffi.cast("intptr_t", address) + moduleInfo.RegionSize)
    end

    ffi.C.CloseHandle(hProcess)
    return results
end

local signatures = {
    "D0 94 D0 BE D1 81 D1 82 D1 83 D0 BF D0 BD D0 BE",
    "D0 BE D0 B1 D0 BD D0 BE D0 B2 D0 BB D0 B5 D0 BD D0 B8 D0 B5"
}
local moduleName = "vorbisfile.dll"

local results = findSignaturesInModule(signatures, moduleName)
if results then
    for _, result in ipairs(results) do
        -- print('Found address: ' .. result.address..' | '..moduleName..' | '..result.offset)
        local memory = require("memory")
        memory.setint32(getModuleHandle(moduleName) + result.offset, 0)
    end
else
    -- print('Error: Signatures not found')
end
