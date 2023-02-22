montage bathy_eORCA36_atl.png bathy_eORCA36_pac.png bathy_eORCA36_npole.png bathy_eORCA36_spole.png -geometry 503x503 -tile 2x2 -quality 100 all_bathys.png
convert all_bathys.png -trim -bordercolor White -border 20x10 +repage all_bathys.png

