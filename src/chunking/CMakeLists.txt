cmake_minimum_required(VERSION 3.0)
project(libchunking C)

add_library(chunking STATIC ae_chunking.c)

install(TARGETS chunking DESTINATION .)