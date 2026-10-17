# Examen domiciliario de R

**Institución:** Universidad Torcuato Di Tella

**Materia:** Laboratorio para el Análisis de Datos Económicos y Financieros

## Descripción del trabajo

Este repositorio contiene la resolución práctica del examen de R. El trabajo está dividido en tres ejercicios, uno de rendimiento deportivo en el tenis (ATP / WTA), uno de análisis econométrico con datos de `Gapminder`, y un ejercicio de simulación sobre el juego **TEG**.

## Estructura del repositorio

Para garantizar la modularidad y cumplir con los requerimientos del curso, el código se organiza de la siguiente manera:

```
Examen-domiciliario-de-R/
|-- README.md
|-- informe.pdf
|-- analisis_datos/
| |-- script_principal.R
| ‘-- data/
|-- analisis_econometrico/
| |-- script_principal.R
| ‘-- data/
‘-- simulacion/
    |-- script_principal.R
    |-- funciones.R
    
```

## Detalle de los ejercicios y archivos

### 1. Análisis de datos (`analisis_datos/`)

* **`script_principal.R`** (basado en el análisis datos de tenis):

  * **Análisis Deportivo (Tenis 2025):** Cambio los nombres  de variables (de francés a ingles) y respondo a tres preguntas;

  1. ¿Entre los jugadores ATP que han disputado al menos 25 partidos esta temporada, ¿quiénes son los 10 mejores en cuanto a porcentaje de victorias?

  2. ¿Cuál es la distribución de los partidos disputados por tipo de superficie (pista dura, tierra batida, hierba) según el circuito (ATP vs WTA)?

  3. ¿Cuáles son los porcentajes de victorias en cada tipo de superficie de Grand Slam de los ganadores de cada Grand Slam?

### 2. Análisis econométrico con datos de gapminder (`analisis_econometrico/`)

* **`script_principal.R`** (basado en el análisis de `Gapminder)`

  * **Análisis Econométrico (Gapminder - Argentina):** Evolución del ingreso per cápita ($1960-2010$), partición de datos en entrenamiento/prueba (*Train/Test*) y evaluación de *overfitting* mediante regresiones polinómicas de Grado 1, 2 y 10 con métricas de error RMSE.

  * **Matriz de Correlaciones:** Análisis de niveles e incrementos logarítmicos del PIB para países de Sudamérica (Argentina, Brasil, Chile, Ecuador, Bolivia).

  * **Modelos Econométricos (Esperanza de Vida 2010):**

    * Regresión lineal simple entre esperanza de vida total y femenina.

    * Test de hipótesis (*paired t-test*) sobre la brecha de género en longevidad.

    * Regresión múltiple controlando por el logaritmo del ingreso per cápita $\log(\text{income\_per\_person})$.

    * Modelo de 3 covariables socioeconómicas (mortalidad infantil, fecundidad e ingreso) previniendo la redundancia tautométrica.

### 3. Simulación 2: Simulación de ataque en el juego TEG (`simulacion/`)

* **`funciones.R`**:

  * `resultado_ataque(n_dados_at, n_dados_def)`: Simula un evento puntual de tirada de dados ordenados de mayor a menor, aplicando la regla de desempate a favor del defensor.

  * `sim_batalla(fichas_at, fichas_def)`: Modela el bucle completo de combate hasta la conquista del territorio o el retiro del atacante al quedar con 1 ficha.

  * `proba_ataque(fichas_at, fichas_def, n_sim)`: Realiza la simulación de Monte Carlo calculando la proporción empírica de victorias en n_sim repeticiones.

* **`script_principal.R`**:

  * Establece la semilla de reproducibilidad (`set.seed(123)`).

  * Carga las funciones mediante `source("funciones.R")`.

  * Ejecuta una prueba unitaria de ataque, una batalla individual y estima la probabilidad de éxito final para el escenario de 5 fichas contra 5.

## Instrucciones de Ejecución

1. Abrir el proyecto en **RStudio**.

2. Asegurarse de tener instaladas las librerías necesarias:

   ```
   install.packages(c("dplyr", "tidyr", "ggplot2", "gapminder"))
   
   ```

3. **Ejecutar Ejercicio de Analísis de datos:**

   * Abrir `analisis_datos/script_principal.R` y ejecutar el script completo.

4. **Ejecutar Ejercicio de Analísis de datos Análisis econométrico con datos de gapminder**:

   * Abrir `analisis_econometrico/script_principal.R` y ejecutar el script completo.

5. **Ejecutar Ejercicio de Simulación 2 (TEG):**

   * Abrir `simulacion/script_principal.R` y ejecutar para obtener las estimaciones de Monte Carlo.

6. Consultar `informe.pdf` para el desglose detallado de las interpretaciones económicas y justificaciones teóricas.
