;+
; NAME:
;	easeconv_rad2deg
;
; PURPOSE:
;       Converts input value from radians to degrees using double-precision value of pi
;
; CALLING SEQUENCE:
;       deg = easeconv_rad2deg( angle )
;
; ARGUMENTS:
;       angle - angle in radians
;
; RESULT: angle in degrees
;
; EXAMPLE:
;       angle = !dpi/4.
;       deg = easeconv_rad2deg( angle )
;
;       returns 45.0D
;
function easeconv_rad2deg, angle

  return, angle * 180.0D / !dpi

end

