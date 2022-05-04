# Grand Challenge Adastra : une simulation ORCA36

Dans ce répertoire seront regroupées toutes les informations relatives à la simulation ORCA36 produite dans le cadre du grand Challenge Adastra.

## Calendrier

Date de soumission du projet : été 2022

Date de réalisation de la simulation : entre octobre 2022 et avril 2023 (peut être décalé de 3-5 mois cf GENCI)


## Set-up expérimental

ORCA36 : configuration développée à Mercator Océan dans le cadre du projet IMMERSE : https://github.com/immerse-project/ORCA36-demonstrator/

Quelques caractéristiques :
  - 2-3km de résolution, 12960 x 10776 points de grille (= 3,5 x eNATL60)
  - tourne sur 18000 coeurs minimum, 50 000 coeurs  (cible)
  - estimation du coût : 3.5 MHCPU/an (ref : MareMostrum4 au BSC)
  - 1 champ 3D 75niveaux ~ 40 Gb (ref eNATL60 : 12GB)


Les choix à faire :

  - [x] version de NEMO : NEMO 4.2.0 
  - [x] marées
  - [ ] <details>
<summary>run long ou ensemble ? </summary>
```
CODE!
```
</details>

  - [ ] marée réaliste (quelles fréquences) ou centrées sur 12h, 24h pour mieux les filtrer ?
  - [ ] ice shelves ?
  - [ ] combien de niveaux verticaux 75 ou 150 ? 
  - [ ] forçages atmosphériques ?
  - [ ] paramètrisation ABL 1d ?
 
  ~~- [ ] runge-kutta ? pas prêt à temps pour le challenge~~

## Argumentaire scientifique

  - pour la demande auprès de GENCI :
 > Une simulation globale à très haute résolution avec la marée pour accompagner la mission SWOT, préparatoire à la mission WaCM

  - ce qui va être étudié avec la simulation au sein de l'IGE (et les spécifications associées) :
 > - algorithmes de mapping zones cross-over SWOT (sorties 3D horaires dans ces régions + version barotrope du modèle)
 > - étude de l'impact des tourbillons sur les transports de masse d'eau sur le plateau antartique (ouverture cavités Antartique + marée réaliste + bonne bathymétrie) 
 > - étude de la subsurface (stratégie d'outputs 3D adaptée)
 > - étude des incertitudes et de l'intrinsèque (plusieurs membres, 2 x 2 ans minimum)
 > - étude des trajectoires lagrangiennes de la glace de mer aux 2 pôles (sorties horaires des vitesses de dérive de la glace partout + pas dernière version SI3)
 > - étude des tourbillons et impact de la mésoéchelle (termes croisés calculés au pas de temps et sorties mensuelles)
 > - étude de l'impact des tourbillons sur le recul des zones englacées dans la zone marginale (?)


## Plan d'archivage

Stratégie d'outputs 3D horaires impossible.
  - 3D horaire dans quelques régions ? lesquelles ?
  - pseudo-obs :
    - [ ] ARGO
    - [ ] Nadir
    - [ ] trajectoires lagrangiennes
    - [ ] courantomètres

Stockage long-terme au CINES, utilisation sur Data Terra ?

## Les actions

Après [meeting du 20/04/2022](https://github.com/auraoupa/grand-challenge-adastra-ORCA36/blob/main/meetings/20220420.md) :

  -  [ ] checker la bathy
  -  [ ] outputs de glace Antartique simu Mercator
  -  [ ] plus de questions scientifiques ?
  -  [ ] discuter avec Camille et Claude pour la glace
  -  [ ] discuter avec Mercator pour faire qq chose complémentaire
  -  [ ] quantifier stratégie outputs
  -  [ ] démarrer config toy dès que possible
  -  [ ] check branche xios/nemo pour lire forçages avec xios
