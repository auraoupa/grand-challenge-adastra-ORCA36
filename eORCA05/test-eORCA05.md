# All the test runs with eORCA05.L121 configuration performed on Jean-Zay

All the input and forcing files are constructed following [JMM's instructions](https://github.com/auraoupa/grand-challenge-adastra-ORCA36/tree/AAjeanzay/eORCA05) and [my tuto](https://github.com/auraoupa/grand-challenge-adastra-ORCA36/blob/AAjeanzay/eORCA05/tuto-AA.md)

List of the runs :

| Name of the run | NEMO version | XIOS version | DRAKKAR | prev_conf | CPP.keys | Status |
|-------|---|--|--|---------|---|
| eORCA05.L121-JAAZ001 | 4.2 commit 9fd6392 | trunk rev 2418 | no | no | key_si3, key_xios, key_qco, key_isf | Failed : xios segmentation fault |
| eORCA05.L121-JAAZ002 | 4.2 commit 9fd6392 | trunk rev 2313 | no | no | key_si3, key_xios, key_qco, key_isf | Failed : xios abort trap signal |
| MED025.L75-JZAA001 | 4.2 commit 9fd6392 | trunk rev 2313 | yes | MED025.L75-GJM421 | key_netcdf4, key_qco, key_si3, key_xios, key_drakkar | run ok for 3 months |
| eORCA05.L121-JAAZ002 | 4.2 commit 9fd6392 | trunk rev 2313 | no | no | key_si3, key_xios, key_qco, key_isf | Failed : xios abort trap signal |
