
# Ejercicio 1. Análisis de Datos Deportivos: Circuito de Tenis (ATP / WTA)

data <- read.csv("data/valuebetennis-matchs-2025.csv", sep = ";")
View(data)

set.seed(123)
library(dplyr)
library(tidyr)

#Cambio los nombres de columnas (de frances a ingles)
colnames(data) <- c("match_id","date","tournament", "tournament_id","category","gender", "surface", "round", "player1","player1_id","player2","player2_id","odds1_open","odds2_open","odds1_close","odds2_close","winner_id","score","time_min")

# Pregunta 1. Entre los jugadores ATP que han disputado al menos 25 partidos esta temporada, ¿quiénes son los 10 mejores 
#en cuanto a porcentaje de victorias? 

#como un jugador puede estar en la columna player1 o player2, 
#para contar el nombre de partidos disputados, hago una sola columna con todos los id:
preg1 <- data %>%
  filter(gender == "atp") %>%
  pivot_longer(
    cols = c(player1_id, player2_id),
    names_to = "id",
    values_to = "player_id"
  ) %>%
#ahora tengo una fila para cada partido y cada jugador
#asocio sus respectivos datos con ellos:
  mutate(
    player_name = if_else(id == "player1_id", player1, player2),
    win = (player_id == winner_id)
  ) %>%
#grupo por jugador y su numero de partidos y de victorias en %:
  group_by(player_id, player_name) %>%
  summarise(
    partidos = n(), #cuantas veces aparece el jugador = # partidos disputados 
    victorias = sum(win == TRUE),
    tasa_victoria = victorias / partidos) %>%
#solo quiero los que disputaron >= 25 partidos:
  filter(partidos >= 25) %>%
  arrange(desc(tasa_victoria)) %>%  #del mejor al peor
  head(10) #los 10 mejores 

View(preg1)

mejores <- preg1$player_name
mejores

# 2. ¿Cuál es la distribución de los partidos disputados por tipo de superficie (pista dura, tierra batida, hierba)
# según el circuito (ATP vs WTA)?

library("ggplot2")
# ATP grafico
data_atp <- filter(data, gender == "atp" & surface %in% c("dur", "terre battue", "gazon"))
data_wta <- filter(data, gender == "wta" & surface %in% c("dur", "terre battue", "gazon"))

ggplot(data_atp, aes(x = surface, fill = surface)) +
  geom_bar() +
  ggtitle("Distribución de las canchas (ATP)") +
  xlab("Cancha") + 
  ylab("Partidos")+
scale_x_discrete(
  labels = c("dur" = "Dura", "gazon" = "Césped", "terre battue" = "Tierra batida")
) 

# Graphique 2 : WTA
ggplot(data_wta, aes(x = surface, fill = surface)) +
  geom_bar() +
  ggtitle("Distribución de las canchas (WTA)") +
  xlab("Cancha") + 
  ylab("Partidos")+
  scale_x_discrete(
    labels = c("dur" = "Dura", "gazon" = "Césped", "terre battue" = "Tierra batida")
  ) 


# 3. ¿Cuáles son los porcentajes de victorias en cada tipo de superficie
# de Grand Slam de los ganadores de cada Grand Slam?

#Los ganadores y las ganadoras
ganadores <- data %>%
  filter(category == "Grand Chelem" & round == 12) %>% # == 12 porque es el ultimo torno (= la final)
  select(tournament, surface, winner_id, gender)

View(ganadores)
print(ganadores)

#quiero una fila para cada jugador y cada partido
stats_ganadores <- data %>%
  pivot_longer(
    cols = c(player1_id, player2_id),
    names_to = "id",
    values_to = "player_id"
  ) %>%
#solo datos de los ganadores, ganadoras y de las canchas de Grand Chelem
  filter(
    player_id %in% ganadores$winner_id,
    surface %in% c("dur", "terre battue", "gazon")
  ) %>%
# y si ganaron o no
  mutate(
    player_name = if_else(id == "player1_id", player1, player2),
    win = (player_id == winner_id),
  ) %>%
# grupo por gender, jugador y cancha 
  group_by(gender, player_id, player_name, surface) %>%
  summarise(
    partidos = n(),
    victorias = sum(win == TRUE),
    tasa_victoria = victorias / partidos)%>%
  left_join(
    ganadores %>% select(winner_id, surface, tournament), #hago un join con los datos de quien gano cada Grand Chelem, asi se ve en stats_ganadores si el jugador a ganado un Grand Chelem de esta cancha en particular
    by = c("player_id" = "winner_id", "surface" = "surface")
  )
View(stats_ganadores)
print(stats_ganadores)





          