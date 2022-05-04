# Grand Challenge Adastra : une simulation ORCA36

Dans ce répertoire seront regroupées toutes les informations relatives à la simulation ORCA36 produite dans le cadre du grand Challenge Adastra.

## Calendrier

Date de soumission du projet : été 2022

Date de réalisation de la simulation : entre octobre 2022 et avril 2023 (peut être décalé de 3-5 mois cf GENCI)

## Argumentaire scientifique

### pour la demande auprès de GENCI :

 Une simulation globale à très haute résolution avec la marée pour accompagner la mission SWOT, préparatoire à la mission WaCM

### Les études prévues avec la simulation au sein de l'IGE (et les spécifications associées) :

 - Algorithmes de mapping zones cross-over SWOT (sorties 3D horaires dans ces régions + version barotrope du modèle)
 - Etude de l'impact des tourbillons sur les transports de masse d'eau sur le plateau antartique (ouverture cavités Antartique + marée réaliste + bonne bathymétrie) 
 - Etude de la subsurface (stratégie d'outputs 3D adaptée)
 - Etude des incertitudes et de l'intrinsèque (plusieurs membres, 2 x 2 ans minimum)
 - Etude des trajectoires lagrangiennes de la glace de mer aux 2 pôles (sorties horaires des vitesses de dérive de la glace partout + pas dernière version SI3)
 - Etude des tourbillons et impact de la mésoéchelle (termes croisés calculés au pas de temps et sorties mensuelles)
 - Etude de l'impact des tourbillons sur le recul des zones englacées dans la zone marginale (?)


## Set-up expérimental

ORCA36 : configuration développée à Mercator Océan dans le cadre du projet IMMERSE : https://github.com/immerse-project/ORCA36-demonstrator/

### Quelques caractéristiques

  - 2-3km de résolution, 12960 x 10776 points de grille (= 3,5 x eNATL60)
  - tourne sur 18000 coeurs minimum, 50 000 coeurs  (cible)
  - estimation du coût : 3.5 MHCPU/an (ref : MareMostrum4 au BSC)
  - 1 champ 3D 75niveaux ~ 40 Gb (ref eNATL60 : 12GB)


### Les choix à faire

#### Les choix actés

  - [x] version de NEMO : NEMO 4.2.0 (attention version/param SI3)
  - [x] marée réaliste
  - [x] ouverture cavités (mieux pour la marée et études antartiques)

#### A tester et quantifier avant mise en place

  - [ ] SAS et SI3 via OASIS
  - [ ] stratégie outputs
 
#### Encore en discussion

<details>
<summary> run long ou ensemble ? </summary>
  
Les options (POUR/CONTRE) :
  
   - un run le plus long possible (POUR : un seul run à gérer/ CONTRE : plus de chances de tomber sur un blocage, dérive par rapport bonne stratification)
   - un spin-up + 2 membres (POUR : suffisant pour développer un spread / CONTRE : pas assez de membres pour étude décohérences)
   - un spin-up + x membres (POUR : mieux pour décohérences / CONTRE : complexité de la gestion des runs)
  
</details>

<details>
<summary> nombre de niveaux ? </summary>
  
Les options (POUR/CONTRE) :
  
   - 75 (POUR : taille des outputs/ CONTRE : pas suffisant pour les fines échelles par rapport à la résolution horizontale)
   - 121 (POUR : bien adaptée pour glace antartique / CONTRE : )
   - 150 (POUR: encore mieux pour les fines échelles / CONTRE : outputs 2X plus gros)
  
</details>

<details>
<summary> forçages atmosphériques </summary>
  
Les options (POUR/CONTRE) :
  
   - ERA5 (POUR : meilleure résolution / CONTRE : chocs à chaque analyses, flux des inputs trop gros pour l'instant)
   - JRA55 (POUR : mieux connus / CONTRE : basse résolution)
  
</details>



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
