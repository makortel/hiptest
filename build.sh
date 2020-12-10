#!/bin/bash

GCC=g++
HIPCC=hipcc
CXXFLAGS="-std=c++17"

function single {
    $GCC $CXXFLAGS main.cc test1.cc test2.cc -o main-single-gcc
    $HIPCC $CXXFLAGS main.cc test1.cc test2.cc -o main-single-hipcc
}

function objects {
    $GCC $CXXFLAGS -c -o test1.o test1.cc
    $HIPCC $CXXFLAGS -c -o test2.o test2.cc
    $GCC $CXXFLAGS -c -o main.o main.cc
    $HIPCC main.o test1.o test2.o -o main-objects
}

function shared {
    $GCC $CXXFLAGS -fPIC -c -o test1.o test1.cc
    $GCC -shared -o libtest1.so test1.o

    #$GCC $CXXFLAGS -fPIC -c -o test2.o test2.cc
    #$GCC -shared -o libtest2.so test2.o

    $HIPCC $CXXFLAGS -fPIC -c -o test2.o test2.cc
    $HIPCC -shared -o libtest2.so test2.o

    $GCC $CXXFLAGS -c -o main.o main.cc
    $GCC -o main-shared -L. -ltest1 -ltest2 main.o
}

#single
#objects
shared
