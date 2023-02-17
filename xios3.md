# Implémentation XIOS3

- get xios3 : ```svn co https://forge.ipsl.jussieu.fr/ioserver/svn/XIOS3/branches/xios-3.0-beta```
- compile it with arch-X64-JEANZAY_jmm : ```./make_xios --arch X64_JEANZAY --job 8``` (after a clean up with ```rm -rf ppsrc obj tmp lib bin inc flags done cfg etc Makefile config.fcm arch.*```)
- get nemo commit : ```commit=389a917643f84804f6c7c6cb61c33007bc9a7b20; git clone https://forge.nemo-ocean.eu/nemo/nemo.git NEMO4; cd NEMO4 ; git checkout $commit```
- compile NEMO with key_xios3 and key_vco_1d3d on top of key_xios
- phase DCM_4.2 with this new version of NEMO : https://github.com/auraoupa/DCM-master/blob/master/DOC/2022-02-09-AA_porting_DCM_4.2_main.md

