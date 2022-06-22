# Calving file
## 1. Context
NEMO can represent explicitly the iceberg calving and melting, via the ICB module. This
module is fed by information about where calving take place, and how much is calved there.
Calving file is used to pass this information to NEMO. Dataset used for building this file
is an annual climatology of calving rate (GT/year) for each identified iceshelf, around 
Antarctica. We assume that iceberg calving takes place at the iceshelf front. So a first
important task is to define the iceshelve on the model grid. Second, is to repart the calving
rate on the calving points at the front of the icesheve, in a clever way.  
Reparting the calving rate evenly on the calving points of an iceshelf should produce a uniform
calving pattern, in time and space, which is not very realistic. Pierre Mathiot develop an 
algorithm which avoid this problem: He used a random repartition of the calving rate for each
iceshelf among the calving points, and ensure that the total amount is conserved.

## 2. Iceshelf definition

## 3. Calving rate.

