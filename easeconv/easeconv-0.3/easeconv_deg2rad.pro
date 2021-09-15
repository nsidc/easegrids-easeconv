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
;-
; 2011-10-05 M. J. Brodzik brodzik@nsidc.org 303-492-8263
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
function easeconv_deg2rad, angle

  return, angle * !dpi / 180.0D

end

