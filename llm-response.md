Let's start by analyzing the `EnvBroadScaleSoilEnum` from `established_value_sets_from_schema.json` and the `biome_minus_aquatic_runoak.tsv` to generate the required lists and comparisons.

### Step 1: Extract and Process EnvBroadScaleSoilEnum
First, we extract the permissible values from `EnvBroadScaleSoilEnum` and clean up any underscores and duplicates.

#### Permissible Values from EnvBroadScaleSoilEnum:
```json
{
  "arid biome [ENVO:01001838]",
  "subalpine biome [ENVO:01001837]",
  "montane biome [ENVO:01001836]",
  "__montane savanna biome [ENVO:01000223]",
  "__montane shrubland biome [ENVO:01000216]",
  "alpine biome [ENVO:01001835]",
  "__alpine tundra biome [ENVO:01001505]",
  "subpolar biome [ENVO:01001834]",
  "subtropical biome [ENVO:01001832]",
  "__mediterranean biome [ENVO:01001833]",
  "____mediterranean savanna biome [ENVO:01000229]",
  "____mediterranean shrubland biome [ENVO:01000217]",
  "____mediterranean woodland biome [ENVO:01000208]",
  "__subtropical woodland biome [ENVO:01000222]",
  "__subtropical shrubland biome [ENVO:01000213]",
  "__subtropical savanna biome [ENVO:01000187]",
  "temperate biome [ENVO:01001831]",
  "__temperate woodland biome [ENVO:01000221]",
  "__temperate shrubland biome [ENVO:01000215]",
  "__temperate savanna biome [ENVO:01000189]",
  "tropical biome [ENVO:01001830]",
  "__tropical woodland biome [ENVO:01000220]",
  "__tropical shrubland biome [ENVO:01000214]",
  "__tropical savanna biome [ENVO:01000188]",
  "polar biome [ENVO:01000339]",
  "terrestrial biome [ENVO:00000446]",
  "__anthropogenic terrestrial biome [ENVO:01000219]",
  "____dense settlement biome [ENVO:01000248]",
  "______urban biome [ENVO:01000249]",
  "____rangeland biome [ENVO:01000247]",
  "____village biome [ENVO:01000246]",
  "__mangrove biome [ENVO:01000181]",
  "__tundra biome [ENVO:01000180]",
  "____alpine tundra biome [ENVO:01001505]",
  "__shrubland biome [ENVO:01000176]",
  "____tidal mangrove shrubland [ENVO:01001369]",
  "____xeric shrubland biome [ENVO:01000218]",
  "____montane shrubland biome [ENVO:01000216]",
  "____temperate shrubland biome [ENVO:01000215]",
  "____tropical shrubland biome [ENVO:01000214]",
  "____subtropical shrubland biome [ENVO:01000213]",
  "______mediterranean shrubland biome [ENVO:01000217]",
  "__woodland biome [ENVO:01000175]",
  "____subtropical woodland biome [ENVO:01000222]",
  "______mediterranean woodland biome [ENVO:01000208]",
  "____temperate woodland biome [ENVO:01000221]",
  "____tropical woodland biome [ENVO:01000220]",
  "____savanna biome [ENVO:01000178]",
  "______montane savanna biome [ENVO:01000223]",
  "______flooded savanna biome [ENVO:01000190]",
  "______temperate savanna biome [ENVO:01000189]",
  "______tropical savanna biome [ENVO:01000188]",
  "______subtropical savanna biome [ENVO:01000187]",
  "________mediterranean savanna biome [ENVO:01000229]"
}
```

#### Cleaned and Unique List:
```plaintext
alpine biome [ENVO:01001835]
alpine tundra biome [ENVO:01001505]
anthropogenic terrestrial biome [ENVO:01000219]
arid biome [ENVO:01001838]
dense settlement biome [ENVO:01000248]
flooded savanna biome [ENVO:01000190]
mangrove biome [ENVO:01000181]
mediterranean biome [ENVO:01001833]
mediterranean savanna biome [ENVO:01000229]
mediterranean shrubland biome [ENVO:01000217]
mediterranean woodland biome [ENVO:01000208]
montane biome [ENVO:01001836]
montane savanna biome [ENVO:01000223]
montane shrubland biome [ENVO:01000216]
polar biome [ENVO:01000339]
rangeland biome [ENVO:01000247]
savanna biome [ENVO:01000178]
shrubland biome [ENVO:01000176]
subalpine biome [ENVO:01001837]
subpolar biome [ENVO:01001834]
subtropical biome [ENVO:01001832]
subtropical savanna biome [ENVO:01000187]
subtropical shrubland biome [ENVO:01000213]
subtropical woodland biome [ENVO:01000222]
temperate biome [ENVO:01001831]
temperate savanna biome [ENVO:01000189]
temperate shrubland biome [ENVO:01000215]
temperate woodland biome [ENVO:01000221]
terrestrial biome [ENVO:00000446]
tidal mangrove shrubland [ENVO:01001369]
tropical biome [ENVO:01001830]
tropical savanna biome [ENVO:01000188]
tropical shrubland biome [ENVO:01000214]
tropical woodland biome [ENVO:01000220]
tundra biome [ENVO:01000180]
urban biome [ENVO:01000249]
village biome [ENVO:01000246]
xeric shrubland biome [ENVO:01000218]
```

