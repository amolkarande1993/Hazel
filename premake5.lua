workspace "Hazel"
	architecture "x86_64"

	configurations {"Debug", "Release","Dist"}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

project "Hazel"
	location "Hazel"
	kind "SharedLib"
	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-Intermediate/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	} 

	pchheader "hzpch.h"
	pchsource "Hazel/src/hzpch.cpp"
	includedirs 
	{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include"
	}

	filter "system.windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "10.0.16299.0"

		postbuildcommands
		{
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
		}

		filter "configurations:Debug"
		 defines {"HZ_DEBUG", "HZ_PLATFORM_WINDOWS","HZ_BUILD_DLL"}
		 symbols "On"

		filter "configurations:Release"
		 defines {"HZ_RELEASE", "HZ_PLATFORM_WINDOWS","HZ_BUILD_DLL"}
		 optimize "On" 
		
		filter "configurations:Dist"
		 defines {"HZ_DIST", "HZ_PLATFORM_WINDOWS","HZ_BUILD_DLL"}
		 optimize "On"

project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-Intermediate/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"Hazel/vendor/spdlog/include",
		"Hazel/src"
	}

	links
	{
		"Hazel"
	}

	filter "system.windows"
	 	cppdialect "C++17"
	 	staticruntime "On"
	 	systemversion "10.0.16299.0"

	filter "configurations:Debug"
		defines {"HZ_DEBUG","HZ_PLATFORM_WINDOWS"}
		symbols "On"

	filter "configurations:Release"
		defines {"HZ_RELEASE","HZ_PLATFORM_WINDOWS"}
		optimize "On"

	filter "configurations:Dist"
		defines {"HZ_DIST","HZ_PLATFORM_WINDOWS"}
		optimize "On"



