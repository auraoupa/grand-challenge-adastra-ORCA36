# How to make eORCA05 run on jean zay following [JMM tuto](https://github.com/auraoupa/grand-challenge-adastra-ORCA36/tree/main/eORCA05)

## Installation on jean-zay

  - on my local machine : ```sshfs rote001@jean-zay.idris.fr:/gpfswork/rech/eee/rote001/git ssh-jean-zay-git``` (failed to make git work on jean zay, pb of ssh keys ...; assumes that ssh-jean-zay-git exists)
  - create a personnal branch : ```git checkout -b AAjeanzay main```
  - add some content on the github repo :

```
git add *
git commit -m 'add to my branch'
git push --set-upstream origin AAjeanzay
```

## Grid and bathymetry
### Compile the tools

```
cd BUILD/HGR/
make all #Makefile already adapted to jean-zay
```

### Create the grid

```
ln -sf /gpfswork/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-I/eORCA025.L75_domain_cfg_closed_seas_greenland.nc eORCA025.L75_domain_cfg.nc
ln -sf /gpfswork/rech/cli/rcli002/ORCA05/ORCA05-I/ORCA05_domain_cfg.nc .
mkorca05
```

This will produce eORCA05 coordinates, with the southern extension already present in eORCA025.

### Create the bathy

Get the eORCA025 from cal1:/mnt/meom/MODEL_SET : ```scp eORCA025.L75/eORCA025.L75-I/eORCA025_bathymetry_b0.2_closed_seas.nc rote001@jean-zay.idris.fr:/gpfswork/rech/eee/rote001/git/grand-challenge-adastra-ORCA36/eORCA05/BUILD/HGR/.```

Then on jean-zay :
```
ln -sf /gpfswork/rech/cli/rcli002/ORCA05/ORCA05-I-original/ORCA05_bathy_meter_v2.nc .
./mkbathy05
```






