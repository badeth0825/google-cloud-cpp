# ~~~
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ~~~

include(ExternalProjectHelper)

if (NOT TARGET nlohmann-json-project)
    # Give application developers a hook to configure the version and hash
    # downloaded from GitHub.
    set(GOOGLE_CLOUD_CPP_NLOHMANN_JSON_URL
        "https://github.com/nlohmann/json/archive/v3.4.0.tar.gz")
    set(GOOGLE_CLOUD_CPP_NLOHMANN_JSON_SHA256
        "c377963a95989270c943d522bfefe7b889ef5ed0e1e15d535fd6f6f16ed70732")

    set_external_project_build_parallel_level(PARALLEL)
    set_external_project_vars()

    if ("${CMAKE_VERSION}" VERSION_LESS 3.8)
        if (WIN32)
            # patch may not be installed on Windows. It might be easier to
            # upgrade CMake on that platform though.
            message(FATAL_ERROR "Super builds on WIN32 require CMake >= 3.8."
                                " Please upgrade your CMake version.")
        endif ()
        # nlohmann_json requires CMake >= 3.8, apparently to use the cxx_std_11
        # property on its targets. We patch the CMakeLists.txt file to disable
        # this feature. It is useful but using C++11 is a documented
        # requirement.
        message(
            "nlohmann_json CMakeLists.txt file needs a patch ${CMAKE_CURRENT_LIST_DIR}/nlohmann_json.patch001"
        )
        set(GOOGLE_CLOUD_CPP_NLOHMANN_JSON_PATCH_COMMAND
            "patch" "-p1" "<"
            "${CMAKE_CURRENT_LIST_DIR}/nlohmann_json.patch001")
    else ()
        message(
            "nlohmann_json CMakeLists.txt file will NOT need a patch ${CMAKE_VERSION}"
        )
        set(GOOGLE_CLOUD_CPP_NLOHMANN_JSON_PATCH_COMMAND "")
    endif ()
    include(ExternalProject)
    ExternalProject_Add(
        nlohmann-json-project
        EXCLUDE_FROM_ALL ON
        PREFIX "${CMAKE_BINARY_DIR}/external/nlohmann_json"
        INSTALL_DIR "${GOOGLE_CLOUD_CPP_EXTERNAL_PREFIX}"
        URL ${GOOGLE_CLOUD_CPP_NLOHMANN_JSON_URL}
        URL_HASH SHA256=${GOOGLE_CLOUD_CPP_NLOHMANN_JSON_SHA256}
        LIST_SEPARATOR |
        CMAKE_ARGS ${GOOGLE_CLOUD_CPP_EXTERNAL_PROJECT_CMAKE_FLAGS}
                   -DCMAKE_PREFIX_PATH=${GOOGLE_CLOUD_CPP_PREFIX_PATH}
                   -DCMAKE_INSTALL_RPATH=${GOOGLE_CLOUD_CPP_INSTALL_RPATH}
                   -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                   -DBUILD_TESTING=OFF
        PATCH_COMMAND "${GOOGLE_CLOUD_CPP_NLOHMANN_JSON_PATCH_COMMAND}"
        BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> ${PARALLEL}
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON)
endif ()