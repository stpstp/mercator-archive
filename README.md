# mercator-archive
Data archive for the Mercator Observatory

##
Configuration for online VO-compliant data archive for the Mercator Observatory.


## Data products to be included
HERMES: 1D merged/stitched spectra No.    Name      Ver    Type      Cards   Dimensions   Format \
  0  PRIMARY       1 PrimaryHDU     507   (167781,)   float64   \
  1  INSTRUMENTCONFIG.XML    1 BinTableHDU     11   191R x 1C   [1020A]   


### Future plans
MELCHIORS : relocate to IvS

marvel (whenever we will have real data...)

## Description of HERMES 1D merged/stitched spectra
1D merged object spectrum. Cosmic-clipped, logarithmic rebinned, barycentric velocity corrected

No.    Name      Ver    Type      Cards   Dimensions   Format                                
  0  PRIMARY       1 PrimaryHDU     507   (167781,)   float64                                   
  1  INSTRUMENTCONFIG.XML    1 BinTableHDU     11   191R x 1C   [1020A]                          


Example: subset of FITS header cards from primary header 01140316_HRF_OBJ_ext_CosmicsRemoved_log_merged_c.fits


SIMPLE  =                    T / conforms to FITS standard                      
BITPIX  =                  -64 / array data type                                
NAXIS   =                    1 / number of array dimensions                     
NAXIS1  =               167781                                                  
EXTEND  =                    T    

CRPIX1  =                  1.0 / merge                                          No.    Name      Ver    Type      Cards   Dimensions   Format
  0  PRIMARY       1 PrimaryHDU     507   (167781,)   float64   
  1  INSTRUMENTCONFIG.XML    1 BinTableHDU     11   191R x 1C   [1020A]   

CRVAL1  =    8.233001142676553 / merge                                          
CDELT1  = 5.20050525665283E-06 / merge                                          
CTYPE1  = 'log(wavelength)'    / merge        

DATE-OBS= '2025-06-01T21:04:17.546854' / Start of observation                   
DATE-END= '2025-06-01T21:04:52.549361' / End of observation                     
DATE-AVG= '2025-06-01T21:04:35.048108' / Midpoint of observation                
DATE    = '2025-06-01T21:05:42.630911' / Time of file creation                  
BJD     =      2460828.3763691 / Barycentric Julian Date of midpoint            
BVCOR   =           -27.951436 / [km/s] Barycentric rv correction at midpoint   
EXPTIME =                   35 / Exposure time                                  

OBJECT  = 'HD 82106'           / Object name                          \                                  
EQUINOX =               2000.0 / Equinox of coordinates               \         
RADECSYS= 'FK5     '           / Coordinate system                    \              
RA      =            142.47833 / [deg] Right ascension                \                                  
DEC     =              5.65514 / [deg] Declination                    \       

