
There are 6 folders for the VHDL source code of different implementations of CRAFT. 
Apart from the unprotected implementation, all other designs MUST be synthesized by "keeping the hierarchy".
Otherwise, no fault-detection and no protection against SCA is guaranteed.

For each design (in each folder) the main module is called "Cipher" and can be found in "Cipher.vhd" file.
The main module (in all variants) has 2 generics:

- withTweak  : 1/0 defines whether the 64-bit Tweak is taken into account
- withDec    : 1/0 defines if the decryption functionality should be supported

----------------------------------------------------------------------------------------------------------------------

The folders:

* CRAFT_no_protection

  No protection against SCA and fault detection is integrated into the design.

----------------------------------------------------------------------------------------------------------------------

* CRAFT_red1,2,3

  Fault-detection facility is added to the design for redundancy size < 4.
  In addition to withTweak and withDec, the main module has 4 other generics:

  - Red_size     : 1/2/3 defines the size of the redundancy

  - LF           : is the look-up table of the generator function of the underlying code. 
                   Examplary correct corresponding values for each Red_size (1/2/3) are given inside "Cipher.vhd" file.

  - LFC          : is a constant which can be added to the look-up table LF. It can be simply set to x"0".

  - MultiVariate : 1/0 defines whether Univariate or Multivariate adversary model is considered.

----------------------------------------------------------------------------------------------------------------------

* CRAFT_red4

  Fault-detection facility is added to the design for redundancy size = 4.
  In addition to withTweak and withDec, the main module has 3 other generics:

  - LF           : is the look-up table of the generator function of the underlying code. 
                   Examplay correct corresponding value is given as the default value.

  - LFC          : 0...F is a constant which can be added to the look-up table LF. It can be simply set to x"0".

  - MultiVariate : 1/0 defines whether Univariate or Multivariate adversary model is considered.

----------------------------------------------------------------------------------------------------------------------

* CRAFT_TI
 
  SCA-protected design by means of Threshold Implementation with 3 shares.
  In addition to withTweak and withDec, the main module has 1 other generic:
  
  - withKeyMasking  : 1/0 defines whether the key should be also masked (with 3 shares).
                      It is useful to not mask the key if protection against Template Attacks is not required.
                      
----------------------------------------------------------------------------------------------------------------------

* CRAFT_TI_red1,2,3

  SCA-protected design by means of Threshold Implementation with 3 shares.
  Fault-detection facility is also added to the design for redundancy size < 4.
  In addition to withTweak and withDec the main module has 5 other generics:

  - Red_size        : 1/2/3 defines the size of the redundancy

  - LF              : is the look-up table of the generator function of the underlying code. 
                      Examplary correct corresponding values for each Red_size (1/2/3) are given inside "Cipher.vhd" file.

  - LFC             : is a constant which can be added to the look-up table LF. It can be simply set to x"0".

  - MultiVariate    : 1/0 defines whether Univariate or Multivariate adversary model is considered.

  - withKeyMasking  : 1/0 defines whether the key should be also masked (with 3 shares).
                      It is useful to not mask the key if protection against Template Attacks is not required.

----------------------------------------------------------------------------------------------------------------------

* CRAFT_TI_red4

  SCA-protected design by means of Threshold Implementation with 3 shares.
  Fault-detection facility is added to the design for redundancy size = 4.
  In addition to withTweak and withDec, the main module has 4 other generics:

  - LF              : is the look-up table of the generator function of the underlying code. 
                      Examplay correct corresponding value is given as the default value.

  - LFC             : 0...F is a constant which can be added to the look-up table LF. It can be simply set to x"0"

  - MultiVariate    : 1/0 defines whether Univariate or Multivariate adversary model is considered.

  - withKeyMasking  : 1/0 defines whether the key should be also masked (with 3 shares).
                      It is useful to not mask the key if protection against Template Attacks is not required.

----------------------------------------------------------------------------------------------------------------------
