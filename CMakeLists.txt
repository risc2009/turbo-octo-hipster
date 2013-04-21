project(shell)

cmake_minimum_required(VERSION 2.8)

find_program(re2c_exe re2c)
if(NOT re2c_exe)
    message(FATAL_ERROR "Can't find re2c.")
endif(NOT re2c_exe)

macro(re2c SOURCE TARGET)
    add_custom_command(
        OUTPUT "${TARGET}"
        COMMAND "${re2c_exe}"
        -s -o "${TARGET}"
        "${SOURCE}"
        DEPENDS "${SOURCE}")
endmacro(re2c)

find_program(lemon_exe lemon)
if(NOT lemon_exe)
    message(FATAL_ERROR "Can't find lemon.")
endif(NOT lemon_exe)

macro(lemon SOURCE_DIR TARGET_DIR FILE)
    add_custom_command(
        OUTPUT "${TARGET_DIR}/${FILE}.y"
	COMMAND "cp" "${SOURCE_DIR}/${FILE}.y" "${TARGET_DIR}/${FILE}.y"
	DEPENDS "${SOURCE_DIR}/${FILE}.y")
    add_custom_command(
        OUTPUT "${TARGET_DIR}/${FILE}.c"
        COMMAND "${lemon_exe}"
        "${TARGET_DIR}/${FILE}.y"
        DEPENDS "${TARGET_DIR}/${FILE}.y")
    add_custom_command(
        OUTPUT "${TARGET_DIR}/${FILE}.cpp"
	COMMAND "cp" "${TARGET_DIR}/${FILE}.c" "${TARGET_DIR}/${FILE}.cpp"
	DEPENDS "${TARGET_DIR}/${FILE}.c")
endmacro(lemon)

re2c(
	"${CMAKE_CURRENT_SOURCE_DIR}/lexcer.re"
	"${CMAKE_CURRENT_BINARY_DIR}/lexcer.cpp"
)

lemon(
	"${CMAKE_CURRENT_SOURCE_DIR}"
	"${CMAKE_CURRENT_BINARY_DIR}"
	"parser"
)

include_directories(
	"${CMAKE_CURRENT_SOURCE_DIR}"
	"${CMAKE_CURRENT_BINARY_DIR}"
)

add_executable(shell
	"${CMAKE_CURRENT_BINARY_DIR}/lexcer.cpp"
	"${CMAKE_CURRENT_BINARY_DIR}/parser.cpp"
	main.cpp
)

include (CTest)

add_test (shellRuns shell 10)

macro (do_test arg result)
  add_test (shellComp${arg} shell ${arg})
  set_tests_properties(shellComp${arg}
    PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endmacro (do_test)

do_test (123456789 "123456789")
do_test (0X123456789ABCDEF "81985529216486895")
do_test (0x123456789ABCDEF "81985529216486895")
do_test (123456789.123 "123456789.123")
do_test (123.123456789 "123.123456789")

do_test (10+10 "20")
do_test (10.1+10.1 "20.2")
do_test (10+10.1 "20.1")
do_test (10.1+10 "20.1")

do_test (10-9 "1")
do_test (10.1-9.1 "1")
do_test (10-9.1 "0.9")
do_test (10.1-9 "1.1")

do_test (10*10 "100")
do_test (10.1*10.1 "102.01")
do_test (10*10.1 "101")
do_test (10.1*10 "101")

do_test (10/5 "2")
do_test (10.1/5.1 "1.98039")
do_test (10/5.1 "1.96078")
do_test (10.1/5 "2.02")

do_test (10%3 "1")
do_test (10.1%5.1 "5")
do_test (10%5.1 "4.9")
do_test (10.1%5 "0.1")

add_test (shellCompA10 shell "(10)")
set_tests_properties(shellCompA10
 PROPERTIES PASS_REGULAR_EXPRESSION "10")
add_test (shellCompA10.1 shell "(10.1)")
set_tests_properties(shellCompA10.1
 PROPERTIES PASS_REGULAR_EXPRESSION "10.1")

do_test (1+2*3 "7")
do_test (1+6/2 "4")
