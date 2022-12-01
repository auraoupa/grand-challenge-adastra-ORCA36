# Demande d'heures pour le grand Challenge CPU Adastra

Dans ce document les questions du dossier à soumettre sont recopiées et une première tentative de remplissage est proposée

Pour l'instant les questions relatives au projet CPU ne sont pas connues, je me suis basée sur les questions pour le grand Challenge GPU

## Contexte, enjeux et objectifs généraux

### Nom du Grand Challenge

ORCA36 : expérience numérique de l'océan global à très haute résolution avec simulation explicite de la marée

### Comité Thématique (CT1 à CT10)

CT1

### Objectifs du Grand Challenge, enjeu scientifique ou sociétal …

L'objectif principal de cette simulation numérique de l'océan global à très haute résolution est d'accompagner l'exploitation des données de la mission altimétrique SWOT et de préparer les futures missions d'observation des courant de surface (comme ODYSEA).  

### Description de l’étude

L'étude consiste à produire plusieurs années de simulation réaliste de l'océan global à une résolution de xx km en incluant le forçage explicite de la marée. Les résultats de cette simulation seront ensuite utilisés pour préparer les algorithmes de mapping du niveau de la mer observé par le satellite SWOT ainsi que de reconstruction de la dynamique de surface et subsurface ...

### Originalité et apports de l’étude, motivations particulières

Il s'agit d'une simulation frontière en terme de résolution qui répondra à de multiples questions scientifiques, notamment aux 2 pôles ...

### Variables dimensionnantes du calcul : nombre de mailles, nombre de particules, nombre d’atomes, etc.

Grille du modèle : 12960 x 10776 x 75 (ou 121) x nb pas de temps

### Résultats spécifiques attendus

## Coordonnées du porteur de projet



### Nom

Jean-Marc Molines (pour que ça passe) ou Aurélie Albert (pour qu'ils me connaissent) ?

### Organisme/laboratoire d’appartenance

CNRS, IGE

### Adresse électronique institutionnelle

### Téléphone professionnel

## Description de l’équipe projet

### Nombre de personnes avec statuts, fonctions et appartenance

- Julien Le Sommer, DR CNRS, IGE
- Thierry Penduff, DR CNRS, IGE
- Nicolas Jourdain, IGE
- Pierre Mathiot, IGE
- Clément Bricaud, MOI
- Romain Bourdalle-Badie, MOI
- Pierre Rampal, IGE
- Clément Ubelmann, Datlas
- Laurent Brodeau, Datlas/IGE

## Estimation des ressources de calcul nécessaires et de la durée du projet

1 an à 121 niveaux = 6MhCPU
10 ans = 60MhCPU sur 6 mois ?

### Nombre de GPU utilisés simultanément

Entre 18 000 et 50 000 coeurs soit entre 190 et 520 processeurs Genoa EPYC à 96 coeurs

### Allocation d’heures demandée pour le projet, en nombre d’heures GPU

100MhCPU ?

### Taille mémoire par GPU nécessaire

### Indication sur la distribution des travaux en durée et en nombre de GPU ou de nœuds

### Date estimée de démarrage du projet

### Durée estimée du projet, si toutes les ressources demandées sont disponibles.

### Entrées/sorties : volumétrie totale 

### Entrées/sorties : intensité (débits, IOPS)

## DMP	

### Volume généré dans l’espace de travail temporaire (SCRATCH)

### Volume généré dans l’espace de travail permanent (WORK)

### Post-traitement sur architecture parallèle 

### Durée typique du traitement d’un run

### Durée totale de post-traitement des données

## Codes utilisés et dépendances

### Le projet a-t-il déjà tourné sur Jean Zay GPU ou machine GPU similaire ?
sur MAreNostrum et Occigen ?

### Numéro DARI si le porteur de projet a déjà postulé

### Nom du code principal

NEMO version 4.2.0 + xios

### Type de code (éléments finis, Monte Carlo, embarrasingly parallel, etc.), équations discrétisées, méthodes numériques, caractéristiques des réseaux de neurones, etc.

équation primitives

### Configuration et nombre de GPU sur lesquels le code a déjà été utilisé

eNATL60 : 40MhCPU avec 18 000 coeurs simultanément

### Langage utilisé : C, C++, Fortran, Python, …

fortran

### Type et version du compilateur : GCC, PGI, …

intel

### Framework : TensorFlow, PyTorch, Scikit-Learn, …

### Modèle de parallélisme : MPI, OpenMP, hybride, OpenACC, CUDA…

hybrid OpenMP-MPI

### Logiciels et bibliothèques nécessaires 

netcdf, hdf5, mpi, oasis

### Existence ou non d’un système de protection/reprise (checkpoint/restart)

restart

### Préciser le besoin éventuel de visualisation déportée, de post-traitement (nœuds à grande mémoire par exemple)

### Préciser éventuellement les outils nécessaires




