# Generated Makefile -- DO NOT EDIT!

CC=C:/Users/Player/MagicLeap/mlsdk/v0.19.0/tools/toolchains/bin/aarch64-linux-android-clang
COMPILER_PREFIX=
CXX=C:/Users/Player/MagicLeap/mlsdk/v0.19.0/tools/toolchains/bin/aarch64-linux-android-clang++
ExampleMusicProvider_BASE=C:/Users/Player/Desktop/MagicLeap_Test/Assets/MagicLeap/BackgroundMusicExample
ExampleMusicProvider_CPPFLAGS=-I$(MLSDK)/include -DML_DEFAULT_LOG_TAG=\"ExampleMusicProvider\"
ExampleMusicProvider_CXXFLAGS=--sysroot=$(MLSDK)/lumin -march=armv8-a -mcpu=cortex-a57+crypto -fPIE -fpic -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -Wa,--noexecstack -Wformat -Werror=format-security -Wno-invalid-command-line-argument -Wno-unused-command-line-argument -g -fno-limit-debug-info -O0 -std=c++11 -nostdinc++ -I$(MLSDK)/lumin/stl/libc++/include
ExampleMusicProvider_LDFLAGS=-Wl,-unresolved-symbols=ignore-in-shared-libs --sysroot=$(MLSDK)/lumin -pie -Wl,--gc-sections -Wl,-z,nocopyreloc -Wl,--warn-shared-textrel -Wl,--fatal-warnings -Wl,--build-id -no-canonical-prefixes -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now -Wl,--enable-new-dtags '-Wl,-rpath=$$ORIGIN' -g -L$(MLSDK)/lumin/stl/libc++/lib
ExampleMusicProvider_LIBS=-L$(MLSDK)/lib/lumin -Wl,--no-as-needed -Wl,--start-group -Bdynamic -lc -lc++_shared -landroid_support -lml_musicservice -lml_musicservice_provider -lml_mediacodec -lml_mediaextractor -lml_mediaformat -lml_mediacodeclist -lml_mediaerror -lml_graphics -lml_perception_client -lml_input -lml_lifecycle -lml_ext_logging -lEGL -lGLESv2 -lGLESv3 -lm -Wl,--end-group
ExampleMusicProvider_OUTPUT=C:/Users/Player/Desktop/MagicLeap_Test/$(SPEC)
HOST=win64
LINKER_PREFIX=
MLSDK=C:/Users/Player/MagicLeap/mlsdk/v0.19.0
OBJCOPY=C:/Users/Player/MagicLeap/mlsdk/v0.19.0/tools/toolchains/bin/aarch64-linux-android-objcopy.exe
RM=rm
SPEC=debug_lumin_clang-3.8_aarch64
STRIP=C:/Users/Player/MagicLeap/mlsdk/v0.19.0/tools/toolchains/bin/aarch64-linux-android-strip.exe

$(ExampleMusicProvider_OUTPUT)/ExampleMusicProvider : $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/ExampleMusicProvider.cpp.o $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/DecoderContext.cpp.o $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/Utility.cpp.o $(ExampleMusicProvider_BASE)/ExampleMusicProvider.mabu $(MLSDK)/.metadata/components/ml_sdk.comp $(MLSDK)/.metadata/components/ml_sdk_common.comp $(MLSDK)/tools/mabu/data/components/OpenGL.comp $(MLSDK)/tools/mabu/data/components/stdc++.comp $(MLSDK)/tools/mabu/data/configs/debug.config $(MLSDK)/tools/mabu/data/options/debug/on.option $(MLSDK)/tools/mabu/data/options/magicleap.option $(MLSDK)/tools/mabu/data/options/optimize/off.option $(MLSDK)/tools/mabu/data/options/package/debuggable/on.option $(MLSDK)/tools/mabu/data/options/runtime/shared.option $(MLSDK)/tools/mabu/data/options/warn/on.option
	$(INFO) \[ExampleMusicProvider\]\ Linking\ program\ 'ExampleMusicProvider'...
	$(ECHO) cd $(ExampleMusicProvider_OUTPUT) && $(LINKER_PREFIX) $(CC) -o ExampleMusicProvider obj.ExampleMusicProvider/ExampleMusicProvider.cpp.o obj.ExampleMusicProvider/DecoderContext.cpp.o obj.ExampleMusicProvider/Utility.cpp.o $(ExampleMusicProvider_LIBS) $(ExampleMusicProvider_LDFLAGS)
	$(ECHO) $(OBJCOPY) --only-keep-debug $(ExampleMusicProvider_OUTPUT)/ExampleMusicProvider $(ExampleMusicProvider_OUTPUT)/ExampleMusicProvider.sym
	$(ECHO) $(OBJCOPY) --add-gnu-debuglink $(ExampleMusicProvider_OUTPUT)/ExampleMusicProvider.sym $(ExampleMusicProvider_OUTPUT)/ExampleMusicProvider $(ExampleMusicProvider_OUTPUT)/ExampleMusicProvider
	$(ECHO) $(STRIP) --strip-unneeded $(ExampleMusicProvider_OUTPUT)/ExampleMusicProvider

