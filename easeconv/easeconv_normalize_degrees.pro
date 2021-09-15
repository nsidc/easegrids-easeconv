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
;-
; 2011-09-29 M. J. Brodzik brodzik@nsidc.org 303-492-8263
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

