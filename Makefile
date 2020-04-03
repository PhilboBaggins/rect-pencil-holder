NAME := RectPencilHolder

ALL_2D := \
	exports/${NAME}.dxf \
	exports/${NAME}.svg

ALL_3D := \
	exports/${NAME}.stl \
	exports/${NAME}.png

.PHONY: all clean

all: ${ALL_2D} ${ALL_3D}

${ALL_2D}: exports/${NAME}2D.scad ${NAME}.scad
	openscad -o $@ $<

${ALL_3D}: exports/${NAME}3D.scad ${NAME}.scad
	openscad -o $@ $<

clean:
	rm -f ${ALL_2D} ${ALL_3D}
