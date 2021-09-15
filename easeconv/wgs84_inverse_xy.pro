;+
; NAME:
;	wgs84_inverse_xy
;
; PURPOSE:
;       Use a WGS84 earth model to convert azimuthal equal-area or
;       cylindrical equal-area projection coordinates to geographic
;       coordinates
;
; CATEGORY:
;	Projection coordinate conversion
;
; CALLING SEQUENCE:
;       status = wgs84_inverse_xy ( projection, x, y, lat, lon)
;
; INPUTS:
;       projection: projection ['N','S', or 'M']
;             N = Northern azimuthal equal area
;             S = Southern azimuthal equal area
;             M = cylindrical equal area
;	x, y - projection x, y coordinates (meters)
;
; OUTPUTS:
;       lat, lon - geo. coords. (decimal degrees)
;
; RESULT:
;	status = 0 indicates normal successful completion
;		-1 indicates error status (point not on grid)
;
; EXAMPLE:
;       status = wgs84_inverse_xy ('N',0.0, 0.0, lat, lon)
;
;       status will be 0, and the returned lat, lon will be 90.0, 180.0
;
; REFERENCE:
;
; Snyder, John P. Map Projections--A Working Manual. USGS Professional
; Paper 1395. US Govt Printing Office, Washington, DC. 1987.

; Lambert Azimuthal equal-area projection formulas for the ellipsoid:
; pp. 187-190.
; 
; Cylindrical equal-area projection formulas for the ellipsoid: pp. 81-85.
;
; Both sets of formulae make use of a series expansion for phi that Snyder
; gives as an alternative to a formula that would need to be solved
; iteratively by successive substitution.
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
FUNCTION wgs84_inverse_xy, projection, x, y, lat, lon

  on_error,2

  if n_params() lt 5 then begin
      message, 'usage:  status = wgs84_inverse_xy ( projection, x, y, lat, lon)', /info
      return, -1
  endif

  status = ease2_map_info( projection, $
                           MAP_EQUATORIAL_RADIUS_M=map_equatorial_radius_m, $
                           MAP_ECCENTRICITY=map_eccentricity, $
                           E2=e2, $
                           MAP_REFERENCE_LATITUDE=map_reference_latitude, $
                           MAP_REFERENCE_LONGITUDE=map_reference_longitude, $
                           MAP_SECOND_REFERENCE_LATITUDE=map_second_reference_latitude, $
                           SIN_PHI1=sin_phi1, $
                           COS_PHI1=cos_phi1, $
                           KZ=kz )
  if 0 ne status then return, status

  e4 = map_eccentricity^4.0
  e6 = map_eccentricity^6.0

  ;; qp is the function q evaluated at phi = 90.0
  qp = ( 1.0D - e2 ) * ( ( 1.0D / ( 1.0D - e2 ) ) $
                        - ( 1.0D / ( 2.0D * map_eccentricity ) ) $
                        * alog( ( 1.0D - map_eccentricity ) $
                                / ( 1.0D + map_eccentricity ) ) )

  
  proj = strupcase( projection )
  
  if 'N' eq proj then begin

      rho = sqrt( ( x * x ) + ( y * y ) )
      beta = asin( 1.0D - ( rho^2 / ( map_equatorial_radius_m^2 * qp ) ) )

      lam = atan( x, ( -1.0D * y ) )
      
  endif else if 'S' eq proj then begin

      rho = sqrt( ( x * x ) + ( y * y ) )
      beta = -1.0D * asin( 1.0D - ( rho^2 / ( map_equatorial_radius_m^2 * qp ) ) )

      lam = atan( x,  y )
      
  endif else if 'M' eq proj then begin

      beta = asin( 2.0D * y * kz/( map_equatorial_radius_m * qp ) )

      lam = x / ( map_equatorial_radius_m * kz )

  endif else begin
      message, "Programming error."
  endelse
  
  phi = beta $
        + ( ( ( e2 / 3.0D ) + ( ( 31.0D / 180.0D ) * e4 ) $
              + ( ( 517.0D / 5040.0D ) * e6 ) ) * sin( 2.0D * beta ) ) $
        + ( ( ( ( 23.0D / 360.0D ) * e4) $
              + ( ( 251.0D / 3780.0D ) * e6 ) ) * sin( 4.0D * beta ) ) $
        + ( ( ( 761.0D / 45360.0D ) * e6 ) * sin( 6.0D * beta ) )

  lat = easeconv_rad2deg( phi )
  lon = easeconv_normalize_degrees( map_reference_longitude + ( easeconv_rad2deg( lam ) ) )

  return, 0

END ; wgs84_inverse_xy

