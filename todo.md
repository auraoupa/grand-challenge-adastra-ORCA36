# Préparation du Grand Challenge Adastra 2023

Candidature à envoyer avant le 3 avril 2023, période de calcul du 1er mai au 30 octobre 2023

[Formulaire candidature](https://docs.google.com/document/d/1sYsiWFdsBWbVlIHc4_Rdj9_NR8Cs5YrWHw384CFlBQ4/edit?usp=sharing)

## Actions d'ici début avril

  - [ ] Elaborer stratégie de run et calendrier
  - [ ] Quantifier précisément CPU et stockage
  - [ ] Ecrire la candidature : [premier jet](https://docs.google.com/document/d/1sYsiWFdsBWbVlIHc4_Rdj9_NR8Cs5YrWHw384CFlBQ4/edit?usp=sharing)
  
  
## Actions d'ici début mai 

  -  [ ] nouvelle bathymétrie et correction trait de côte (gros travail de Pierre Mathiot et Jean-Marc Molines)
  
En attendant que la bathy soit prête :

  - [ ] [tester SI3 via OASIS dans maquette au 1/2°](oasis.md)
  - [ ] porter en 4.2 et tester SPLIT_ORCA sur maquette au 1/2° (voir avec Eric Maisonnave si besoin)
  - [ ] [implémenter xios 3 (demander le commit à Seb Masson)](xios3.md)
  - [ ] implémenter RK3 (demander si c'est assez mûr à Jérôme Chanut)
  - [ ] implémenter skin temperature (demander à Laurent Brodeau)
  - [ ] implémenter run barotrope maquette (discussion avec Julien et Clément Ubelmann)
  - [ ] élaborer stratégie de sorties et quantifier le stockage
  - [ ] [compiler xios oasis nemo sur Adastra avec compilateurs natifs (check infos fournies par Adam Blaker)](install_adastra.md)
  - [ ] quand tout est en place porter maquette sur ROME (AMD nodes) pour mieux évaluer performances

Une fois la nouvelle bathy prête :
  
  - [ ] créer domain.nc
  - [ ] refaire les runoffs ?
  - [ ] récupérer tous les fichiers de Clément Bricaud (loading de marée, chla ...)
  - [ ] créer état initial pour les cavités (avec l'aide de Pierre Mathiot)
  - [ ] interpolation état initial (WOA ? moyenne mensuelle réanalyses GLORYS12 ?)
  - [ ] calcul des poids pour forçages ou interpolation sur la grille (JRA55 ou ERA5 ?)
  - [ ] quelques pas de temps sur ROME ? (292 608 coeurs)
  
