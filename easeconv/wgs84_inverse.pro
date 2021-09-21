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
        
