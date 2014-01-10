#!/bin/sh
cd "$(dirname $0)"

C_OBJECTS=(
  exit
  abort
  stdfiles
  fputc
  fputs
  puts
  vfprintf
  fprintf
  printf
)

set -e

# Build tiny C library.
rm -f *.o libtinyc.a
for obj in "${C_OBJECTS[@]}"
do
  6502-gcc -O2 -nostdlib $obj.c -c
  ar65 a libtinyc.a $obj.o
done

# Build tiny maths library.
rm -f libm.a
6502-gcc -O2 -nostdlib math.c -c
ar65 a libm.a math.o

mkdir -p $PREFIX/usr/lib
cp -f libtinyc.a $PREFIX/usr/lib
cp -f libm.a $PREFIX/usr/lib
mkdir -p $PREFIX/usr/include
cp -rf include/* $PREFIX/usr/include
