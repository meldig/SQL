## Méthodologie mise en place pour intégrer les données OSM en BASE.

1. Téléchargement des données:
Sur le de géofabrik
http://download.geofabrik.de/europe/france/nord-pas-de-calais.html

2. extraction du fichier .osm contenu dans le fichier .pbf.
```sh
osmosis --read-pbf myFile.osm.pbf --bounding-box top=50.794448377057 left=2.78824307841151 bottom=50.4995835747462 right=3.2719212468744 --write-xml myFile.osm
```

3. extraction avec OSMOSIS

* 3.1 Extraction des polygones
```sh
osmosis --read-xml C:\Users\rjault\Documents\02_DEMANDE\13_OSM_ORACLE\WAY_MULTYPOLYGON_MEL\OSMOSIS\nord_pas_de_calais_latest.osm --way-key-value keyValueList="amenity.school,amenity.kindergarten,amenity.post_office,amenity.townhall,amenity.police,amenity.pharmacy,amenity.toilets,amenity.place_of_workship,amenity.recycling,amenity.drinking_water,amenity.water_point,waterway.water_point,amenity.bench,natural.tree_row,natural.tree,tourism.information,amenity.bicycle_parking,amenity.motorcycle_parking,amenity.parking,amenity.parking_entrance,amenity.parking_space,building.parking,service.parking,building.toilets,highway.footway,highway.pedestrian,amenity.courthouse,amenity.embassy,building.government,building.public,office.diplomatic,office.government,amenity.grave_yard,historic.tomb,shop.golf,amenity.cinema,amenity.theatre,tourism.gallery,tourism.museum,amenity.library,amenity.toy_library,amenity.music_school,amenity.arts_centre,amenity.community_centre,amenity.planetarium,amenity.studio,craft.atelier,historic.church,historic.monument,historic.tower,tourism.aquarium,tourism.artwork,tourism.attraction,tourism.zoo,leisure.ice_rink,leisure.beach_resort,leisure.bandstand,leisure.dog_park,leisure.fitness_centre,leisure.fitness_station,leisure.garden,leisure.horse_riding,leisure.miniature_golf,leisure.park,leisure.playground,leisure.sports_centre,leisure.stadium,leisure.swimming_pool,sport.table_soccer,sport.toboggan,tourism.camp_pitch,tourism.camp_site,amenity.clinic,amenity.hospital,building.hospital,amenity.social_facility,amenity.social_centre,building.kindergarten,amenity.place_of_worship,amenity.college,building.school,building.conservatory,amenity.university,building.university,amenity.fire_station,military.barracks,building.riding_hall,building.sports_hall,building.stadium,sport.american_football,sport.australian_football,sport.bandy,sport.baseball,sport.basketball,sport.canadian_football,sport.cricket,sport.croquet,sport.curling,sport.equestrian,sport.gaelic_games,sport.golf,sport.horse_racing,sport.ice_hockey,sport.karting,sport.martial_arts,sport.motor,sport.multi,sport.obstacle_course,sport.paddle_tennis,sport.rc_car,sport.rugby_league,sport.rugby_union,sport.swimming,sport.ice_skating,sport.ice_stock,sport.9pin,sport.10pin,sport.aikido,sport.archery,sport.athletics,sport.badminton,sport.beachvolleyball,sport.billiards,sport.bmx,sport.boules,sport.bowls,sport.boxing,sport.bullfighting,sport.canoe,sport.chess,sport.cliff_diving,sport.climbing,sport.climbing_adventure,sport.cockfighting,sport.cycling,sport.darts,sport.dog_racing,sport.fencing,sport.field_hockey,sport.free_flying,sport.futsal,sport.gymnastics,sport.handball,sport.hapkido,sport.horseshoes,sport.judo,sport.karate,sport.kitesurfing,sport.korfball,sport.krachtbal,sport.lacrosse,sport.model_aerodrome,sport.motocross,sport.netball,sport.orienteering,sport.padel,sport.parachuting,sport.pelota,sport.racquet,sport.roller_skating,sport.rowing,sport.running,sport.sailing,sport.scuba_diving,sport.shooting,sport.skateboard,sport.soccer,sport.sumo,sport.surfing,sport.table_tennis,sport.taekwondo,sport.tennis,sport.volleyball,sport.water_polo,sport.water_ski,sport.weightlifting,sport.wrestling,sport.yoga,aeroway.aerodrome,aeroway.helipad,aeroway.heliport,aeroway.spaceport,amenity.bus_station,building.train_station,building.industrial,office.employment_agency,landuse.retail,amenity.waste_basket,building.retail,landuse.port,place.square,sport.bobsleigh,social_facility.group_home,social_facility.nursing_home,social_facility.assisted_living,industrial.port,landuse.industrial,service.parking_aisle,service.alley" --tf reject-relation --used-node --bounding-box top=50.794448377057 left=2.78824307841151 bottom=50.4995835747462 right=3.2719212468744 --write-xml C:\Users\rjault\Documents\02_DEMANDE\13_OSM_ORACLE\WAY_MULTYPOLYGON_MEL\OSMOSIS\extraction_f\extraction_relation.osm
```

