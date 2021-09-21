![NSIDC logo](/images/NSIDC_logo_2018_poster-1.png)

# EASE grids: easeconv

EASE-Grid map transformation utilities for IDL. `easeconv` is version 0.3 and
was originally released on December 18, 2013. See the
[`CHANGELOG.md`](./CHANGELOG.md) for complete version history.


## Level of Support

<b>This repository is fully supported by NSIDC.</b> If you discover any problems or
bugs, please submit an Issue. If you would like to contribute to this
repository, you may fork the repository and submit a pull request.

See the [LICENSE](LICENSE) for details on permissions and warranties. Please
contact nsidc@nsidc.org for more information.


## Requirements

The procedures defined in this directory require the Interactive Data Language
(IDL), which requires a license to install and use.


## Installation

Please see [this
documentation](https://www.l3harrisgeospatial.com/Support/Self-Help-Tools/Help-Articles/Help-Articles-Detail/ArtMID/10220/ArticleID/23920/Install-and-License-IDL-88)
for more information on how to install IDL on your system.


## Usage

First, start an IDL repl (`idl`):

```
$ idl
IDL Version 8.3 (linux x86_64 m64). (c) 2013, Exelis Visual Information Solutions, Inc.
Installation number: xxx-xxxx.
Licensed for use by: University of Colorado - Boulder (MAIN)

IDL>
```

Next, compile `easeconv/easeconv.pro` with the `.RUN` command:

```
IDL> .RUN easeconv/easeconv.pro
% Compiled module: SSMI_CONVERT.
% Compiled module: SSMI_INVERSE.
% Compiled module: EASE_CONVERT.
% Compiled module: EASE_INVERSE.
```

Two main functions are defined exposed by compiling `easeconv.pro`:
`ease_convert` and `ease_inverse`. All other functions are support routines for
these top-level functions.

`ease_convert` and `ease_inverse` perform forward ((lat,lon) to (col,row)) and
inverse ((col,row) to (lat,lon)) transformations respectively for all of the
supported original (spherical) EASE-Grids and the currently supported (wgs84
ellipsoid) EASE-Grid-2.0 grids.

* Supported original (spherical) EASE-Grids:
    * SSM/I Polar Pathfinder: [NSM][lh]
       (where l="low" res (25km), h="high" res (12.5km))
    * AVHRR Polar Pathfinder: [NS]a{1,5,25}
       (where 1=1.25 km res, 5=5 km res, 25=25 km res)
    * TOVS-P Polar Pathfinder: NpathP (100km res)
    * AARI sea ice: AARI or (equivalent) NAARI (12.5 km res)
    * MODIS sea ice: [NS]Modis[14]km
* Supported (WGS84) EASE-Grid-2.0 grids:
    * Grid names according to the pattern "EASE2_pxx"
      where:
        p = projection: 'N' (north), 'S' (south), 'M' (cylindrical)
        xx - resolution: '25km', '12.5km', '6.25km',
             '36km', '09km', '03km', '01km' for all projections,
             and '100km' (for N projection only)
      Example: EASE2_M25km, EASE2_M09km, etc.

### `ease_convert`

The `ease_convert` function performs forward transformations from (lat, lon) to
(col, row).

```
IDL> grid_name = 'Nl'
IDL> latitude = -80
IDL> longitude = -120
IDL> status = ease_convert(grid_name, latitude, longitude, r, s)
% Compiled module: EASECONV_DEG2RAD.
% Compiled module: EASECONV_NORMALIZE_DEGREES.
IDL> print, status, r, s
       0      -78.547403       106.80454
```

### `ease_inverse`

The `ease_inverse` function performs inverse transformations from (col,row) to
(lat,lon).

```
IDL> grid_name = 'Nl'
IDL> r = -78.55
IDL> s = 106.80
IDL> status = ease_inverse(grid_name, r, s, lat, lon)
% Compiled module: EASECONV_RAD2DEG.
IDL> print, status, lat, lon
       0      -80.011697      -120.00030
```


## License

See [LICENSE](LICENSE).


## Code of Conduct

See [Code of Conduct](CODE_OF_CONDUCT.md).


## Credit

This software was developed by the NASA National Snow and Ice Data Center
Distributed Active Archive Center.

Author: M.J. Brodzik,  2011
