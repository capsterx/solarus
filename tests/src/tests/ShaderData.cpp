/*
 * Copyright (C) 2006-2018 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "solarus/core/Debug.h"
#include "solarus/core/CurrentQuest.h"
#include "solarus/core/QuestDatabase.h"
#include "solarus/core/QuestFiles.h"
#include "solarus/core/ResourceType.h"
#include "solarus/graphics/ShaderData.h"
#include "test_tools/TestEnvironment.h"
#include <iostream>

using namespace Solarus;

namespace {

/**
 * \brief Checks reading and writing a shader data file.
 */
void check_shader(TestEnvironment& /* env */, const std::string& shader_id) {

  ShaderData shader_data;
  bool success = false;

  // Import the shader data file.
  std::string file_name = "shaders/" + shader_id + ".dat";
  std::string imported_shader_buffer = QuestFiles::data_file_read(file_name);
  success = shader_data.import_from_buffer(imported_shader_buffer, file_name);
  Debug::check_assertion(success, "Shader import failed");

  // Export it.
  std::string exported_shader_buffer;
  success = shader_data.export_to_buffer(exported_shader_buffer);
  Debug::check_assertion(success, "Shader export failed");

  // Check that the file is identical after import/export.
  if (exported_shader_buffer != imported_shader_buffer) {
    std::cerr << "Shader '" << shader_id << "' differs from the original one after export." << std::endl
        << "*** Original shader file:" << std::endl << imported_shader_buffer << std::endl
        << "*** Exported shader file:" << std::endl << exported_shader_buffer << std::endl;
    Debug::die("Shader '" + shader_id + "': exported file differs from the original one");
  }
}

}

/**
 * \brief Tests reading and writing shader data files.
 */
int main(int argc, char** argv) {

  TestEnvironment env(argc, argv);

  const std::map<std::string, std::string>& shader_elements =
      CurrentQuest::get_database().get_resource_elements(ResourceType::SHADER);
  Debug::check_assertion(!shader_elements.empty(), "No shaders");
  for (const auto& kvp : shader_elements) {
    const std::string& shader_id = kvp.first;
    std::string file_name = "shaders/" + shader_id + ".dat";
    if (QuestFiles::data_file_exists(file_name)) {
      check_shader(env, shader_id);
    }
  }

  return 0;
}