* 3.2 extration des nodes
```sh
osmosis --read-xml C:\Users\rjault\Documents\02_DEMANDE\13_OSM_ORACLE\WAY_MULTYPOLYGON_MEL\OSMOSIS\nord_pas_de_calais_latest.osm --node-key-value keyValueList="amenity.school,amenity.kindergarten,amenity.post_office,amenity.townhall,amenity.police,amenity.pharmacy,amenity.toilets,amenity.place_of_workship,amenity.recycling,amenity.drinking_water,amenity.water_point,waterway.water_point,amenity.bench,natural.tree_row,natural.tree,tourism.information,amenity.bicycle_parking,amenity.motorcycle_parking,amenity.parking,amenity.parking_entrance,amenity.parking_space,building.parking,service.parking,building.toilets,highway.footway,highway.pedestrian,amenity.courthouse,amenity.embassy,building.government,building.public,office.diplomatic,office.government,amenity.grave_yard,historic.tomb,shop.golf,amenity.cinema,amenity.theatre,tourism.gallery,tourism.museum,amenity.library,amenity.toy_library,amenity.music_school,amenity.arts_centre,amenity.community_centre,amenity.planetarium,amenity.studio,craft.atelier,historic.church,historic.monument,historic.tower,tourism.aquarium,tourism.artwork,tourism.attraction,tourism.zoo,leisure.ice_rink,leisure.beach_resort,leisure.bandstand,leisure.dog_park,leisure.fitness_centre,leisure.fitness_station,leisure.garden,leisure.horse_riding,leisure.miniature_golf,leisure.park,leisure.playground,leisure.sports_centre,leisure.stadium,leisure.swimming_pool,sport.table_soccer,sport.toboggan,tourism.camp_pitch,tourism.camp_site,amenity.clinic,amenity.hospital,building.hospital,amenity.social_facility,amenity.social_centre,building.kindergarten,amenity.place_of_worship,amenity.college,building.school,building.conservatory,amenity.university,building.university,amenity.fire_station,military.barracks,building.riding_hall,building.sports_hall,building.stadium,sport.american_football,sport.australian_football,sport.bandy,sport.baseball,sport.basketball,sport.canadian_football,sport.cricket,sport.croquet,sport.curling,sport.equestrian,sport.gaelic_games,sport.golf,sport.horse_racing,sport.ice_hockey,sport.karting,sport.martial_arts,sport.motor,sport.multi,sport.obstacle_course,sport.paddle_tennis,sport.rc_car,sport.rugby_league,sport.rugby_union,sport.swimming,sport.ice_skating,sport.ice_stock,sport.9pin,sport.10pin,sport.aikido,sport.archery,sport.athletics,sport.badminton,sport.beachvolleyball,sport.billiards,sport.bmx,sport.boules,sport.bowls,sport.boxing,sport.bullfighting,sport.canoe,sport.chess,sport.cliff_diving,sport.climbing,sport.climbing_adventure,sport.cockfighting,sport.cycling,sport.darts,sport.dog_racing,sport.fencing,sport.field_hockey,sport.free_flying,sport.futsal,sport.gymnastics,sport.handball,sport.hapkido,sport.horseshoes,sport.judo,sport.karate,sport.kitesurfing,sport.korfball,sport.krachtbal,sport.lacrosse,sport.model_aerodrome,sport.motocross,sport.netball,sport.orienteering,sport.padel,sport.parachuting,sport.pelota,sport.racquet,sport.roller_skating,sport.rowing,sport.running,sport.sailing,sport.scuba_diving,sport.shooting,sport.skateboard,sport.soccer,sport.sumo,sport.surfing,sport.table_tennis,sport.taekwondo,sport.tennis,sport.volleyball,sport.water_polo,sport.water_ski,sport.weightlifting,sport.wrestling,sport.yoga,aeroway.aerodrome,aeroway.helipad,aeroway.heliport,aeroway.spaceport,amenity.bus_station,building.train_station,building.industrial,office.employment_agency,landuse.retail,amenity.waste_basket,building.retail,landuse.port,place.square,sport.bobsleigh,social_facility.group_home,social_facility.nursing_home,social_facility.assisted_living,industrial.port,landuse.industrial,service.parking_aisle,service.alley" --bounding-box top=50.794448377057 left=2.78824307841151 bottom=50.4995835747462 right=3.2719212468744 --write-xml C:\Users\rjault\Documents\02_DEMANDE\13_OSM_ORACLE\WAY_MULTYPOLYGON_MEL\OSMOSIS\extraction_f\extraction_node.osm
```

4. conversion des fichiers obtenus aux étapes précédentes en GPKG.
* 4.1: 
```sh
ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:2154 -f GPKG extraction_relation.gpkg extraction_relation.osm```
```
* 4.2: 
```sh
ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:2154 -f GPKG extraction_node.gpkg extraction_node.osm```
```

5. pré-traitement sous qgis
* 5.1: intersection avec la MEL
* 5.2: hstore sur le champs othertag

6. Importer les données dans ORACLE
```sh
ogr2ogr -f OCI OCI:G_OSM/ad1mOSMd?@MULTIT: FICHIER_GPKG -s_srs EPSG:2154 -t_srs EPSG:2154 -lco ENCODING=UTF-8 -lco LAUNDER=YES -lco GEOMETRY_NAME=GEOM -lco OCI_FID=OBJECTID -nln NOM_TABLE_EN_BASE
```

```sh
ogr2ogr -f OCI OCI:G_OSM/ad1mOSMd?@MULTIT: FICHIER_GPKG -s_srs EPSG:2154 -t_srs EPSG:2154 -lco ENCODING=UTF-8 -lco LAUNDER=YES -lco GEOMETRY_NAME=GEOM -lco OCI_FID=OBJECTID -nln NOM_TABLE_EN_BASE
```

7. Execution des commandes SQL dans l'ordre:
* 1. G_OSM_STRUCTURE
* 2. G_OSM_MISE_EN_FORME_TABLE_TEMP.sql
* 3. G_OSM_NORMALISATION.sql
* 4. VM_OSM_PIVOT_MULTIPOLYGONE.sql
* 5. VM_OSM_PIVOT_POINT.sql
* 6. VM_OSM_POINT.sql
* 7. VM_OSM_MULTIPOLYGON.sql