;+
; NAME:
;	easeconv_deg2rad 
;
; PURPOSE:
;       Converts input value from degrees to radians using double-precision value of pi
;
; CALLING SEQUENCE:
;       rad = easeconv_deg2rad( angle )
;
; ARGUMENTS:
;       angle - angle in degrees
;
; RESULT: angle in radians
;
; EXAMPLE:
;       angle = 90.
;       rad = easeconv_deg2rad( angle )
;
;       returns 1.5707963D
;
function easeconv_deg2rad, angle

  return, angle * !dpi / 180.0D

end

