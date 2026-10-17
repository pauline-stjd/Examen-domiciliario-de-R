
# Ejercicio Simulación 2: Simulación de ataque en el juego TEG

set.seed(123)

source("funciones.R")

# 1. Prueba de un ataque puntual
ej_ataque <- resultado_ataque(n_dados_at = 3, n_dados_def = 3)
cat("\nResultado de un ataque puntual (3 vs 3):\n"); print(ej_ataque)

# 2. Simulación de una batalla completa
ej_batalla <- sim_batalla(fichas_at = 5, fichas_def = 5)
cat("\n¿El atacante ganó la batalla completa?:\n") ; print(ej_batalla)

# 3. Probabilidad de victoria
prob_vict <- proba_ataque(fichas_at = 5, fichas_def = 5, n_sim = 1000)
cat("\nProbabilidad estimada de conquistar el territorio (5 vs 5):\n"); print(prob_vict)

