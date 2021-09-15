Readme file for easeconv, the EASE-Grid map transformation utilities.
Developed and distributed by the
National Snow & Ice Data Center, University of Colorado at Boulder.

The current version of easeconv is 0.3, released December 18, 2013.

An html version of the help utilities for the routines included is in the
file easeconv_help.html.

To use these utilities, put them in a directory in your IDL path and do

IDL> .run easeconv.pro

The top-level functions are:

status = ease_convert(grid, lat, lon, r, s)

and

status = ease_inverse(grid, r, s, lat, lon)

These routines will perform forward ((lat,lon) to (col,row)) and inverse
((col,row) to (lat,lon)) transformations for all of the supported original
(spherical) EASE-Grids and the currently supported (wgs84 ellipsoid)
EASE-Grid-2.0 grids.  All other routines are support routines for these
top-level functions.

Please refer to the Copyright notice included with the source files for
copying and distribution rights.

Please direct questions or comments about this software to:

NSIDC User Services Office
email: nsidc@nsidc.org
phone: +1 303.492.6199


Release 0.3: 2013-12-18
=======================

Changes in this release do not affect any executable code.

1) Corrected wrong example values in comments for wgs84_*.pro routines.
2) Added a clarification note to wgs84_inverse_xy.pro comments,
   about the series approximation used here.

Release 0.2: 2011-10-07
=======================

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

Original release: any files distributed earlier than 2011-10-07
===============================================================

Single-precision support for selected original EASE-Grids.
