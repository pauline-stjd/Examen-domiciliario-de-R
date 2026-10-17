
# Funciones para Ejercicio Simulación 2: Simulación de ataque en el juego TEG

# 1. Comparación de dados en un ataque
  # Tirar dados y ordenar de mayor a menor
  resultado_ataque <- function(n_dados_at, n_dados_def) {
    dados_at  <- sort(sample(1:6, size = n_dados_at, replace = TRUE), decreasing = TRUE)
    dados_def <- sort(sample(1:6, size = n_dados_def, replace = TRUE), decreasing = TRUE)
    
    # Comparamos cada dados entre los dos jugadores y cuantas fichas pierden 
    n_comparaciones <- min(n_dados_at, n_dados_def)
    
    fichas_perdidas_at  <- 0
    fichas_perdidas_def <- 0
    
    for (i in 1:n_comparaciones) {
      if (dados_at[i] > dados_def[i]) {
        fichas_perdidas_def <-  fichas_perdidas_def + 1
      } else {
        fichas_perdidas_at  <-  fichas_perdidas_at + 1
      }
    }
    
    return(c( fichas_perdidas_at =  fichas_perdidas_at,  fichas_perdidas_def =  fichas_perdidas_def))
  }

# 2. Simulación de una batalla completa
sim_batalla <- function(fichas_at, fichas_def) {
  while (fichas_at > 1 && fichas_def > 0) {
    # El atacante puede usar máximo 3 dados, debe tener suficientes fichas y necesita al menos 1 ficha para quedarse en el territorio
    dados_at  <- min(fichas_at - 1, 3)
    dados_def <- min(fichas_def, 3)
    
    res <- resultado_ataque(dados_at, dados_def)
    
    fichas_at  <- fichas_at - res["fichas_perdidas_at"]
    fichas_def <- fichas_def - res["fichas_perdidas_def"]
  }
  
  # TRUE significa que el atacante conquistó el territorio porque el defensor se quedó sin fichas
  return(fichas_def == 0)
}

# 3. Estimación de probabilidad
proba_ataque <- function(fichas_at, fichas_def, n_sim) {
  resultados <- replicate(n_sim, sim_batalla(fichas_at, fichas_def))
  total_victorias <- sum(resultados) #cuenta los TRUE (porque True vale 1 y un False vale 0)
  
  return(total_victorias / n_sim)
}