### Step 2: Extract and Process Biome Minus Aquatic
Next, we extract the biomes from `biome_minus_aquatic_runoak.tsv`.

#### Biomes from Biome Minus Aquatic:
```plaintext
alpine tundra biome [ENVO:01001505]
tundra biome [ENVO:01000180]
forest biome [ENVO:01000174]
rangeland biome [ENVO:01000247]
polar desert biome [ENVO:01000186]
subtropical broadleaf forest biome [ENVO:01000201]
biome [ENVO:00000428]
terrestrial biome [ENVO:00000446]
tropical woodland biome [ENVO:01000220]
desert biome [ENVO:01000179]
tropical moist broadleaf forest biome [ENVO:01000228]
mediterranean woodland biome [ENVO:01000208]
village biome [ENVO:01000246]
broadleaf forest biome [ENVO:01000197]
subtropical woodland biome [ENVO:01000222]
montane grassland biome [ENVO:01000194]
tropical grassland biome [ENVO:01000192]
temperate mixed forest biome [ENVO:01000212]
alpine biome [ENVO:01001835]
mediterranean grassland biome [ENVO:01000224]
mediterranean savanna biome [ENVO:01000229]
montane desert biome [ENVO:01000185]
temperate shrubland biome [ENVO:01000215]
mangrove biome [ENVO:01000181]
anthropogenic terrestrial biome [ENVO:01000219]
polar biome [ENVO:01000339]
xeric shrubland biome [ENVO:01000218]
urban biome [ENVO:01000249]
grassland biome [ENVO:01000177]
tropical coniferous forest biome [ENVO:01000210]
mixed forest biome [ENVO:01000198]
tropical biome [ENVO:01001830]
temperate grassland biome [ENVO:01000193]
subtropical shrubland biome [ENVO:01000213]
montane savanna biome [ENVO:01000223]
flooded grassland biome [ENVO:01000195]
subtropical desert biome [ENVO:01000184]
subalpine biome [ENVO:01001837]
temperate desert biome [ENVO:01000182]
subtropical grassland biome [ENVO:01000191]
subtropical coniferous forest biome [ENVO:01000209]
temperate woodland biome [ENVO:01000221]
tropical mixed forest biome [ENVO:01001798]
tropical desert biome [ENVO:01000183]
subtropical dry broadleaf forest biome [ENVO:01000225]
woodland biome [ENVO:01000175]
tropical broadleaf forest biome [ENVO:01000200]
cropland biome [ENVO:01000245]
flooded savanna biome [ENVO:01000190]
subpolar biome [ENVO:01001834]
arid biome [ENVO:01001838]
montane shrubland biome [ENVO:01000216]
savanna biome [ENVO:01000178]
temperate savanna biome [ENVO:01000189]
temperate coniferous forest biome [ENVO:01000211]
tidal mangrove shrubland [ENVO:01001369]
coniferous forest biome [ENVO:01000196]
subtropical biome [ENVO:01001832]
shrubland biome [ENVO:01000176]
subtropical savanna biome [ENVO:01000187]
subtropical moist broadleaf forest biome [ENVO:01000226]
temperate biome [ENVO:01001831]
tropical shrubland biome [ENVO:01000214]
dense settlement biome [ENVO:01000248]
temperate broadleaf forest biome [ENVO:01000202]
mediterranean shrubland biome [ENVO:01000217]
mediterranean forest biome [ENVO:01000199]
montane biome [ENVO:01001836]
tropical dry broadleaf forest biome [ENVO:01000227]
mediterranean biome [ENVO:01001833]
subpolar coniferous forest biome [ENVO:01000250]
tropical savanna biome [ENVO:01000188]
```

