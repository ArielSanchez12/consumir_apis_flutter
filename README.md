##PokeAPI para buscar informacion de Pokemon y Numverify para validar numeros telefonicos internacionales.


**1. Buscador de Pokemon**
- Permite buscar cualquier Pokemon por su nombre
- Muestra la imagen del pokemon
- Presenta todas las estadisticas incluyendo:
  - Altura y peso
  - Tipos 
  - Habilidades
  - Estadisticas base

**2. Validador de Numeros Telefonicos**
- Valida numeros de telefono de cualquier pais
- Muestra informacion detallada del numero:
  - Si el numero es valido o no
  - Formato local e internacional
  - Pais y codigo de pais
  - Operador telefonico
  - Tipo de linea


## APIs Utilizadas
1. **PokeAPI** - https://pokeapi.co/
   - API gratuita
   - Endpoint: `https://pokeapi.co/api/v2/pokemon/{nombre}`

2. **Numverify** - https://numverify.com/
   - Requiere API key (plan gratuito)
   - Endpoint: `http://apilayer.net/api/validate`



## Instalacion

1. Clonar el repositorio:
```
git clone https://github.com/tu-usuario/pokemonapi_flutter.git
```

2. Navegar al directorio del proyecto:
```
cd pokemonapi_flutter
```

3. Instalar las dependencias:
```
flutter pub get
```

4. Ejecutar la aplicacion:
```
flutter run
```


### Buscar un Pokemon
1. Abrir la aplicacion (por defecto muestra la pestana de Pokemon)
2. Escribir el nombre del Pokemon
3. Presionar el boton "Buscar" y se muestra la información

### Validar un Numero Telefonico
1. Navegar a la pestana "Validar Telefono" en la barra inferior
2. Seleccionar el pais (el prefijo se agrega automaticamente)
3. Escribir el numero de telefono SIN el prefijo
4. Presionar el boton "Validar"
5. Se mostrara si el numero es valido junto con toda su informacion

## Configuracion de API Key
Para la funcionalidad de validacion de telefonos, se requiere una API key de Numverify. Para obtener una:
1. Ir a https://numverify.com/
