# Grand Challenge Adastra : une simulation ORCA36

Dans ce répertoire seront regroupÃ©es toutes les informations relatives Ã  la simulation ORCA36 produite dans le cadre du grand Challenge Adastra.

## Calendrier

Date de soumission du projet : Ã©tÃ© 2022

Date de rÃ©alisation de la simulation : entre octobre 2022 et avril 2023 (peut Ãªtre dÃ©calÃ© de 3-5 mois cf GENCI)

## Argumentaire scientifique

### Pour la demande auprÃ¨s de GENCI :

 Une simulation globale Ã  trÃ¨s haute rÃ©solution avec la marÃ©e pour accompagner la mission SWOT, prÃ©paratoire Ã  la mission WaCM

### Les Ã©tudes prÃ©vues avec la simulation au sein de l'IGE (et les spÃ©cifications associÃ©es) :

 - Algorithmes de mapping zones cross-over SWOT (sorties 3D horaires dans ces rÃ©gions + version barotrope du modÃ¨le)
 - Etude de l'impact des tourbillons sur les transports de masse d'eau sur le plateau antartique (ouverture cavitÃ©s Antartique + marÃ©e rÃ©aliste + bonne bathymÃ©trie) 
 - Etude de la subsurface (stratÃ©gie d'outputs 3D adaptÃ©e)
 - Etude des incertitudes et de l'intrinsÃ¨que (plusieurs membres, 2 x 2 ans minimum)
 - Etude des trajectoires lagrangiennes de la glace de mer aux 2 pÃ´les (sorties horaires des vitesses de dÃ©rive de la glace partout + pas derniÃ¨re version SI3)
 - Etude des tourbillons et impact de la mÃ©soÃ©chelle (termes croisÃ©s calculÃ©s au pas de temps et sorties mensuelles)
 - Etude de l'impact des tourbillons sur le recul des zones englacÃ©es dans la zone marginale (?)


## Set-up expÃ©rimental

ORCA36 : configuration dÃ©veloppÃ©e Ã  Mercator OcÃ©an dans le cadre du projet IMMERSE : https://github.com/immerse-project/ORCA36-demonstrator/

### Quelques caractÃ©ristiques

  - 2-3km de rÃ©solution, 12960 x 10776 points de grille (= 3,5 x eNATL60)
  - tourne sur 18000 coeurs minimum, 50 000 coeurs  (cible)
  - estimation du coÃ»t : 3.5 MHCPU/an (ref : MareMostrum4 au BSC)
  - 1 champ 3D 75niveaux ~ 40 Gb (ref eNATL60 : 12GB)


### Les choix Ã  faire

La namelist du run de Mercator : https://raw.githubusercontent.com/immerse-project/ORCA36-demonstrator/main/NAMLST/namelist_cfg

#### Les choix actÃ©s

  - [x] version de NEMO : NEMO 4.2.0 (attention version/param SI3)
  - [x] marÃ©e rÃ©aliste
  - [x] ouverture cavitÃ©s (mieux pour la marÃ©e et Ã©tudes antartiques)
  - [x] param Renault et al.
  - [x] skin temperature Brodeau 

#### Presque actÃ©s, Ã  tester/quantifier avant mise en place

  - [ ] SAS et SI3 via OASIS
  - [ ] GLS pour turbulence verticale (idem Mercator)
<details>
<summary> stratÃ©gie outputs </summary>
 
   - [ ] quelques sorties pendant le spin-up, le maximum possible pour les derniÃ¨res annÃ©es 
   - [ ] sorties horaires de surface + certaines profondeurs (100m, 1000m)
   - [ ] sorties journaliÃ¨res 3D
   - [ ] sorties horaires 3D quelques rÃ©gions cross-over
   - [ ] sorties horaires sections, profils
   - [ ] moyennes mensuelles termes croisÃ©s calculÃ©s au pas de temps
   - pseudo-obs :
     - [ ] ARGO
     - [ ] traces satellite Nadir
     - [ ] courantomÃ¨tres
  
</details>

#### Encore en discussion

<details>
<summary> run long ou ensemble ? </summary>
  
   - [ ] un run le plus long possible (POUR : un seul run Ã  gÃ©rer/ CONTRE : plus de chances de tomber sur un blocage, dÃ©rive par rapport bonne stratification)
   - [ ] un spin-up + 2 membres (POUR : suffisant pour dÃ©velopper un spread / CONTRE : pas assez de membres pour Ã©tude dÃ©cohÃ©rences)
   - [ ] un spin-up + x membres (POUR : mieux pour dÃ©cohÃ©rences / CONTRE : complexitÃ© de la gestion des runs)
  
</details>

<details>
<summary> nombre de niveaux ? </summary>
  
   - [ ] 75 (POUR : taille des outputs/ CONTRE : pas suffisant pour les fines Ã©chelles par rapport Ã  la rÃ©solution horizontale)
   - [ ] 121 (POUR : bien adaptÃ©e pour glace antartique / CONTRE : )
   - [ ] 150 (POUR: encore mieux pour les fines Ã©chelles, overflows / CONTRE : outputs 2X plus gros)
  
</details>

<details>
<summary> forÃ§ages atmosphÃ©riques ? </summary>
 
   - [ ] ERA5 (POUR : meilleure rÃ©solution / CONTRE : chocs Ã  chaque analyses, flux des inputs trop gros pour l'instant)
   - [ ] JRA55 (POUR : mieux connus / CONTRE : basse rÃ©solution)
   - [ ] utilisation avec XIOS peut Ãªtre une solution
  
</details>

<details>
<summary> Ã©tat initial ? </summary>
 
   - [ ] restart simulation ClÃ©ment Bricaud
   - [ ] rÃ©analyse GLORYS12 (moyenne mensuelle)
   - [ ] Ã©tat initial dans les cavitÃ©s Ã  construire (Pierre Mathiot)
  
</details>


<details>
<summary> durÃ©e spin-up ? </summary>
 
   - [ ] 1 an
   - [ ] 2 ans
   - [ ] x annÃ©es (HYCOM 15 ans...)
  
</details>


<details>
<summary> ParamÃ¨tres ? </summary>
 
   - [ ] UBS pour momentum (idem Mercator)
   - [ ] FCT pour traceurs (idem Mercator ordre 4)
   - [ ] forÃ§age pression atmosphÃ©rique (idem Mercator, fichier ECWF horaire)
   - [ ] paramÃ¨tres viscositÃ©
   - [ ] QCO ? (=vvl dÃ©gradÃ©)
  
</details>


## Les actions

  -  [ ] discuter avec Mercator (notre proposition, leur approche avec cette config, discussion de leurs choix de param)
  -  [ ] checker la bathy
  -  [ ] rÃ©cupÃ©rer outputs de la derniÃ¨re simu Mercator 
  -  [ ] discuter avec Camille et Claude pour paramÃ¨trisation glace arctique
  -  [ ] quantifier stratÃ©gie outputs Ã  la louche pour une premiÃ¨re
  -  [ ] dÃ©marrer config toy dÃ¨s que possible (test certaines fonctionnalitÃ©s, quantification outputs)
  -  [ ] check branche xios/nemo pour lire forÃ§ages avec xios
  -  [ ] commencer la rÃ©daction de la demande d'heures : [modÃ¨le formulaire GPU](https://docs.google.com/document/d/1hfe0EdBwWCY52-W0kdYwhFOb29nzBpP7jlnIukLYfNE/edit?usp=sharing)
  -  [ ] [CrÃation d'une maquette avec eORCA05:](eORCA05/README.md)
