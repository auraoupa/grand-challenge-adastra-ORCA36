# Grand Challenge Adastra : une simulation ORCA36

Dans ce répertoire seront regroupées toutes les informations relatives à la simulation ORCA36 produite dans le cadre du grand Challenge Adastra.

## Calendrier

Date de soumission du projet : été 2022
Date de réalisation de la simulation : entre octobre 2022 et avril 2023


## Set-up expérimental

ORCA36 : configuration développée à Mercator Océan dans le cadre du projet IMMERSE : https://github.com/immerse-project/ORCA36-demonstrator/

Quelques caractéristiques :
  - 2-3km de résolution, 12960 x 10776 points de grille (= 3,5 x eNATL60)
  - tourne sur 18000 coeurs minimum, 50 000 coeurs  (cible)
  - estimation du coût : 3.5 MHCPU/an (ref : MareMostrum4 au BSC)
  - 1 champ 3D 75niveaux ~ 40 Gb


Les choix à faire :

  - [x] version de NEMO : NEMO 4.2.0 
  - [x] marées
  - [ ] run long ou ensemble ?
  - [ ] marée réaliste (quelles fréquences) ou centrées sur 12h, 24h pour mieux les filtrer ?
  - [ ] ice shelves ?
  - [ ] combien de niveaux verticaux 75 ou 150 ? 
  - [ ] forçages atmosphériques ?
  - [ ] paramètrisation ABL 1d ?
  - [ ] runge-kutta ?

## Argumentaire scientifique

Une simulation globale à très haute résolution avec la marée pour accompagner la mission SWOT, préparatoire à la mission WaCM

## Plan d'archivage

Stratégie d'outputs 3D horaires impossible.
  - 3D horaire dans quelques régions ? lesquelles ?
  - pseudo-obs :
    - [ ] ARGO
    - [ ] Nadir
    - [ ] trajectoires lagrangiennes
    - [ ] courantomètres

Stockage long-terme au CINES, utilisation sur Data Terra ?
