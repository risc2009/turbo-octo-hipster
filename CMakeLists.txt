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
ENABLE_TESTING()

macro (do_test num arg result)
  add_test (shellComp${num} shell ${arg})
  set_tests_properties(shellComp${num}
    PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endmacro (do_test)

add_test (shellRuns shell 10)
do_test (11 123456789 "123456789")
do_test (12 0X123456789ABCDEF "81985529216486895")
do_test (13 0x123456789ABCDEF "81985529216486895")
do_test (14 123456789.123 "123456789.123")
do_test (15 123.123456789 "123.123456789")

do_test (21 10+10 "20")
do_test (22 10.1+10.1 "20.2")
do_test (23 10+10.1 "20.1")
do_test (24 10.1+10 "20.1")

do_test (31 10-9 "1")
do_test (32 10.1-9.1 "1")
do_test (33 10-9.1 "0.9")
do_test (34 10.1-9 "1.1")

do_test (41 10*10 "100")
do_test (42 10.1*10.1 "102.01")
do_test (43 10*10.1 "101")
do_test (44 10.1*10 "101")

do_test (51 10/5 "2")
do_test (52 10.1/5.1 "1.98039")
do_test (53 10/5.1 "1.96078")
do_test (54 10.1/5 "2.02")

do_test (61 10%3 "1")
do_test (62 10.1%5.1 "5")
do_test (63 10%5.1 "4.9")
do_test (64 10.1%5 "0.1")

do_test (71 "(10)" "10")
do_test (72 "(10.1)" "10.1")

do_test (81 1+2*3 "7")
do_test (82 1+6/2 "4")

do_test (91 1=1 "Parser error!")
do_test (92 1+=1 "Parser error!")
do_test (93 1-=1 "Parser error!")
do_test (93 1*=1 "Parser error!")
do_test (93 1/=1 "Parser error!")
do_test (93 1%=1 "Parser error!")
