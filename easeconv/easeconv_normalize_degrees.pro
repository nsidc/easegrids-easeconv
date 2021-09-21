;+
; NAME:
;       easeconv_normalize_degrees
;
; PURPOSE:
;       Normalizes input value to range [-180, 180]
;
; CALLING SEQUENCE:
;       norm_lon = easeconv_normalize_degrees( lon )
;
; ARGUMENTS:
;       lon - longitude (decimal degrees)
;
; RESULT: normalized longitude
;
; EXAMPLE:
;       lon = 185.
;       lon = easeconv_normalize_degrees( lon )
;
;       Returned value will be -175.
;
function easeconv_normalize_degrees, inlon

  lon = inlon

  while ( float(lon) lt -180. ) do begin
      lon = lon + 360.
  endwhile
  while ( float(lon) gt 180. ) do begin
      lon = lon - 360.
  endwhile

  return, lon

end

