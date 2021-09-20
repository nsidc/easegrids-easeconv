# 2021-09-20

Moved `easeconv` code into this Github repository (`easegrids-easeconv`).

# Release 0.3: 2013-12-18

Changes in this release do not affect any executable code.

1) Corrected wrong example values in comments for wgs84_*.pro routines.
2) Added a clarification note to wgs84_inverse_xy.pro comments,
   about the series approximation used here.

# Release 0.2: 2011-10-07

Changes from previously distributed revisions of easeconv:

1) Added support for WGS84-ellipsoid (EASE-Grid-2.0) grids
2) Input grid='aari' and 'Naari' both work the way old 'aari' did
3) When fewer than expected arguments are input,
   usage text is output via message rather than print
   and return value is -1 instead of undocumented 1
4) new return value -2 used throughout for unknown projection and/or grid
5) ssmi_convert - input longitude is normalized to [-180,180] before transformation
6) ssmi_inverse - output longitude is normalized to [-180, 180] before returning
7) original easeconv.pro transformations have been upgraded from single-
   to double-precision, increasing agreement with mapx C implementation
   from within 1.D-3 to within 1.D-7

# Original release: any files distributed earlier than 2011-10-07

Single-precision support for selected original EASE-Grids.
