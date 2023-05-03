# SAS

Objective : run OPA and SI3 in a couple mode via OASIS

Example run : https://github.com/brodeau/nemo_conf_manager/tree/master/TEST_RUN/NANUK1/TEST_NANUK1_SAS_ICE_OA3_4.0/LBOOS00

 - [x] install OASIS-MCT and compile XIOS accordingly (cf [doc for oasis](oasis.md) )
 - [x] compile NEMO twice :
    - once without ICE and key_si3 (nor key_isf) but with key_oasis : it is opa executable
    - once with ICE and key_si3, key_isf and key_oasis : it is sas executable