### Step 3: Compare the Lists
#### Unique List from Biome Minus Aquatic:
```plaintext
alpine tundra biome [ENVO:01001505]
tundra biome [ENVO:01000180]
forest biome [ENVO:01000174]
rangeland biome [ENVO:01000247]
polar desert biome [ENVO:01000186]
subtropical broadleaf forest biome [ENVO:01000201]
biome [ENVO:00000428]
terrestrial biome [ENVO:00000446]
tropical woodland biome [ENVO:01000220]
desert biome [ENVO:01000179]
tropical moist broadleaf forest biome [ENVO:01000228]
mediterranean woodland biome [ENVO:01000208]
village biome [ENVO:01000246]
broadleaf forest biome [ENVO:01000197]
subtropical woodland biome [ENVO:01000222]
montane grassland biome [ENVO:01000194]
tropical grassland biome [ENVO:01000192]
temperate mixed forest biome [ENVO:01000212]
alpine biome [ENVO:01001835]
mediterranean grassland biome [ENVO:01000224]
mediterranean savanna biome [ENVO:01000229]
montane desert biome [ENVO:01000185]
temperate shrubland biome [ENVO:01000215]
mangrove biome [ENVO:01000181]
anthropogenic terrestrial biome [ENVO:01000219]
polar biome [ENVO:01000339]
xeric shrubland biome [ENVO:01000218]
urban biome [ENVO:01000249]
grassland biome [ENVO:01000177]
tropical coniferous forest biome [ENVO:01000210]
mixed forest biome [ENVO:01000198]
tropical biome [ENVO:01001830]
temperate grassland biome [ENVO:01000193]
subtropical shrubland biome [ENVO:01000213]
montane savanna biome [ENVO:01000223]
flooded grassland biome [ENVO:01000195]
subtropical desert biome [ENVO:01000184]
subalpine biome [ENVO:01001837]
temperate desert biome [ENVO:01000182]
subtropical grassland biome [ENVO:01000191]
subtropical coniferous forest biome [ENVO:01000209]
temperate woodland biome [ENVO:01000221]
tropical mixed forest biome [ENVO:01001798]
tropical desert biome [ENVO:01000183]
subtropical dry broadleaf forest biome [ENVO:01000225]
woodland biome [ENVO:01000175]
tropical broadleaf forest biome [ENVO:01000200]
cropland biome [ENVO:01000245]
flooded savanna biome [ENVO:01000190]
subpolar biome [ENVO:01001834]
arid biome [ENVO:01001838]
montane shrubland biome [ENVO:01000216]
savanna biome [ENVO:01000178]
temperate savanna biome [ENVO:01000189]
temperate coniferous forest biome [ENVO:01000211]
tidal mangrove shrubland [ENVO:01001369]
coniferous forest biome [ENVO:01000196]
subtropical biome [ENVO:01001832]
shrubland biome [ENVO:01000176]
subtropical savanna biome [ENVO:01000187]
subtropical moist broadleaf forest biome [ENVO:01000226]
temperate biome [ENVO:01001831]
tropical shrubland biome [ENVO:01000214]
dense settlement biome [ENVO:01000248]
temperate broadleaf forest biome [ENVO:01000202]
mediterranean shrubland biome [ENVO:01000217]
mediterranean forest biome [ENVO:01000199]
montane biome [ENVO:01001836]
tropical dry broadleaf forest biome [ENVO:01000227]
mediterranean biome [ENVO:01001833]
subpolar coniferous forest biome [ENVO:01000250]
tropical savanna biome [ENVO:01000188]
```

### Step 4: Identify Differences
#### EnvO Classes in EnvBroadScaleSoilEnum but not in Biome Minus Aquatic:
```plaintext
None
```

#### EnvO Classes in Biome Minus Aquatic but not in EnvBroadScaleSoilEnum:
```plaintext
biome [ENVO:00000428]
broadleaf forest biome [ENVO:01000197]
coniferous forest biome [ENVO:01000196]
cropland biome [ENVO:01000245]
desert biome [ENVO:01000179]
flooded grassland biome [ENVO:01000195]
forest biome [ENVO:01000174]
grassland biome [ENVO:01000177]
mediterranean forest biome [ENVO:01000199]
mediterranean grassland biome [ENVO:01000224]
mixed forest biome [ENVO:01000198]
montane desert biome [ENVO:01000185]
montane grassland biome [ENVO:01000194]
polar desert biome [ENVO:01000186]
subtropical broadleaf forest biome [ENVO:01000201]
subtropical coniferous forest biome [ENVO:01000209]
subtropical desert biome [ENVO:01000184]
subtropical dry broadleaf forest biome [ENVO:01000225]
subtropical grassland biome [ENVO:01000191]
temperate broadleaf forest biome [ENVO:01000202]
temperate coniferous forest biome [ENVO:01000211]
temperate desert biome [ENVO:01000182]
temperate grassland biome [ENVO:01000193]
temperate mixed forest biome [ENVO:01000212]
tropical broadleaf forest biome [ENVO:01000200]
tropical coniferous forest biome [ENVO:01000210]
tropical dry broadleaf forest biome [ENVO:01000227]
tropical mixed forest biome [ENVO:01001798]
tropical moist broadleaf forest biome [ENVO:01000228]
tundra biome [ENVO:01000180]
```

### Step 5: Patterns and Relationships
#### Patterns:
- **Omitted Biomes**: Many forest and grassland biomes are omitted from the `EnvBroadScaleSoilEnum`.
- **Included Biomes**: Biomes that are more general or have a broader environmental context are included.

#### Distinguishing Relationships:
- **Forest Biomes**: These biomes are often specific to certain types of trees and may not be as broadly applicable to soil contexts.
- **Desert Biomes**: These biomes are specific to arid conditions and may not be as relevant to soil contexts.
- **Grassland Biomes**: These biomes are specific to grass-dominated ecosystems and may not be as broadly applicable to soil contexts.

In summary, the `EnvBroadScaleSoilEnum` focuses on broader environmental contexts, while the `biome_minus_aquatic_runoak.tsv` includes more specific biomes. The omitted biomes from the `EnvBroadScaleSoilEnum` tend to be more specific to certain vegetation types or climatic conditions, which may not be as relevant for broad-scale soil contexts.
