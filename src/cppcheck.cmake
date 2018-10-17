set(CPPCHECK_INCLUDE_DIRS)
foreach(_include_dir ${INCLUDE_DIRS})
	list(APPEND CPPCHECK_INCLUDE_DIRS "-I${_include_dir} ")
endforeach()

set(CPPCHECK_DEFINES ${GLOBAL_DEFINES})

set(CPPCHECK_SOURCES)
foreach(_source ${CPP_SRCS})
	list(APPEND CPPCHECK_SOURCES "${CMAKE_SOURCE_DIR}/${_source} ")
endforeach()

foreach(_source ${C_SRCS})
	list(APPEND CPPCHECK_SOURCES "${CMAKE_SOURCE_DIR}/${_source} ")
endforeach()

add_custom_target(
    cppcheck
	ALL
    COMMAND cppcheck
		--enable=warning
		--platform=${CMAKE_SOURCE_DIR}/cppcheck_platform_arm.xml
		--inline-suppr
		--output-file=cppcheck.out
		${CPPCHECK_INCLUDE_DIRS}
		${CPPCHECK_DEFINES}
        ${CPPCHECK_SOURCES}
)