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
function easeconv_rad2deg, angle

  return, angle * 180.0D / !dpi

end

