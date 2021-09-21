;+
; NAME:
;       ease2_map_info 
;
; PURPOSE:
;       Returns map parameters for the specified EASE-Grid-2.0 projection;
;       by definition, the EASE-Grid-2.0 projections use the WGS84 ellipsoid
;
; CALLING SEQUENCE:
;       status = ease2_map_info( projection )
;
; ARGUMENTS:
;       projection - EASE-Grid-2.0 projection, one of 'N', 'S' or 'M', where:
;                    N - Northern Lambert azimuthal equal-area
;                    S - Southern Lambert azimuthal equal-area
;                    M - Global cylindrical equal-area
;
; KEYWORDS:
;       MAP_EQUATORIAL_RADIUS_M - WGS84 equatorial radius
;       MAP_ECCENTRICITY - WGS84 eccentricity
;       E2 - eccentricity^2
;       MAP_REFERENCE_LATITUDE - map reference latitude (degrees)
;       MAP_REFERENCE_LONGITUDE - map reference longitude (degrees)
;       MAP_SECOND_REFERENCE_LATITUDE - phi1 = true latitude (only for
;                                       projection='M')
;       SIN_PHI1 - sin( MAP_SECOND_REFERENCE_LATITUDE ) - sin(phi1) (only
;                  for projection='M')
;       COS_PHI1 - cos( MAP_SECOND_REFERENCE_LATITUDE ) - cos(phi1) (only
;                  for projection='M')
;       KZ - cos(phi1) / sqrt(1 - e^2 sin^2(phi1)) (only for projection 'M')
;
; RESULT:
;       0 - successful completion
;       -2 - undefined projection name
;
; EXAMPLE:
;       status = ease2_map_info( 'N', MAP_REFERENCE_LATITUDE=lat0,
;       MAP_REFERENCE_LONGITUDE=lon0 )
;
;       will return status of 0 and lat0=90.0D and lon0=0.0D
;
function ease2_map_info, projection, $
                         MAP_EQUATORIAL_RADIUS_M=map_equatorial_radius_m, $
                         MAP_ECCENTRICITY=map_eccentricity, $
                         E2=e2, $
                         MAP_REFERENCE_LATITUDE=map_reference_latitude, $
                         MAP_REFERENCE_LONGITUDE=map_reference_longitude, $
                         MAP_SECOND_REFERENCE_LATITUDE=map_second_reference_latitude, $
                         SIN_PHI1=sin_phi1, $
                         COS_PHI1=cos_phi1, $
                         KZ=kz

  proj = strupcase( projection )
  
  if not stregex( proj, '^[NSM]$', /boolean ) then begin
      message, 'unknown projection: ' + projection,/info
      return,-2
  endif

  map_equatorial_radius_m = 6378137.0D ; WGS84
  map_eccentricity = 0.081819190843D ; WGS84
  e2 = map_eccentricity^2.0

  if 'N' eq proj then begin

      map_reference_latitude = 90.0D
      map_reference_longitude = 0.0D

  endif else if 'S' eq proj then begin

      ;; Parameters specific to this projection
      map_reference_latitude = -90.0D
      map_reference_longitude = 0.0D

  endif else if 'M' eq proj then begin

      ;; Parameters specific to this projection
      map_reference_latitude = 0.0D
      map_reference_longitude = 0.0D
      map_second_reference_latitude = 30.0D
      sin_phi1 = sin( easeconv_deg2rad( map_second_reference_latitude ) )
      cos_phi1 = cos( easeconv_deg2rad( map_second_reference_latitude ) )
      kz = cos_phi1 / sqrt( 1.0D - e2 * sin_phi1 * sin_phi1 )

  endif else begin
      message, "Programming error."
  endelse

  return, 0

end
