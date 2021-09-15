;+
; NAME:
;	wgs84_inverse
;
; PURPOSE:
;	Use a WGS84 earth model to convert grid coordinates (col,row) for 
;	azimuthal equal-area or cylindrical equal-area to geographic coordinates
;
; CATEGORY:
;	Grid coordinate conversion
;
; CALLING SEQUENCE:
;       status = wgs84_inverse ( grid, r, s, lat, lon )
;
; INPUTS:
;       grid - EASE-Grid-2.0 grid name
;	r, s - grid column/row coordinates
;
; OUTPUTS:
;       lat, lon - geo. coords. (decimal degrees)
;
; RESULT:
;	status = 0 indicates normal successful completion
;		-1 indicates error status (point not on grid)
;
; EXAMPLE:
;       status = wgs84_inverse( 'EASE2_N25km', 359.5, 359.5, lat, lon
;
;       status will be 0, and the returned (lat, lon) will be (90.0, 180.0)
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
FUNCTION wgs84_inverse, grid, r, s, lat, lon

  on_error,2

  if n_params() lt 5 then begin
      message, $
         'usage:  status = wgs84_inverse (grid, lat, lon, r, s)', /info
      return, -1
  endif

  if -2 eq ease2_grid_info( grid, $
                            PROJECTION=projection, $
                            MAP_SCALE_M=map_scale_m, $
                            R0=r0, $
                            S0=s0 ) then begin
      message, "Unknown grid " + grid, /info
      return, -2
  endif
  
  ;; Convert (col, row) to xy coordinates for this projection
   x = ( r - r0 ) * map_scale_m
   y = ( s0 - s ) * map_scale_m
    
  status = wgs84_inverse_xy( projection, x, y, lat, lon )

  return, status

end
        
