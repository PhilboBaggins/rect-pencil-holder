
FN = 64;

HOLE_RADIUS_FOR_M3 = 3.5 / 2;

DEFAULT_NUM_X = 10;
DEFAULT_NUM_Y = 10;
DEFAULT_SPACING = 3;
DEFAULT_HOLE_RADIUS = 12 / 2;
DEFAULT_SCREW_HOLE_RADIUS = HOLE_RADIUS_FOR_M3; // M3 standoff
DEFAULT_THICKNESS = 3;
DEFAULT_PANEL_SPACING = 1;

function isCornerPos(x, y, numX, numY) = (
       ((x == 1)    && (y == 1))
    || ((x == numX) && (y == numY))
    || ((x == 1)    && (y == numY))
    || ((x == numX) && (y == 1)));

module ScrewHoles(numX, numY, spacing, holeRadius, screwHoleRadius)
{
    posFactor = 2 * holeRadius + spacing;

    translate([   1 * posFactor,    1 * posFactor]) circle(r = screwHoleRadius, $fn=FN);
    translate([   1 * posFactor, numY * posFactor]) circle(r = screwHoleRadius, $fn=FN);
    translate([numX * posFactor,    1 * posFactor]) circle(r = screwHoleRadius, $fn=FN);
    translate([numX * posFactor, numY * posFactor]) circle(r = screwHoleRadius, $fn=FN);
}

module RectPencilHolder_Top2D(
    numX = DEFAULT_NUM_X,
    numY = DEFAULT_NUM_Y,
    spacing = DEFAULT_SPACING,
    holeRadius = DEFAULT_HOLE_RADIUS,
    screwHoleRadius = DEFAULT_SCREW_HOLE_RADIUS)
{
    difference()
    {
        RectPencilHolder_Base2D(numX, numY, spacing, holeRadius);

        posFactor = 2 * holeRadius + spacing;

        for (x = [1 : numX])
        for (y = [1 : numY])
        {
            if (isCornerPos(x, y, numX, numY) == false)
            {
                translate([x * posFactor, y * posFactor])
                circle(r = holeRadius, $fn=FN);
                //square([2 * holeRadius, 2 * holeRadius], center=true);
            }
        }

        ScrewHoles(numX, numY, spacing, holeRadius, screwHoleRadius);
    }
}

module RectPencilHolder_Base2D(
    numX = DEFAULT_NUM_X,
    numY = DEFAULT_NUM_Y,
    spacing = DEFAULT_SPACING,
    holeRadius = DEFAULT_HOLE_RADIUS,
    screwHoleRadius = DEFAULT_SCREW_HOLE_RADIUS)
{
    x = (numX + 1) * (2 * holeRadius + spacing);
    y = (numY + 1) * (2 * holeRadius + spacing);

    echo(str("Size of base is ", x, " x ", y));

    difference()
    {
        square([x, y]);
        ScrewHoles(numX, numY, spacing, holeRadius, screwHoleRadius);
    }
}

module RectPencilHolder_Stackup(
    numX = DEFAULT_NUM_X,
    numY = DEFAULT_NUM_Y,
    spacing = DEFAULT_SPACING,
    holeRadius = DEFAULT_HOLE_RADIUS,
    screwHoleRadius = DEFAULT_SCREW_HOLE_RADIUS,
    thickness = DEFAULT_THICKNESS)
{
    translate([0, 0, 50 + thickness]) // TODO: How far to move up
    linear_extrude(thickness)
    RectPencilHolder_Top2D(numX, numY, spacing, holeRadius, screwHoleRadius);

    translate([0, 0, 15 + thickness]) // TODO: How far to move up
    linear_extrude(thickness)
    RectPencilHolder_Top2D(numX, numY, spacing, holeRadius, screwHoleRadius);

    translate([0, 0, 0])
    linear_extrude(thickness)
    RectPencilHolder_Base2D(numX, numY, spacing, holeRadius, screwHoleRadius);
}

module RectPencilHolder_2DPanel(
    numX = DEFAULT_NUM_X,
    numY = DEFAULT_NUM_Y,
    spacing = DEFAULT_SPACING,
    holeRadius = DEFAULT_HOLE_RADIUS,
    screwHoleRadius = DEFAULT_SCREW_HOLE_RADIUS,
    panelSpacing = DEFAULT_PANEL_SPACING)
{
    baseX = (numX + 1) * (2 * holeRadius + spacing);
    baseY = (numY + 1) * (2 * holeRadius + spacing);

    panelX = (baseX * 3) + (panelSpacing * 2);
    panelY = baseY;
    echo(str("Size of panel is ", panelX, " x ", panelY));

    translate([0 * (baseX + panelSpacing), 0]) RectPencilHolder_Top2D(numX, numY, spacing, holeRadius, screwHoleRadius);
    translate([1 * (baseX + panelSpacing), 0]) RectPencilHolder_Top2D(numX, numY, spacing, holeRadius, screwHoleRadius);
    translate([2 * (baseX + panelSpacing), 0]) RectPencilHolder_Base2D(numX, numY, spacing, holeRadius, screwHoleRadius);
}
