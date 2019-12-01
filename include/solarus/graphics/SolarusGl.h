#pragma once

#ifdef ANDROID
#include <SDL_opengles2.h>
#include <stdio.h>
#define SOLARUS_GL_ES
#else
#include "solarus/third_party/glad/glad.h" // Only include glad to have GL work
#include <SDL_video.h>
#endif

namespace Solarus { namespace Gl {
    inline std::pair<GLint, GLint> getVersion() {
#ifdef ANDROID
      GLint major, minor;
      const char* version = (const char*)glGetString(GL_VERSION);
      sscanf(version,"OpenGL ES %d.%d", &major, &minor);
      return {major, minor};
#else
      GLint major = GLVersion.major; // Using GLVersion from glad
      GLint minor = GLVersion.minor;
      return {major, minor};
#endif
    }

    inline bool load() {
#ifdef ANDROID
        return true;
#elif SOLARUS_GL_ES
        return gladLoadGLES2Loader(SDL_GL_GetProcAddress);
#else
        return gladLoadGLLoader(SDL_GL_GetProcAddress);
#endif
    }

    inline bool has_framebuffer() {
#ifdef SOLARUS_GL_ES
        return true;
#else
        return GLAD_GL_VERSION_3_0 || GLAD_GL_ARB_framebuffer_object;
#endif
    }

    inline bool use_vao() {
#ifdef SOLARUS_GL_ES
        return false;
#else
        return GLAD_GL_VERSION_3_0 || GLAD_GL_ARB_vertex_array_object;
#endif
    }

    inline void DeleteVertexArrays(GLsizei count, GLuint* arrays) {
#ifndef SOLARUS_GL_ES
        glDeleteVertexArrays(count, arrays);
#else
        (void)count;
        (void)arrays;
#endif
    }

    inline void GenVertexArrays(GLsizei count, GLuint* arrays) {
#ifndef SOLARUS_GL_ES
        glGenVertexArrays(count, arrays);
#else
        (void)count;
        (void)arrays;
#endif
    }

    inline void BindVertexArray(GLuint array) {
#ifndef SOLARUS_GL_ES
        glBindVertexArray(array);
#else
        (void)array;
#endif
    }

}}
