;+
; NAME:
;	wgs84_convert_xy
;
; PURPOSE:
;	Use a WGS84 earth model to convert geographic coordinates to
;	azimuthal equal-area or cylindrical equal-area projection coordinates
;
; CATEGORY:
;	Projection coordinate conversion
;
; CALLING SEQUENCE:
;       status = wgs84_convert_xy ( projection, lat, lon, x, y)
;
; INPUTS:
;       projection: projection ['N','S', or 'M']
;             N = Northern azimuthal equal area
;             S = Southern azimuthal equal area
;             M = cylindrical equal area
;       lat, lon - geo. coords. (decimal degrees)
;
; OUTPUTS:
;	x, y - projection x, y coordinates (meters)
;
; RESULT:
;	status = 0 indicates normal successful completion
;		-1 indicates error status (point not on grid)
;
; EXAMPLE:
;       status = wgs84_convert_xy( 'N', 90., 0., x, y )
;
;       status will be 0, and the returned (x, y) will be (0.0, -0.0)
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
FUNCTION wgs84_convert_xy, projection, lat, lon, x, y

  on_error,2

  if n_params() lt 5 then begin
      message, $
         'usage:  status = wgs84_convert_xy (projection, lat, lon, x, y)', /info
      return, -1
  endif

  ;; epsilon for test in neighborhood of pole for azimuthal projections
  epsilon = 1.0D-6

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

  proj = strupcase( projection )
  
  dlon = lon - map_reference_longitude
  dlon = easeconv_normalize_degrees( dlon )
  phi = easeconv_deg2rad( lat )
  lam = easeconv_deg2rad( dlon )

  sin_phi = sin( phi )
  
  q = ( 1.0D - e2 ) * ( ( sin_phi / ( 1.0D - e2 * sin_phi * sin_phi ) ) $
                        - ( 1.0D / ( 2.0D * map_eccentricity ) ) $
                        * alog( ( 1.0D - map_eccentricity * sin_phi ) $
                                / ( 1.0D + map_eccentricity * sin_phi ) ) )

  qp = 1.0D - ( ( 1.0D - e2 ) / ( 2.0D * map_eccentricity ) $
                * alog( ( 1.0D - map_eccentricity ) $
                        / ( 1.0D + map_eccentricity ) ) )

  if 'N' eq proj then begin

      if ( abs( qp - q ) lt epsilon ) then begin

          rho = 0.0D

      endif else begin

          rho = map_equatorial_radius_m * sqrt( qp - q )

      endelse

      x = rho * sin( lam )
      y = -1.0D * rho * cos( lam )

  endif else if 'S' eq proj then begin

      if ( abs( qp + q ) lt epsilon ) then begin

          rho = 0.0D

      endif else begin

          rho = map_equatorial_radius_m * sqrt( qp + q )

      endelse

      x = rho * sin( lam )
      y = rho * cos( lam )

  endif else if 'M' eq proj then begin

      x = map_equatorial_radius_m * kz * lam
      y = ( map_equatorial_radius_m * q ) / ( 2.0D * kz )

  endif else begin
      message, "Programming error."
  endelse

  return, 0

END ; wgs84_convert_xy