$(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/ExampleMusicProvider.cpp.o : $(ExampleMusicProvider_BASE)/ExampleMusicProvider.cpp $(ExampleMusicProvider_BASE)/ExampleMusicProvider.mabu $(MLSDK)/.metadata/components/ml_sdk.comp $(MLSDK)/.metadata/components/ml_sdk_common.comp $(MLSDK)/tools/mabu/data/components/OpenGL.comp $(MLSDK)/tools/mabu/data/components/stdc++.comp $(MLSDK)/tools/mabu/data/configs/debug.config $(MLSDK)/tools/mabu/data/options/debug/on.option $(MLSDK)/tools/mabu/data/options/magicleap.option $(MLSDK)/tools/mabu/data/options/optimize/off.option $(MLSDK)/tools/mabu/data/options/package/debuggable/on.option $(MLSDK)/tools/mabu/data/options/runtime/shared.option $(MLSDK)/tools/mabu/data/options/warn/on.option
	$(INFO) \[ExampleMusicProvider\]\ Compiling\ 'ExampleMusicProvider.cpp'...
	$(ECHO) $(COMPILER_PREFIX) $(CXX) -c $(ExampleMusicProvider_BASE)/ExampleMusicProvider.cpp -o $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/ExampleMusicProvider.cpp.o -MD -MP -MF $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/ExampleMusicProvider.cpp.d $(ExampleMusicProvider_CPPFLAGS) $(ExampleMusicProvider_CXXFLAGS)
	$(ECHO) echo $(ExampleMusicProvider_BASE)/ExampleMusicProvider.cpp : >> $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/ExampleMusicProvider.cpp.d

-include $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/ExampleMusicProvider.cpp.d
$(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/DecoderContext.cpp.o : $(ExampleMusicProvider_BASE)/DecoderContext.cpp $(ExampleMusicProvider_BASE)/ExampleMusicProvider.mabu $(MLSDK)/.metadata/components/ml_sdk.comp $(MLSDK)/.metadata/components/ml_sdk_common.comp $(MLSDK)/tools/mabu/data/components/OpenGL.comp $(MLSDK)/tools/mabu/data/components/stdc++.comp $(MLSDK)/tools/mabu/data/configs/debug.config $(MLSDK)/tools/mabu/data/options/debug/on.option $(MLSDK)/tools/mabu/data/options/magicleap.option $(MLSDK)/tools/mabu/data/options/optimize/off.option $(MLSDK)/tools/mabu/data/options/package/debuggable/on.option $(MLSDK)/tools/mabu/data/options/runtime/shared.option $(MLSDK)/tools/mabu/data/options/warn/on.option
	$(INFO) \[ExampleMusicProvider\]\ Compiling\ 'DecoderContext.cpp'...
	$(ECHO) $(COMPILER_PREFIX) $(CXX) -c $(ExampleMusicProvider_BASE)/DecoderContext.cpp -o $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/DecoderContext.cpp.o -MD -MP -MF $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/DecoderContext.cpp.d $(ExampleMusicProvider_CPPFLAGS) $(ExampleMusicProvider_CXXFLAGS)
	$(ECHO) echo $(ExampleMusicProvider_BASE)/DecoderContext.cpp : >> $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/DecoderContext.cpp.d

-include $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/DecoderContext.cpp.d
$(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/Utility.cpp.o : $(ExampleMusicProvider_BASE)/Utility.cpp $(ExampleMusicProvider_BASE)/ExampleMusicProvider.mabu $(MLSDK)/.metadata/components/ml_sdk.comp $(MLSDK)/.metadata/components/ml_sdk_common.comp $(MLSDK)/tools/mabu/data/components/OpenGL.comp $(MLSDK)/tools/mabu/data/components/stdc++.comp $(MLSDK)/tools/mabu/data/configs/debug.config $(MLSDK)/tools/mabu/data/options/debug/on.option $(MLSDK)/tools/mabu/data/options/magicleap.option $(MLSDK)/tools/mabu/data/options/optimize/off.option $(MLSDK)/tools/mabu/data/options/package/debuggable/on.option $(MLSDK)/tools/mabu/data/options/runtime/shared.option $(MLSDK)/tools/mabu/data/options/warn/on.option
	$(INFO) \[ExampleMusicProvider\]\ Compiling\ 'Utility.cpp'...
	$(ECHO) $(COMPILER_PREFIX) $(CXX) -c $(ExampleMusicProvider_BASE)/Utility.cpp -o $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/Utility.cpp.o -MD -MP -MF $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/Utility.cpp.d $(ExampleMusicProvider_CPPFLAGS) $(ExampleMusicProvider_CXXFLAGS)
	$(ECHO) echo $(ExampleMusicProvider_BASE)/Utility.cpp : >> $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/Utility.cpp.d

-include $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/Utility.cpp.d

ExampleMusicProvider-prebuild :: 

ExampleMusicProvider-postbuild :: 

ExampleMusicProvider-clean :: 
	$(INFO) Cleaning\ ExampleMusicProvider...
	$(ECHO) $(RM) -rf $(ExampleMusicProvider_OUTPUT)/ExampleMusicProvider $(ExampleMusicProvider_OUTPUT)/ExampleMusicProvider.sym $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/ExampleMusicProvider.cpp.o $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/ExampleMusicProvider.cpp.d $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/DecoderContext.cpp.o
	$(ECHO) $(RM) -rf $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/DecoderContext.cpp.d $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/Utility.cpp.o $(ExampleMusicProvider_OUTPUT)/obj.ExampleMusicProvider/Utility.cpp.d $(ExampleMusicProvider_OUTPUT)/bin/libc++_shared.so

ExampleMusicProvider-all :: -make-directories ExampleMusicProvider-prebuild $(ExampleMusicProvider_OUTPUT)/ExampleMusicProvider ExampleMusicProvider-postbuild

PROJECT=ExampleMusicProvider

