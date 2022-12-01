# All the test runs with eORCA05.L121 configuration performed on Jean-Zay

All the input and forcing files are constructed following [JMM's instructions](https://github.com/auraoupa/grand-challenge-adastra-ORCA36/tree/AAjeanzay/eORCA05) and [my tuto](https://github.com/auraoupa/grand-challenge-adastra-ORCA36/blob/AAjeanzay/eORCA05/tuto-AA.md)

List of the runs :

| Name of the run | NEMO version | XIOS version | DRAKKAR | prev_conf | CPP.keys | Status | Perf | Time-Step |
|-------|---|--|--|---------|---|--|--|
| eORCA05.L121-JAAZ001 | 4.2 commit 9fd6392 | trunk rev 2418 | no | no | key_si3, key_xios, key_qco, key_isf | Failed : xios segmentation fault | - | 1080s |
| eORCA05.L121-JAAZ002 | 4.2 commit 9fd6392 | trunk rev 2313 | no | no | key_si3, key_xios, key_qco, key_isf | Failed : xios abort trap signal | - | 1080s |
| MED025.L75-JZAA001 | 4.2 commit 9fd6392 | trunk rev 2313 | yes | MED025.L75-GJM421 | key_netcdf4, key_qco, key_si3, key_xios, key_drakkar | run ok for 3 months | 0.095 sec/time-step | 1200s |
| eORCA05.L121-JAAZ003 | 4.2 commit 9fd6392 | trunk rev 2313 | yes | MED025.L75-JZAA001 | key_netcdf4, key_qco, key_si3, key_xios, key_drakkar | run ok for 15 days | 3.39 sec/time-step | 1200s |
