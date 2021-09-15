;+
; NAME:
;	ease2_grid_info
;
; PURPOSE:
;       Returns grid parameters for the specified EASE-Grid-2.0 grid
;
; CALLING SEQUENCE:
;       status = ease2_grid_info( grid )
;
; ARGUMENTS:
;       grid - EASE-Grid-2.0 grid name, assumes pattern is 'EASE2_P',
;              where P=projection='N', 'S' or 'M' e.g. EASE2_M25km
;
; KEYWORDS:
;       MAP_SCALE_M - map scale (meters)
;       COLS - grid columns
;       ROWS - grid rows
;       R0 - column that is mapped to map_reference_latitude
;       S0 - row that is mapped to map_reference_latitude
;
; RESULT:
;       0 - successful completion
;       -2 - undefined grid name
;
; EXAMPLE:
;       status = ease2_grid_info( 'EASE2_N25km', COLS=cols, ROWS=rows )
;
;       will return status of 0 and cols = 720, rows = 720
;
;-
; 2011-10-04 M. J. Brodzik brodzik@nsidc.org 303-492-8263
; $Revision: 19559 $
;
; Copyright 2011 Regents of the University of Colorado. The Regents of the
; University of Colorado grants, and you accept, a personal, nonexclusive,
; nontransferable license to use this software, at no charge, in
; accordance with the terms herein, solely for internal research and
; development, which is limited to testing, measuring, assessing,
; evaluating the software and/or data that you generate using this
; software, and not for any commercial purpose. You may not develop
; derivative works based on this software, or redistribute this software.
;
function ease2_grid_info, grid, $
                          PROJECTION=projection, $
                          MAP_SCALE_M=map_scale_m, $
                          COLS=cols, $
                          ROWS=rows, $
                          R0=r0, $
                          S0=s0

  ingrid = strupcase( grid )
  
  if not stregex( ingrid, '^EASE2', /boolean ) then begin
      message, 'unknown grid: ' + grid,/info
      return,-2
  endif

  grid_info_struct = { gpd: '', projection: '', map_scale_m: 0.0D, cols: 0L, rows: 0L, r0: 0.0D, s0: 0.0D }
  info = replicate( grid_info_struct, 22 )
  info[ 0 ] = { gpd: 'EASE2_N25KM', projection: '', map_scale_m: 25000.0D, $
                cols: 720L, rows: 720L, r0: 0.0D, s0: 0.0D }
  info[ 1 ] = { gpd: 'EASE2_N12.5KM', projection: '', map_scale_m: 12500.0D, $
                cols: 1440L, rows: 1440L, r0: 0.0D, s0: 0.0D }
  info[ 2 ] = { gpd: 'EASE2_N6.25KM', projection: '', map_scale_m: 6250.0D, $
                cols: 2880L, rows: 2880L, r0: 0.0D, s0: 0.0D }
  info[ 3 ] = { gpd: 'EASE2_N36KM', projection: '', map_scale_m: 36000.0D, $
                cols: 500L, rows: 500L, r0: 0.0D, s0: 0.0D }
  info[ 4 ] = { gpd: 'EASE2_N09KM', projection: '', map_scale_m: 9000.0D, $
                cols: 2000L, rows: 2000L, r0: 0.0D, s0: 0.0D }
  info[ 5 ] = { gpd: 'EASE2_N03KM', projection: '', map_scale_m: 3000.0D, $
                cols: 6000L, rows: 6000L, r0: 0.0D, s0: 0.0D }
  info[ 6 ] = { gpd: 'EASE2_N01KM', projection: '', map_scale_m: 1000.0D, $
                cols: 18000L, rows: 18000L, r0: 0.0D, s0: 0.0D }
  info[ 7 ] = { gpd: 'EASE2_N100KM', projection: '', map_scale_m: 100000.0D, $
                cols: 180L, rows: 180L, r0: 0.0D, s0: 0.0D }
  info[ 8 ] = { gpd: 'EASE2_S25KM', projection: '', map_scale_m: 25000.0D, $
                cols: 720L, rows: 720L, r0: 0.0D, s0: 0.0D }
  info[ 9 ] = { gpd: 'EASE2_S12.5KM', projection: '', map_scale_m: 12500.0D, $
                cols: 1440L, rows: 1440L, r0: 0.0D, s0: 0.0D }
  info[ 10 ] = { gpd: 'EASE2_S6.25KM', projection: '', map_scale_m: 6250.0D, $
                 cols: 2880L, rows: 2880L, r0: 0.0D, s0: 0.0D }
  info[ 11 ] = { gpd: 'EASE2_S36KM', projection: '', map_scale_m: 36000.0D, $
                 cols: 500L, rows: 500L, r0: 0.0D, s0: 0.0D }
  info[ 12 ] = { gpd: 'EASE2_S09KM', projection: '', map_scale_m: 9000.0D, $
                 cols: 2000L, rows: 2000L, r0: 0.0D, s0: 0.0D }
  info[ 13 ] = { gpd: 'EASE2_S03KM', projection: '', map_scale_m: 3000.0D, $
                 cols: 6000L, rows: 6000L, r0: 0.0D, s0: 0.0D }
  info[ 14 ] = { gpd: 'EASE2_S01KM', projection: '', map_scale_m: 1000.0D, $
                 cols: 18000L, rows: 18000L, r0: 0.0D, s0: 0.0D }
  info[ 15 ] = { gpd: 'EASE2_M25KM', projection: '', map_scale_m: 25025.2600081D, $
                 cols: 1388L, rows: 584L, r0: 0.0D, s0: 0.0D }
  info[ 16 ] = { gpd: 'EASE2_M12.5KM', projection: '', map_scale_m: 12512.63000405D, $
                 cols: 2776L, rows: 1168L, r0: 0.0D, s0: 0.0D }
  info[ 17 ] = { gpd: 'EASE2_M6.25KM', projection: '', map_scale_m: 6256.315002025D, $
                 cols: 5552L, rows: 2336L, r0: 0.0D, s0: 0.0D }
  info[ 18 ] = { gpd: 'EASE2_M36KM', projection: '', map_scale_m: 36032.220840584D, $
                 cols: 964L, rows: 406L, r0: 0.0D, s0: 0.0D }
  info[ 19 ] = { gpd: 'EASE2_M09KM', projection: '', map_scale_m: 9008.055210146D, $
                 cols: 3856L, rows: 1624L, r0: 0.0D, s0: 0.0D }
  info[ 20 ] = { gpd: 'EASE2_M03KM', projection: '', map_scale_m: 3002.6850700487D, $
                 cols: 11568L, rows: 4872L, r0: 0.0D, s0: 0.0D }
  info[ 21 ] = { gpd: 'EASE2_M01KM', projection: '', map_scale_m: 1000.89502334956D, $
                 cols: 34704L, rows: 14616L, r0: 0.0D, s0: 0.0D }

  info.r0 = ( info.cols - 1 ) / 2.0D
  info.s0 = ( info.rows - 1 ) / 2.0D
  info.projection = strmid( info.gpd, 6, 1 )

  idx = where( ingrid eq info.gpd, count )
  if 1 ne count then begin
      message, 'unknown EASE2 projection: ' + grid,/info
      return,-2
  endif
  projection = info[ idx[ 0 ] ].projection
  map_scale_m = info[ idx[ 0 ] ].map_scale_m
  cols = info[ idx[ 0 ] ].cols
  rows = info[ idx[ 0 ] ].rows
  r0 = info[ idx[ 0 ] ].r0
  s0 = info[ idx[ 0 ] ].s0

  return, 0

end
