;==========================================================================
; easeconv.pro - IDL routines for conversion of azimuthal equal-area and
;                equal-area cylindrical grid coordinates; Supports
;                original EASE-Grids and EASE-Grid-2.0 (WGS ellipsoid)
;
; 1992-01-30 H. Maybee Original Author
; Maintenance contact: M. J. Brodzik brodzik@nsidc.org 303-492-8263
;
; $Revision: 19585 $
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
;==========================================================================

;+
; NAME:
;	ssmi_convert
;
; PURPOSE:
;	Use a spherical earth model to convert geographic coordinates to
;	azimuthal equal-area or equal-area cylindrical grid coordinates
;	(for original SSM/I (spherical) EASE-Grids, 25 km, 12.5 km)
;
; CATEGORY:
;	Grid coordinate conversion
;
; CALLING SEQUENCE:
;       status = ssmi_convert ( grid, lat, lon, r, s)
;
; INPUTS:
;       grid: SSM/I grid name '[NSM][lh]'
;             (where l="low" res (25km), h="high" res (12.5km)
;       lat, lon - geo. coords. (decimal degrees)
;
; OUTPUTS:
;	r, s - column, row coordinates
;
; RESULT:
;	status = 0 indicates normal successful completion
;		-1 indicates error status (point not on grid)
;
; EXAMPLE:
;       status = ssmi_convert ('Nl',90.,0.,col,row)
;
;       status will be 0, and the returned col, row will be 360.0, 360.0
;
;-
FUNCTION ssmi_convert, grid, lat, lon, r, s

  on_error,2

  if n_params() lt 5 then begin
      message,'usage:  status = ssmi_convert (grid, lat, lon, r, s)', /info
      return, -1
  endif

  grid = string(grid)
  grid0 = strmid(grid,0,1)
  grid1 = strmid(grid,1,1)
  
  if (grid0 eq 'N') or (grid0 eq 'S') then begin
      cols = 721
      rows = 721
  endif else if grid0 eq 'M' then begin
      cols = 1383
      rows = 586
  endif else begin
      message, 'unknown projection: ' + grid
  endelse

  if grid1 eq 'l' then scale = 1 $
  else if grid1 eq 'h' then scale = 2 $
  else message, 'unknown projection: ' + grid

;
;	radius of the earth (km), authalic sphere based on International datum 
  RE_km = 6371.228D
;
;	nominal cell size in kilometers
  CELL_km = 25.067525D

  Rg = scale * RE_km/CELL_km

;
;	scale factor for standard parallels at +/-30.00 degrees
;
  COS_PHI1 = .8660254038D

;
;	r0,s0 are defined such that cells at all scales
;	have coincident center points
;
  r0 = (cols-1)/2.0D * scale
  s0 = (rows-1)/2.0D * scale

  ;; normalize input longitude
  phi = easeconv_deg2rad( lat )
  lam = easeconv_deg2rad( easeconv_normalize_degrees( lon ) )

  if grid0 eq 'N' then begin
      rho = 2.0D * Rg * sin(!DPI/4.0D - phi/2.0D)
      r = r0 + rho * sin(lam)
      s = s0 + rho * cos(lam)

  endif else if grid0 eq 'S' then begin
      rho = 2.0D * Rg * cos(!DPI/4.0D - phi/2.0D)
      r = r0 + rho * sin(lam)
      s = s0 - rho * cos(lam)

  endif else if grid0 eq 'M' then begin
      r = r0 + Rg * lam * COS_PHI1
      s = s0 - Rg * sin(phi) / COS_PHI1

  endif

  return, 0

END ; ssmi_convert

;+
; NAME:
;	ssmi_inverse
;
; PURPOSE:
;	Use a spherical earth model to convert azimuthal equal-area 
;       equal-area cylindrical grid coordinates to geographic coordinates
;	(for original SSM/I (spherical) EASE-Grids, 25 km, 12.5 km)
;
; CATEGORY:
;	Grid coordinate conversion
;
; CALLING SEQUENCE:
;       status = ssmi_inverse ( grid, r, s, lat, lon)
;
; INPUTS:
;       grid: SSM/I grid name '[NSM][lh]'
;             (where l="low" res (25km), h="high" res (12.5km)
;	r, s - column, row coordinates
;
; OUTPUTS:
;       lat, lon - geo. coords. (decimal degrees)
;
; RESULT:
;	status = 0 indicates normal successful completion
;		-1 indicates error status (point not on grid)
;
; EXAMPLE:
;       status = ssmi_inverse ('Nl',360.0, 360.0, lat, lon)
;
;       status will be 0, and the returned lat, lon will be 90.0, 0.0
;
;-
FUNCTION ssmi_inverse, grid, r, s, lat, lon

  on_error,2

  if n_params() lt 5 then begin
      message, 'usage:  status = ssmi_inverse (grid, r, s, lat, lon)', /info
      return, -1
  endif

  grid = string(grid)
  grid0 = strmid(grid,0,1)
  grid1 = strmid(grid,1,1)
  
  if (grid0 eq 'N') or (grid0 eq 'S') then begin
      cols = 721
      rows = 721
  endif else if grid0 eq 'M' then begin
      cols = 1383
      rows = 586
  endif else begin
      message, 'unknown projection: ' + grid
  endelse

  if grid1 eq 'l' then scale = 1 $
  else if grid1 eq 'h' then scale = 2 $
  else message, 'unknown projection: ' + grid

  RE_km = 6371.228D
  CELL_km = 25.067525D

  Rg = scale * RE_km/CELL_km

  COS_PHI1 = .8660254038D

  r0 = (cols-1)/2.0D * scale
  s0 = (rows-1)/2.0D * scale

  x = r - r0
  y = -(s - s0)

  if (grid0 eq 'N') or (grid0 eq 'S') then begin
      rho = sqrt(x*x + y*y)
      if rho eq 0.0 then begin
          if grid0 eq 'N' then lat = 90.0D 
          if grid0 eq 'S' then lat = -90.0D 
          lon = 0.0D
      endif else begin
          if grid0 eq 'N' then begin
              sinphi1 = sin(!DPI/2.0D)
              cosphi1 = cos(!DPI/2.0D)
              if y eq 0. then begin
                  if r le r0 then lam = -!DPI/2.0D
                  if r gt r0 then lam = !DPI/2.0D
              endif else begin
                  lam = atan(x,-y)
              endelse
          endif else if grid0 eq 'S' then begin
              sinphi1 = sin(-!DPI/2.0D)
              cosphi1 = cos(-!DPI/2.0D)
              if y eq 0. then begin
                  if r le r0 then lam = -!DPI/2.0D
                  if r gt r0 then lam = !DPI/2.0D
              endif else begin
                  lam = atan(x,y)
              endelse
          endif
          gamma = rho/(2 * Rg)
          if abs(gamma) gt 1. then return, -1
          c = 2.0D * asin(gamma)
          beta = cos(c) * sinphi1 + y * sin(c) * (cosphi1/rho)
          if abs(beta) gt 1. then return, -1
          phi = asin(beta)
          lat = easeconv_rad2deg( phi )
          lon = easeconv_rad2deg( lam )
      endelse

  endif else if grid0 eq 'M' then begin
;
;	  allow .5 cell tolerance in arcsin function
;	  so that grid coordinates which are less than .5 cells
;	  above 90.00N or below 90.00S are given a lat of 90.00
;
      epsilon = 1.0D + 0.5D/Rg
      beta = y*COS_PHI1/Rg
      if abs(beta) gt epsilon then return, -1 $
      else if beta le -1. then phi = -!DPI/2.0D $
      else if beta ge 1. then phi = !DPI/2.0D $
      else phi = asin(beta)
      lam = x/COS_PHI1/Rg
      lat = easeconv_rad2deg( phi )
      lon = easeconv_rad2deg( lam )
  endif

  ;; normalize output longitude
  lon = easeconv_normalize_degrees( lon )
  
  return, 0

END ; ssmi_inverse

;+
; NAME:
;	ease_convert
;
; PURPOSE:
;       Convert geographic coordinates (lat,lon) to azimuthal equal-area
;       or cylindrical equal-area grid (col,row) coordinates for various
;       spherical or WGS84-based EASE-Grids.  Original EASE-Grid was based
;       on a spherical Earth model.  EASE-Grid-2.0 refers to the WGS84
;       ellipsoid grids.
;
; CATEGORY:
;	Grid coordinate conversion
;
; CALLING SEQUENCE:
;       status = ease_convert ( grid, lat, lon, r, s)
;
; INPUTS:
;       grid: grid name
;         Supported original (spherical) EASE-Grids:
;             SSM/I Polar Pathfinder: [NSM][lh]
;                (where l="low" res (25km), h="high" res (12.5km))
;             AVHRR Polar Pathfinder: [NS]a{1,5,25}
;                (where 1=1.25 km res, 5=5 km res, 25=25 km res)
;             TOVS-P Polar Pathfinder: NpathP (100km res)
;             AARI sea ice: AARI or (equivalent) NAARI (12.5 km res)
;             MODIS sea ice: [NS]Modis[14]km
;         Supported (WGS84) EASE-Grid-2.0 grids:
;             Grid names according to the pattern "EASE2_pxx"
;             where:
;               p = projection: 'N' (north), 'S' (south), 'M' (cylindrical)
;               xx - resolution: '25km', '12.5km', '6.25km',
;                    '36km', '09km', '03km', '01km' for all projections,
;                    and '100km' (for N projection only)
;             Example: EASE2_M25km, EASE2_M09km, etc.
;
;       lat, lon - geo. coords. (decimal degrees)
;
; OUTPUTS:
;	r, s - column, row coordinates
;
; RESULT:
;	status = 0 indicates normal successful completion
;		-1 indicates error status (point not on grid)
;               -2 unknown projection
;
; EXAMPLE:
;       status = ease_convert ('Nl',90.,0.,col,row)
;
;       status will be 0, and the returned col, row will be 360.0, 360.0
;
; NOTES:
;       Please see
;       http://nsidc.org/data/ease/ease_grid.html
;       http://nsidc.org/data/pathfinders/grid.html
;
;-
FUNCTION ease_convert, grid, lat, lon, r, s

  on_error,2

  if n_params() lt 5 then begin
      message, 'usage:  status = ease_convert (grid, lat, lon, r, s)', /info
      return, -1
  endif

;; Supported spherical (original) EASE-Grids
  grids =     ['NL','SL','ML','NH','SH','MH',$
               'NA25','SA25','NA5','SA5','NA1','SA1','NPATHP','NAARI','AARI',$
               'NMODIS1KM','SMODIS1KM','NMODIS4KM','SMODIS4KM']
  ssmi_grid = ['Nl','Sl','Ml','Nh','Sh','Mh',$
               'Nl'  ,'Sl'  ,'Nl' ,'Sl ','Nl'  ,'Sl'  ,'Nl'    ,'Nh', 'Nh', $
               'Nl'       ,'Sl'       ,'Nl'       ,'Sl']

  ingrid = strupcase(string(grid))

;; Check for EASE-Grid-2.0 (WGS84) grids
  if stregex( ingrid, '^EASE2', /boolean ) then begin
      status = wgs84_convert( ingrid, lat, lon, r, s )
      return, status
  endif

; Check for SSM/I grids
  idx = where(ingrid eq grids,count)
  if 1 ne count then begin
      message, 'unknown projection: ' + grid,/info
      return,-2
  endif

; Look up the coordinates of the corresponding SSM/I grid
  status = ssmi_convert(ssmi_grid(idx(0)), lat, lon, r, s)

; Return immediately error status or if it is an SSM/I grid
  if (-1 eq status) or (6 gt idx(0)) then return,status

; Otherwise, convert coordinates
  case ingrid of

      'NA25': begin
          cols = 361
          rows = 361
          factor = 1.0D
          offset = -180.0D
      end

      'NA5': begin
          cols = 1805
          rows = 1805
          factor = 5.0D
          offset = -898.0D
      end

      'NA1': begin
          cols = 7220
          rows = 7220
          factor = 20.0D
          offset = -3590.5D
      end

      'SA25': begin
          cols = 321
          rows = 321
          factor = 1.0D
          offset = -200.0D
      end

      'SA5': begin
          cols = 1605
          rows = 1605
          factor = 5.0D
          offset = -998.0D
      end

      'SA1': begin
          cols = 6420
          rows = 6420
          factor = 20.0D
          offset = -3990.5D
      end

      'NPATHP': begin
          cols = 67
          rows = 67
          factor = 0.25D
          offset = -57.0D
      end

      'NAARI': begin
          cols = 721
          rows = 721
          factor = 1.0D
          offset = -360.0D
      end

      'AARI': begin
          cols = 721
          rows = 721
          factor = 1.0D
          offset = -360.0D
      end

      'NMODIS1KM': begin
          cols = 18069
          rows = 18069
          factor = 25.0D
          offset = 34.0D
      end

      'SMODIS1KM': begin
          cols = 18069
          rows = 18069
          factor = 25.0D
          offset = 34.0D
      end

      'NMODIS4KM': begin
          cols = 4501
          rows = 4501
          factor = 6.25D
          offset = 0.0D
      end

      'SMODIS4KM': begin
          cols = 4501
          rows = 4501
          factor = 6.25D
          offset = 0.0D
      end

      else: message,'unrecognized grid ' + string(grid)

  endcase

  r = (r * factor) + offset
  s = (s * factor) + offset

; Check for actual grid boundaries
  if r lt -0.5D or r ge (cols - 0.5D) or $
     s lt -0.5D or s ge (rows - 0.5D) then status = -1

  return,status

end
        
            
            
;+
; NAME:
;	ease_inverse
;
; PURPOSE:
;       Convert grid coordinates (col,row) for azimuthal equal-area or
;       equal-area cylindrical grids for various spherical or WGS84-based
;       EASE-Grids to geographic coordinates (lat,lon).  Original
;       EASE-Grid was based on a spherical Earth model.  EASE-Grid-2.0
;       refers to the WGS84 ellipsoid grids.
;
; CATEGORY:
;	Grid coordinate conversion
;
; CALLING SEQUENCE:
;       status = ease_inverse ( grid, r, s, lat, lon)
;
; INPUTS:
;       grid: grid name
;         Supported original (spherical) EASE-Grids:
;             SSM/I Polar Pathfinder: [NSM][lh]
;                (where l="low" res (25km), h="high" res (12.5km))
;             AVHRR Polar Pathfinder: [NS]a{1,5,25}
;                (where 1=1.25 km res, 5=5 km res, 25=25 km res)
;             TOVS-P Polar Pathfinder: NpathP (100km res)
;             AARI sea ice: AARI or (equivalent) NAARI (12.5 km res)
;             MODIS sea ice: [NS]Modis[14]km
;         Supported (WGS84) EASE-Grid-2.0 grids:
;             Grid names according to the pattern "EASE2_pxx"
;             where:
;               p = projection: 'N' (north), 'S' (south), 'M' (cylindrical)
;               xx - resolution: '25km', '12.5km', '6.25km',
;                    '36km', '09km', '03km', '01km' for all projections,
;                    and '100km' (for N projection only)
;             Example: EASE2_M25km, EASE2_M09km, etc.
;
;	r, s - column, row coordinates
;
; OUTPUTS:
;       lat, lon - geo. coords. (decimal degrees)
;
; RESULT:
;	status = 0 indicates normal successful completion
;		-1 indicates error status (point not on grid)
;               -2 unknown projection
;
; EXAMPLE:
;       status = ease_inverse ('Nl',360.0, 360.0, lat, lon)
;
;       status will be 0, and the returned lat, lon will be 90.0, 0.0
;
;-
FUNCTION ease_inverse, grid, r, s, lat, lon

  on_error,2

  if n_params() lt 5 then begin
      message, 'usage:  status = ease_inverse (grid, r, s, lat, lon)', /info
      return, -1
  endif

  grids =     ['NL','SL','ML','NH','SH','MH',$
               'NA25','SA25','NA5','SA5','NA1','SA1','NPATHP','NAARI','AARI', $
               'NMODIS1KM','SMODIS1KM','NMODIS4KM','SMODIS4KM']
  ssmi_grid = ['Nl','Sl','Ml','Nh','Sh','Mh',$
               'Nl'  ,'Sl'  ,'Nl' ,'Sl ','Nl'  ,'Sl'  ,'Nl'    ,'Nh', 'Nh', $
               'Nl'       ,'Sl'       ,'Nl'       ,'Sl']

  ingrid = strupcase(string(grid))

;; Check for EASE-Grid-2.0 (WGS84) grids
  if stregex( ingrid, '^EASE2', /boolean ) then begin
      status = wgs84_inverse( ingrid, r, s, lat, lon )
      return, status
  endif

; Check for SSM/I grids
  idx = where(ingrid eq grids,count)
  if 1 ne count then begin
      message, 'unknown projection: ' + grid,/info
      return, -2
  endif

; Convert input col,row from other grid to SSM/I grid
  case ingrid of

      'NA25': begin
          cols = 361
          rows = 361
          factor = 1.0D
          offset = 180.0D
      end

      'NA5': begin
          cols = 1805
          rows = 1805
          factor = 0.2D
          offset = 179.6D
      end

      'NA1': begin
          cols = 7220
          rows = 7220
          factor = 0.05D
          offset = 179.525D
      end

      'SA25': begin
          cols = 321
          rows = 321
          factor = 1.0D
          offset = 200.0D
      end

      'SA5': begin
          cols = 1605
          rows = 1605
          factor = 0.2D
          offset = 199.6D
      end

      'SA1': begin
          cols = 6420
          rows = 6420
          factor = 0.05D
          offset = 199.525D
      end

      'NPATHP': begin
          cols = 67
          rows = 67
          factor = 4.0D
          offset = 228.0D
      end

      'NAARI': begin
          cols = 721
          rows = 721
          factor = 1.0D
          offset = 360.0D
      end

      'AARI': begin
          cols = 721
          rows = 721
          factor = 1.0D
          offset = 360.0D
      end

      'NMODIS1KM': begin
          cols = 18069
          rows = 18069
          factor = 0.04D
          offset = -1.36D
      end

      'SMODIS1KM': begin
          cols = 18069
          rows = 18069
          factor = 0.04D
          offset = -1.36D
      end

      'NMODIS4KM': begin
          cols = 4501
          rows = 4501
          factor = 0.16D
          offset = 0.0D
      end

      'SMODIS4KM': begin
          cols = 4501
          rows = 4501
          factor = 0.16D
          offset = 0.0D
      end

      else: begin
          factor = 1.0D
          offset = 0.0D
      end

  endcase

  ssmi_r = (r * factor) + offset
  ssmi_s = (s * factor) + offset

; Look up the coordinates of the corresponding SSM/I grid
  status = ssmi_inverse(ssmi_grid(idx(0)), ssmi_r, ssmi_s, lat, lon)

; Return immediately error status or if it is an SSM/I grid
  if (-1 eq status) or (6 gt idx(0)) then return,status

; Check for actual grid boundaries
  if r lt -0.5D or r ge (cols - 0.5D) or $
     s lt -0.5D or s ge (rows - 0.5D) then return,-1

; Set rnew and snew using computed lat and lon
  status = ease_convert(grid, lat, lon, rnew, snew)

; Check for actual grid boundaries
  if rnew lt -0.5D or rnew ge (cols - 0.5D) or $
     snew lt -0.5D or snew ge (rows - 0.5D) then status = -1

  return,status

end

