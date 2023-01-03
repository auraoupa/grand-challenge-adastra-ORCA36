# All the test runs with eORCA05.L121 configuration performed on Jean-Zay

All the input and forcing files are constructed following [JMM's instructions](https://github.com/auraoupa/grand-challenge-adastra-ORCA36/tree/AAjeanzay/eORCA05) and [my tuto](https://github.com/auraoupa/grand-challenge-adastra-ORCA36/blob/AAjeanzay/eORCA05/tuto-AA.md)

List of the runs :

  - **eORCA05.L121-JZAA009** = eORCA05.L121-JZAA008 + ubs for momentum  : 1.73 sec/time-step (+4%)
  - **eORCA05.L121-JZAA008** = eORCA05.L121-JZAA007 + gls instead of tke, no evd  : 1.67 sec/time-step (+7%)
  - **eORCA05.L121-JZAA007** = eORCA05.L121-JZAA006 + ice_shelf & cavities (new domain file, no init, FCT order 2 instead of 4) : 1.56 sec/time-step (-10%)
  - **eORCA05.L121-JZAA006** = eORCA05.L121-JZAA005 + tide (M2,S2,N2,O1,K1) : 1.74 sec/time-step (+5%)
  - **eORCA05.L121-JZAA005** = eORCA05.L121-JZAA004 on 2 nodes (78 cores for NEMO, 2 cores for XIOS, 11x9 decomposition): 1.67 sec/time-step (-50%)
  - **eORCA05.L121-JZAA004** = eORCA05.L121-JZAA003 w latest XIOS_trunk (rev 2418) : 3.35 sec/time-step (-1%)
  - **eORCA05.L121-JZAA003** = reference : 3.39 sec/time-step (-1%)
    - *NEMO version* :  4.2 commit 9fd6392
    - *XIOS version* : trunk rev 2313
    - *DRAKKAR* : yes
    - *CPP.keys* : key_netcdf4, key_qco, key_si3, key_xios, key_drakkar
    - *Time-Step* : 1200s
    - *Nb NEMO cores* : 40
    - *Nb XIOS cores* : 2
    - *decomposition jpnixjpnj* : 9x5
    - *tide* : no


