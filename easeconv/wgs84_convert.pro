;+
; NAME:
;	wgs84_convert
;
; PURPOSE:
;	Use a WGS84 earth model to convert geographic coordinates to
;	azimuthal equal-area or cylindrical equal-area grid coordinates
;
; CATEGORY:
;	Grid coordinate conversion
;
; CALLING SEQUENCE:
;       status = wgs84_convert ( grid, lat, lon, r, s )
;
; INPUTS:
;       grid - EASE-Grid-2.0 grid name
;       lat, lon - geo. coords. (decimal degrees)
;
; OUTPUTS:
;	r, s - grid column/row coordinates
;
; RESULT:
;	status = 0 indicates normal successful completion
;		-1 indicates error status (point not on grid)
;
; EXAMPLE:
;       status = wgs84_convert( 'EASE2_N25km', 90., 0., r, s )
;
;       status will be 0, and the returned (r, s) will be (359.5, 359.5)
;
;-
; 2011-09-30 M. J. Brodzik brodzik@nsidc.org 303-492-8263
; $Revision: 24279 $
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
FUNCTION wgs84_convert, grid, lat, lon, r, s

  on_error,2

  if n_params() lt 5 then begin
      message, $
         'usage:  status = wgs84_convert (grid, lat, lon, r, s)', /info
      return, -1
  endif

  if -2 eq ease2_grid_info( grid, $
                            PROJECTION=projection, $
                            MAP_SCALE_M=map_scale_m, $
                            COLS=cols, $
                            ROWS=rows, $
                            R0=r0, $
                            S0=s0 ) then begin
      message, "Unknown grid " + grid, /info
      return, -2
  endif
  
  status = wgs84_convert_xy( projection, lat, lon, x, y )

  ;; Convert xy coordinates to row/col for this particular grid
  r = r0 + ( x / map_scale_m )
  s = s0 - ( y / map_scale_m )
    
  ;; Check for actual grid boundaries
  if r lt -0.5 or r ge (cols - 0.5) or $
     s lt -0.5 or s ge (rows - 0.5) then status = -1

  return, status

end
        
