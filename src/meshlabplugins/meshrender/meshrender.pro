TEMPLATE      = lib
CONFIG       += plugin
INCLUDEPATH  += ../.. ../../../../sf ../../../../code/lib/glew/include
LIBPATH			 += ../../../../code/lib/glew/lib/
HEADERS       = meshrender.h
SOURCES       = meshrender.cpp
TARGET        = meshrender
DESTDIR       = ../../meshlab/plugins
# the following line is needed to avoid mismatch between 
# the awful min/max macros of windows and the limits max
win32:DEFINES += NOMINMAX
win32:LIBS += glew32.lib

unix{
	QMAKE_CC	 = gcc-3.3
	QMAKE_CXX	 = g++-3.3
	QMAKE_LINK	 = gcc-3.3
	CONFIG		+= warn_off debug_and_release
}

contains(TEMPLATE,lib) {
   CONFIG(debug, debug|release) {
      unix:TARGET = $$member(TARGET, 0)_debug
      else:TARGET = $$member(TARGET, 0)d
   }
}
QT           += opengl
