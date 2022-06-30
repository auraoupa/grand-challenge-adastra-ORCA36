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


