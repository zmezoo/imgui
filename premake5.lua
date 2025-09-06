local dir = path.getdirectory(_SCRIPT)

project "imgui"
    kind "StaticLib"
    language "C++"
    cppdialect "C++23"
    staticruntime "on"

    binoutputdir = binoutputdir or "%{cfg.buildcfg}-%{cfg.platform}"
    objoutputdir = objoutputdir or "%{cfg.buildcfg}-%{cfg.platform}"

    targetdir("bin/" .. binoutputdir .. "/%{prj.name}")
    objdir("obj/" .. objoutputdir .. "/%{prj.name}")

    links { "glfw", "X11" }
    libdirs { os.findlib("glfw"), os.findlib("X11"), }

    files {
        dir .. "/*",
        dir .. "/backends/imgui_impl_glfw.*",
        dir .. "/misc/cpp/**",
    }

    includedirs {
        dir,                               -- Include the imgui directory itself
        dir .. "/backends",                -- Include the imgui backends
        dir .. "/misc/cpp",  
    }

    filter "platforms:rvulkan"
        files
        {
            dir .. "/backends/imgui_impl_vulkan.*",
        }
        links { "vulkan", }
        libdirs { os.findlib("vulkan"), }

    filter "platforms:opengl3"
        files
        {
            "/backends/imgui_impl_opengl3.*",
        }
        links { "GL", }

    filter "configurations:Debug"
        defines { "DEBUG=1" }
        symbols "On"
        optimize "Off"

    filter "configurations:Release"
        defines { "DEBUG=0" }
        symbols "Off"
        optimize "Speed"

    filter "configurations:Dist"
        defines { "NODEBUG=1" }
        symbols "Off"
        optimize "Speed"